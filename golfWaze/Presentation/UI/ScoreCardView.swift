//
//  SwiftUIView.swift
//  golfWaze
//
//  Created by Naveed Tahir on 13/01/2026.
//
import SwiftUI

struct ScorecardView: View {

    let holes = Array(1...18)
    let par = [4,5,4,3,5,4,4,4,3, 4,5,4,3,5,4,4,4,3]
    let handicap = [7,18,5,1,6,10,4,2,9, 7,18,5,1,6,10,4,2,9]

    @EnvironmentObject var coordinator: TabBarCoordinator
    @State private var showUpdateCard = false
    @State private var refreshID = UUID()
    @State private var showFinishSheet = false
    @ObservedObject var finishRoundVM = FinishRoundViewModel()
    @ObservedObject var trafficVM = LiveTrafficViewModel()
    @State private var showDeletePopup = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack(spacing: 0) {

                HeaderView {
                    coordinator.pop()
                }

                HStack(spacing: 0) {

                    // LEFT FIXED COLUMN
                    VStack(alignment: .leading, spacing: 0) {
                        fixedRow("Hole", height: 40, background: Color(red: 0.38, green: 0.47, blue: 0.58), foregroundColor: .white)
                        fixedDoubleRow("Par", secondtitle: "Handicap", height: 70)
                        fixedRow("Score", height: 40)
                        fixedRow("Putts", height: 40)
                        fixedRow("Fairways", height: 50)
                        fixedRow("Greens", height: 50)
                        fixedRow("Chip Shots", height: 50)
                        fixedRow("Greenside Sand", height: 50)
                        fixedRow("Penalties", height: 40)
                    }
                    .frame(width: 90)
                    .background(Color.white)

                    // SCROLLING CONTENT
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {

                            numberRow(holes.map { "\($0)" }, height: 40, isHeader: true)

                            doubleTextRow(
                                par.map { "\($0)" },
                                sub: handicap.map { "\($0)" },
                                height: 70
                            )

                            // Score
                            numberRow(holes.map { hole in
                                let model = ScorecardStorage.shared.load(hole: hole)
                                return model.score != nil ? "\(model.score!)" : "-"
                            }, height: 40)

                            // Putts
                            numberRow(holes.map { hole in
                                let model = ScorecardStorage.shared.load(hole: hole)
                                return model.putts != nil ? "\(model.putts!)" : "-"
                            }, height: 40)

                            // Fairways
                            boolRow(holes.map { hole in
                                ScorecardStorage.shared.load(hole: hole).fairwayHit
                            })

                            // GIR
                            boolRow(holes.map { hole in
                                ScorecardStorage.shared.load(hole: hole).gir
                            })

                            // Chip Shots
                            numberRow(holes.map { hole in
                                let model = ScorecardStorage.shared.load(hole: hole)
                                return model.chipShots != nil ? "\(model.chipShots!)" : "-"
                            }, height: 50)

                            // Sand Shots
                            numberRow(holes.map { hole in
                                let model = ScorecardStorage.shared.load(hole: hole)
                                return model.sandShots != nil ? "\(model.sandShots!)" : "-"
                            }, height: 50)

                            // Penalties
                            numberRow(holes.map { hole in
                                let model = ScorecardStorage.shared.load(hole: hole)
                                return model.penalties != nil ? "\(model.penalties!)" : "-"
                            }, height: 40)
                        }
                        .id(refreshID)
                    }

                    // RIGHT FIXED TOTALS
                    VStack(spacing: 0) {
                        totalCell("Total", height: 40, bold: true, color: .white, background: Color(red: 0.38, green: 0.47, blue: 0.58))
                        totalCell("\(totalPar())", height: 70, color: .red)
                        totalCell("\(totalScore())", height: 40, color: .red)
                        totalCell("\(totalPutts())", height: 40, color: .red)
                        totalCell("\(totalTrue(\.fairwayHit))", height: 50, color: .red)
                        totalCell("\(totalTrue(\.gir))", height: 50, color: .red)
                        totalCell("\(totalChipShots())", height: 50, color: .red)
                        totalCell("\(totalSandShots())", height: 50, color: .red)
                        totalCell("\(totalPenalties())", height: 40, color: .red)
                    }
                    .frame(width: 70)
                    .background(Color.white)
                }

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            
            HStack(spacing: 12) {
                
                AppButton("Edit Score Card", .primary) {
                    showUpdateCard = true
                }
                
                AppButton("Finish Round", .secondary) {
                    showFinishSheet = true
                }
            }
            .padding()
        }
        .sheet(isPresented: $showUpdateCard, onDismiss: {
            refreshID = UUID()
        }) {
            HoleStatsView(finishHole: {
                showUpdateCard = false
                showFinishSheet = true
            })
                .presentationDetents([.large])
        }
        .overlay {
            if showFinishSheet {
                FinishRoundOverlay(
                    onCompleteScorecard: {
                        showFinishSheet = false
                    },
                    onFinishAndExit: {
                        submitFinishRound()
                    },
                    onDelete: {
                        showFinishSheet = false
                        showDeletePopup = true
                    },
                    onDismiss: {
                        showFinishSheet = false
                    }
                )
            }
        }
        .onChange(of: finishRoundVM.finishSuccess) { success in
            if success {
                UserDefaults.standard.clearSavedRound()
                ScorecardStorage.shared.clearAll()
                coordinator.popToRoot()
            }
        }
        .onChange(of: trafficVM.deleteSuccess) { success in
            if success {
                trafficVM.deleteSuccess = false
                UserDefaults.standard.clearSavedRound()
                showDeletePopup = false
                self.coordinator.popToRoot()
            }
        }
        .sheet(isPresented: $showDeletePopup) {
            DeleteRoundPopup {
                if let round = UserDefaults.standard.loadRound() {
                    trafficVM.deleteRound(roundId: round.round_id ?? "")
                }
            } onDismiss: {
                showDeletePopup = false
            }
            .presentationDetents([.height(160)])
        }
        .alert("Error", isPresented: .constant(finishRoundVM.errorMessage != nil)) {
            Button("OK") {
                finishRoundVM.errorMessage = nil
            }
        } message: {
            Text(finishRoundVM.errorMessage ?? "")
        }
    }

    func submitFinishRound() {
        showFinishSheet = false
        
        let userId = SessionManager.load()?.id ?? 0
        
        let scoresPayload = buildScoresPayload(playerId: userId)
        let totalScore = calculateTotalScore()
        
        let request = FinishRoundRequest(
            token: SessionManager.load()?.accessToken ?? "",
            round_id: UserDefaults.standard.loadRound()?.round_id ?? "",
            round_finished: true,
            finish_context: FinishContext(
                reason: "finished_round",
                user_id: userId
            ),
            total_score: TotalScore(
                player_id: "\(userId)",
                total_score: totalScore
            ),
            scores: scoresPayload
        )
        
        finishRoundVM.finishRound(request: request)
    }
    // MARK: - Totals
    func buildScoresPayload(playerId: Int) -> [ScorePayload] {
        var payload: [ScorePayload] = []

        for hole in 1...18 {
            let model = ScorecardStorage.shared.load(hole: hole)

            // If no value exists at all → skip
            if !model.hasAnyValue() {
                continue
            }

            let score = ScorePayload(
                hole_number: hole,
                player_id: "\(playerId)",
                strokes: model.score ?? 0,
                putts: model.putts ?? 0,
                fairway_hit: model.fairwayHit ?? false,
                gir: model.gir ?? false,
                chip_shots: model.chipShots ?? 0,
                sand_shots: model.sandShots ?? 0,
                penalties: model.penalties ?? 0
            )

            payload.append(score)
        }

        return payload
    }

    func calculateTotalScore() -> Int {
        (1...18)
            .compactMap { ScorecardStorage.shared.load(hole: $0).score }
            .reduce(0, +)
    }

    func totalPar() -> Int {
        par.reduce(0, +)
    }

    func totalScore() -> Int {
        holes.compactMap { ScorecardStorage.shared.load(hole: $0).score }.reduce(0, +)
    }

    func totalPutts() -> Int {
        holes.compactMap { ScorecardStorage.shared.load(hole: $0).putts }.reduce(0, +)
    }

    func totalChipShots() -> Int {
        holes.compactMap { ScorecardStorage.shared.load(hole: $0).chipShots }.reduce(0, +)
    }

    func totalSandShots() -> Int {
        holes.compactMap { ScorecardStorage.shared.load(hole: $0).sandShots }.reduce(0, +)
    }

    func totalPenalties() -> Int {
        holes.compactMap { ScorecardStorage.shared.load(hole: $0).penalties }.reduce(0, +)
    }

    func totalTrue(_ keyPath: KeyPath<HoleStatsModel, Bool?>) -> Int {
        holes.filter { ScorecardStorage.shared.load(hole: $0)[keyPath: keyPath] == true }.count
    }

    // MARK: - Components (UNCHANGED)

    func fixedRow(_ title: String, height: CGFloat, background: Color = .white, foregroundColor: Color = .black) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .frame(height: height)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 12)
            .background(background)
            .foregroundColor(foregroundColor)
    }

    func fixedDoubleRow(_ title: String, secondtitle: String, height: CGFloat, background: Color = .white, foregroundColor: Color = .black) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(secondtitle)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: height)
        .padding(.leading, 12)
        .background(background)
        .foregroundColor(foregroundColor)
    }

    func numberRow(_ values: [String], height: CGFloat, isHeader: Bool = false) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                Text(values[i])
                    .font(.system(size: isHeader ? 15 : 14, weight: isHeader ? .semibold : .regular))
                    .foregroundColor(isHeader ? .white : .black)
                    .frame(width: 40, height: height)
                    .background(isHeader ? Color(red: 0.38, green: 0.47, blue: 0.58) : Color.white)
            }
        }
    }

    func doubleTextRow(_ values: [String], sub: [String], height: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                VStack(spacing: 2) {
                    Text(values[i]).font(.system(size: 14, weight: .medium))
                    Text(sub[i]).font(.system(size: 14, weight: .medium))
                }
                .frame(width: 40, height: height)
                .background(Color.white)
            }
        }
    }

    func boolRow(_ values: [Bool?]) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                ZStack {
                    if let val = values[i] {
                        Circle()
                            .fill(val ? Color.green : Color.purple)
                            .frame(width: 26, height: 26)

                        Image(systemName: val ? "checkmark" : "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                    }
                }
                .frame(width: 40, height: 50)
                .background(Color.white)
            }
        }
    }

    func totalCell(_ text: String, height: CGFloat, bold: Bool = false, color: Color = .black, background: Color = .white) -> some View {
        Text(text)
            .font(.system(size: bold ? 15 : 14, weight: bold ? .semibold : .regular))
            .foregroundColor(color)
            .frame(height: height)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)
            .background(background)
    }

    struct HeaderView: View {
        var pop: (() -> Void)?
        
        var body: some View {
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }
    
}

struct FinishRoundOverlay: View {

    var onCompleteScorecard: () -> Void
    var onFinishAndExit: () -> Void
    var onDelete: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack {
                Spacer()

                FinishRoundSheetView(
                    onCompleteScorecard: onCompleteScorecard,
                    onEnterTotalScore: {},
                    onFinishAndExit: onFinishAndExit,
                    onDelete: onDelete, onDismiss: onDismiss
                )
                .transition(.move(edge: .bottom))
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.easeInOut, value: true)
    }
}



struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView()
    }
}

