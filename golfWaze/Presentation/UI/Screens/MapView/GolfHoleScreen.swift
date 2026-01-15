//
//  GolfHoleScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 30/11/2025.
//


import SwiftUI
import GoogleMaps

struct GolfHoleScreen: View {
    @State private var isExpanded = false
    @State private var zoomAction: GoogleMapView.ZoomAction? = nil
    @State private var mapLinescoordinates: [CLLocationCoordinate2D] = []
    
    @StateObject var trafficVM = LiveTrafficViewModel()
    @State private var pollTimer: Timer?
    @State private var updateTimer: Timer?
    @EnvironmentObject var locationManager: LocationManager
    @State private var showFinishSheet = false

    let token: String = SessionManager.load()?.accessToken ?? ""
    let courseId: String
    let response: CreateRoundResponse
    @EnvironmentObject var coordinator: TabBarCoordinator
    @State private var currentHoleIndex = 0
    
    var holes: [HoleInfo] {
        response.holes ?? []
    }

    var currentHole: HoleInfo? {
        guard currentHoleIndex < holes.count else { return nil }
        return holes[currentHoleIndex]
    }

    func holePathPoints(_ hole: HoleInfo) -> [CLLocationCoordinate2D] {
        [
            CLLocationCoordinate2D(
                latitude: hole.locations.tee.lat,
                longitude: hole.locations.tee.lng
            ),
            CLLocationCoordinate2D(
                latitude: hole.locations.mid.lat,
                longitude: hole.locations.mid.lng
            ),
            CLLocationCoordinate2D(
                latitude: hole.locations.green.lat,
                longitude: hole.locations.green.lng
            )
        ]
    }

    var body: some View {
        ZStack {
            GoogleMapView(
                coordinates: trafficVM.coordinates,
                mapLinescoordinates: $mapLinescoordinates,
                initialZoom: 12,
                minZoom: 5,
                maxZoom: 20,
                mapType: .satellite,
                currentHole: currentHoleIndex, zoomAction: $zoomAction
            )
            .edgesIgnoringSafeArea(.all)
            
            overlaysLayer
            
            if showFinishSheet {
                finishOverlay
            }
        }
        .task {
            // Set initial hole path
            if let hole = currentHole {
                mapLinescoordinates = holePathPoints(hole)
            }
            
            trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
            startPolling()
        }
        .onDisappear {
            stopPolling()
        }
        .onChange(of: currentHoleIndex) { newValue in
            // Update map lines when hole changes (iOS 15+ compatible)
            if let hole = currentHole {
                mapLinescoordinates = holePathPoints(hole)
            }
        }
    }
   
    private var finishOverlay: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showFinishSheet = false
                    }
                }

            VStack {
                Spacer()

                FinishRoundSheetView(
                    onCompleteScorecard: {
                        coordinator.push(.scoreCardView)
                    },
                    onEnterTotalScore: {
                        coordinator.push(.scoreCardView)
                    },
                    onFinishAndExit: {
                        showFinishSheet = false
                    },
                    onDelete: {
                        showFinishSheet = false
                    }
                )
                .transition(.move(edge: .bottom))
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.easeInOut, value: showFinishSheet)
    }

    
    // MARK: - Overlay Layer
    private var overlaysLayer: some View {
        ZStack {
            // Right Side Info Card
            VStack {
                Spacer().frame(height: 120)
                HStack {
                    Spacer()
                    holeInfoCard()
                }
                Spacer()
            }
            .padding(.trailing, 16)
            
            // Bottom Controls
            VStack(spacing: 20) {
                Spacer()
//                trackShotButton()
                holeSelector()
            }
//            
//            // Zoom Controls
//            zoomControlsLayer()
        }
    }
    
    func backButton() -> some View {
        Button(action: {}) {
            Image(systemName: "chevron.left")
                .font(.system(size: 22, weight: .medium))
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        }
    }
    
    func holeInfoCard() -> some View {
        VStack(spacing: 12) {
            Text("Mid Green\n\(currentHole?.yardage ?? 0) yds")
                .multilineTextAlignment(.center)
                .font(.system(size: 15, weight: .semibold))

            if isExpanded {
                VStack(spacing: 14) {
                    groupRow(title: "Par", value: "\(currentHole?.par ?? 0)")
                    groupRow(title: "Handicap", value: "\(currentHole?.handicap ?? 0)")
                    groupRow(title: "Blue", value: "\(currentHole?.yardage ?? 0)")
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.black.opacity(0.85)))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .frame(width: 100)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    func groupRow(title: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 14))
            Text(value)
                .font(.system(size: 16, weight: .semibold))
        }
    }
    
    func distanceBubble(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 16, weight: .bold))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
    
    func trackShotButton() -> some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#0E1A36"))
                .frame(width: 60, height: 54)
                .overlay(
                    Image("mappin")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                )

            Text("Track Shot")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "#1A1F2F"))

            Spacer()
        }
        .frame(width: 170, height: 52)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
    }
    
    func holeSelector() -> some View {
        ZStack {
            
            // CENTERED MAIN PILL
            HStack(spacing: 0) {
                
                // LEFT (Back)
                if currentHoleIndex > 0 {
                    Button {
                        currentHoleIndex -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 56)
                            .background(Color.white)
                    }
                }

                // CENTER
                VStack(spacing: 2) {
                    Text("Hole \(currentHole?.hole_number ?? 1)")
                        .font(.system(size: 18, weight: .semibold))

                    Text("Enter Score")
                        .font(.system(size: 14))
                }
                .foregroundColor(Color(hex: "#1A1F2F"))
                .frame(width: 120, height: 56)
                .background(Color(hex: "#E7EFFF"))

                // RIGHT
                if currentHoleIndex == holes.count - 1 {
                    Button {
                        showFinishSheet = true
                    } label: {
                        Text("Finish\nRound")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: 80, height: 56)
                            .background(Color.blue)
                    }
                } else {
                    Button {
                        currentHoleIndex += 1
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 56)
                            .background(Color.white)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.15), radius: 6, y: 2)

            // RIGHT SIDE ZOOM CONTROLS (12pt from edge)
            HStack {
                Spacer()
                
                VStack(spacing: 8) {
                    circleButton(icon: "plus.magnifyingglass") {
                        zoomAction = .zoomIn
                    }

                    circleButton(icon: "minus.magnifyingglass") {
                        zoomAction = .zoomOut
                    }
                }
                .padding(.trailing, 12)
            }
        }
        .frame(maxWidth: .infinity)
    }


    func zoomControlsLayer() -> some View {
        VStack {
            Spacer()

            HStack {
                VStack(spacing: 18) {
                    circleButton(icon: "plus.magnifyingglass") {
                        zoomAction = .zoomIn
                    }

                    circleButton(icon: "minus.magnifyingglass") {
                        zoomAction = .zoomOut
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 200)
        }
    }
    
    func circleButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 26))
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 3)
        }
    }
}

#Preview {
    let mockResponse = CreateRoundResponse(
        success: true,
        round_id: "round_123",
        status: "active",
        created_at: "2026-01-04T12:00:00Z",
        course: CourseInfo(
            course_id: "course_1",
            club_name: "Sample Club",
            course_name: "Sample Course",
            location: CourseLocation(latitude: 0, longitude: 0, address: "", city: "", state: "", country: ""),
            holes_count: "18"
        ),
        tee: TeeInfo(tee_id: "tee_1", tee_name: "Blue"),
        players: [
            RoundPlayer(player_id: "p1", name: "Alice", profile_pic: nil)
        ],
        holes: [
            HoleInfo(hole_number: 1, par: 4, handicap: 8, yardage: 380,
                    locations: HoleLocations(
                        tee: HoleCoordinate(lat: 34.289850583377465, lng: -118.49933512508869),
                        mid: HoleCoordinate(lat: 34.29024863790201, lng: -118.49689967930316),
                        green: HoleCoordinate(lat: 34.29036110112124, lng: -118.49514484405519)
                    )),
        ],
        scores: []
    )
    GolfHoleScreen(courseId: "course_1", response: mockResponse)
}

extension GolfHoleScreen {

    func startPolling() {
        // First immediate calls
        trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
        callUpdateAPI()

        // Fetch live traffic every 15s
        pollTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
        }

        // Update live traffic every 14s
        updateTimer = Timer.scheduledTimer(withTimeInterval: 14, repeats: true) { _ in
            callUpdateAPI()
        }
    }

    func callUpdateAPI() {
        guard let userId = SessionManager.load()?.id else { return }
        
        if let lat = locationManager.latitude,
           let lng = locationManager.longitude {
            
            let payload = UpdateLiveTrafficRequest(
                course_id: courseId,
                hole_number: currentHole?.hole_number ?? 1,
                lat: lat,
                lng: lng,
                user_id: "\(userId)",
                round_id: response.round_id ?? "",
                token: token
            )

            Task {
                await trafficVM.updateLiveTraffic(payload)
            }
        }
    }
    
    func finishRoundApi(){
        let requestModel = FinishRoundRequest(
            token: token,
            round_id: response.round_id ?? "",
            round_finished: true,
            finish_context: FinishContext(
                reason: "finished_round",
                user_id: SessionManager.load()?.id ?? 0
            ),
            end_location: EndLocation(
                lat: 34.2925167,
                lng: -118.4962613
            ),
            scores: [
                Score(
                    hole_number: 18,
                    player_id: String(SessionManager.load()?.id ?? 0),
                    strokes: 5,
                    putts: 2,
                    fairway_hit: true,
                    gir: false
                )
            ]
        )

        Task {
            await finishRoundAPI(requestModel: requestModel)
        }

    }

    func stopPolling() {
        print("🛑 Stopping Polling & Cancelling Tasks")

        pollTimer?.invalidate()
        pollTimer = nil

        updateTimer?.invalidate()
        updateTimer = nil

        trafficVM.cancelRequests()
    }
}


struct FinishRoundSheetView: View {

    var onCompleteScorecard: () -> Void
    var onEnterTotalScore: () -> Void
    var onFinishAndExit: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Drag indicator
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            
            // Close Button
            HStack {
                Spacer()
                Button {
                    onFinishAndExit()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(.trailing, 16)
            }
            
            // Icon
            Image("finsihRoundshetImage")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            // Title
            Text("End Your Round!")
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 10)
            
            // Buttons
            VStack(spacing: 14) {
                
                Button(action: onCompleteScorecard) {
                    Text("Complete My Scorecard")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#0A1E3D"))
                        .cornerRadius(14)
                }
                
                Button(action: onEnterTotalScore) {
                    Text("Enter a total Score")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#0A1E3D"))
                        .cornerRadius(14)
                }
                
                HStack(spacing: 12) {
                    
                    Button(action: onFinishAndExit) {
                        Text("Finish and Exit Anyway")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#0A1E3D"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(hex: "#D4E7FF"))
                            .cornerRadius(14)
                    }
                    
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .foregroundColor(Color(hex: "#0A1E3D"))
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "#D4E7FF"))
                            .cornerRadius(14)
                    }
                }
            }
            .padding(.horizontal, 20)
            
           
        }
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .ignoresSafeArea(.container, edges: .bottom)
        )
        .cornerRadius(26, corners: [.topLeft, .topRight])
    }
}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
