//
//  UpdateSocreScreen.swift
//  golfWaze
//
//  Created by Naveed Tahir on 14/01/2026.
//

import SwiftUI


struct HoleStatsView: View {
    
    @State private var model = HoleStatsModel()
    
    @State private var currentHole = 1
    @State private var pars: [Int] = [3,4,5,4,3,5,4,4,3,5,4,3,4,5,3,4,4,5]

    var finishHole: (() -> ())
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Header
                    HStack {
                        Spacer()
                        Button(action: {
                            finishHole()
                        }) {
                            Text("Finish hole")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    
                    VStack(spacing: 20) {
                        
                        CardSection(title: "Score") {
                            scoreGrid(par: pars[currentHole - 1], selection: $model.score)
                        }

                        CardSection(title: "Putts") {
                            row(values: [0,1,2,3,4], selection: $model.putts)
                        }
                        
                        CardSection(title: "Fairway Hit") {
                            boolRow(selection: $model.fairwayHit)
                        }
                        
                        CardSection(title: "Greens in Regulation") {
                            boolRow(selection: $model.gir)
                        }
                        
                        CardSection(title: "Chip Shots") {
                            row(values: [0,1,2,3,4], selection: $model.chipShots)
                        }
                        
                        CardSection(title: "Greenside Sand Shots") {
                            row(values: [0,1,2,3,4], selection: $model.sandShots)
                        }
                        
                        CardSection(title: "Penalties") {
                            row(values: [0,1,2,3,4], selection: $model.penalties)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 120)
                }
            }
            .background(Color(.systemGray6))
            .onAppear {
                loadCurrentHole()
            }
            .onChange(of: currentHole) { _ in
                loadCurrentHole()
            }
            .onChange(of: model.score) { _ in saveCurrentHole() }
            .onChange(of: model.putts) { _ in saveCurrentHole() }
            .onChange(of: model.fairwayHit) { _ in saveCurrentHole() }
            .onChange(of: model.gir) { _ in saveCurrentHole() }
            .onChange(of: model.chipShots) { _ in saveCurrentHole() }
            .onChange(of: model.sandShots) { _ in saveCurrentHole() }
            .onChange(of: model.penalties) { _ in saveCurrentHole() }

            bottomNavigationBar
        }
    }

    // MARK: - Storage Logic

    func loadCurrentHole() {
        model = ScorecardStorage.shared.load(hole: currentHole)
    }

    func saveCurrentHole() {
        ScorecardStorage.shared.save(hole: currentHole, model: model)
    }

    // MARK: - Bottom Bar

    var bottomNavigationBar: some View {
        HStack {
            Button(action: {
                if currentHole > 1 {
                    currentHole -= 1
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 66, height: 44)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                    .foregroundColor(.black)

            }
            
            Spacer()
            
            Text("Hole \(currentHole)")
                .font(.system(size: 16, weight: .semibold))
            
            Spacer()
            
            Button(action: {
                if currentHole < 18 {
                    currentHole += 1
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 66, height: 44)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                    .foregroundColor(.black)

            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.white))
    }

    // MARK: - Components

    func scoreGrid(par: Int, selection: Binding<Int?>) -> some View {
        let values = scoreValues(for: par)

        return VStack(spacing: 12) {
            ForEach(values.chunked(into: 3), id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { val in
                        let style = scoreStyle(score: val, par: par)

                        ScoreChip(
                            title: "\(val)",
                            subtitle: style.label,
                            isSelected: selection.wrappedValue == val,
                            shape: style.shape
                        )
                        .onTapGesture {
                            selection.wrappedValue = val
                        }
                    }
                }
            }
        }
    }
    
    func row(values: [Int], selection: Binding<Int?>) -> some View {
        HStack(spacing: 12) {
            ForEach(values, id: \.self) { val in
                SelectionChip(
                    title: "\(val)",
                    isSelected: selection.wrappedValue == val
                )
                .onTapGesture {
                    selection.wrappedValue = val
                }
            }
        }
    }
    
    func boolRow(selection: Binding<Bool?>) -> some View {
        HStack(spacing: 16) {
            BoolChip(icon: "checkmark", isSelected: selection.wrappedValue == true)
                .onTapGesture { selection.wrappedValue = true }
            
            Spacer()
            
            BoolChip(icon: "xmark", isSelected: selection.wrappedValue == false)
                .onTapGesture { selection.wrappedValue = false }
        }
    }
}


// MARK: - Score Helpers

func scoreValues(for par: Int) -> [Int] {
    switch par {
    case 3: return Array(1...8)
    case 4: return Array(1...9)
    case 5: return Array(2...10)
    default: return []
    }
}

func scoreStyle(score: Int, par: Int) -> (label: String?, shape: ScoreShape) {
    let diff = score - par

    switch par {
    case 3:
        if score == 1 { return ("Hole in one", .doubleCircle) }
        if diff == -1 { return ("Birdie", .singleCircle) }
        if diff == 0 { return ("Par", .none) }
        if diff == 1 { return ("Bogey", .singleBox) }
        if diff == 2 { return ("Double Bogey", .doubleBox) }
        if diff == 3 { return ("Triple Bogey", .doubleBox) }
        return (nil, .doubleBox)

    case 4:
        if score == 1 { return ("Hole in one", .doubleCircle) }
        if diff == -2 { return ("Eagle", .doubleCircle) }
        if diff == -1 { return ("Birdie", .singleCircle) }
        if diff == 0 { return ("Par", .none) }
        if diff == 1 { return ("Bogey", .singleBox) }
        if diff == 2 { return ("Double Bogey", .doubleBox) }
        if diff == 3 { return ("Triple Bogey", .doubleBox) }
        return (nil, .doubleBox)

    case 5:
        if diff == -3 { return ("Albatross", .doubleCircle) }
        if diff == -2 { return ("Eagle", .doubleCircle) }
        if diff == -1 { return ("Birdie", .singleCircle) }
        if diff == 0 { return ("Par", .none) }
        if diff == 1 { return ("Bogey", .singleBox) }
        if diff == 2 { return ("Double Bogey", .doubleBox) }
        if diff == 3 { return ("Triple Bogey", .doubleBox) }
        return (nil, .doubleBox)

    default:
        return (nil, .none)
    }
}

enum ScoreShape {
    case doubleCircle
    case singleCircle
    case singleBox
    case doubleBox
    case none
}

// MARK: - UI Components

struct CardSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ScoreChip: View {
    let title: String
    let subtitle: String?
    let isSelected: Bool
    let shape: ScoreShape

    var body: some View {
        VStack(spacing: 6) {

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color(hex: "#EAF1FF") : Color(hex: "#F5F7F9"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
                    .frame(height: 64)

                ZStack {
                    shapeView
                    
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .blue : .black)
                }
            }

            if let subtitle {
                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
    }

    @ViewBuilder
    var shapeView: some View {
        switch shape {
        case .doubleCircle:
            ZStack {
                Circle().stroke(Color.gray.opacity(0.6), lineWidth: 1).frame(width: 44, height: 44)
                Circle().stroke(Color.gray.opacity(0.6), lineWidth: 1).frame(width: 36, height: 36)
            }

        case .singleCircle:
            Circle().stroke(Color.gray.opacity(0.6), lineWidth: 1).frame(width: 44, height: 44)

        case .singleBox:
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                .frame(width: 36, height: 36)

        case .doubleBox:
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 44, height: 44)
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 36, height: 36)
            }

        case .none:
            EmptyView()
        }
    }
}


struct SelectionChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isSelected ? Color.blue.opacity(0.16) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(8)
    }
}



struct BoolChip: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.16) : Color.white)
                .frame(width: 160, height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    HoleStatsView(finishHole: {
        
    })
}
