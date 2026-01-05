//
//  GolfHoleScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 30/11/2025.
//

import SwiftUI
import GoogleMaps
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
    
    @StateObject var trafficVM = LiveTrafficViewModel()
    @State private var pollTimer: Timer?   // 👈 hold timer
    @State private var updateTimer: Timer?   // 👈 second timer
    @EnvironmentObject var locationManager: LocationManager

    
    let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 41.050833, longitude: -73.803112),
            CLLocationCoordinate2D(latitude: 41.050576, longitude: -73.803897),
            CLLocationCoordinate2D(latitude: 41.050833, longitude: -73.802482),
            CLLocationCoordinate2D(latitude: 41.052389, longitude: -73.804284),
            CLLocationCoordinate2D(latitude: 41.05446, longitude: -73.803373),
        ]

        
//    let courseId: String = "15733"
    let token: String = SessionManager.load()?.accessToken ?? ""
    
    let courseId: String
    let response: CreateRoundResponse   // 👈 API Response
    
    @State private var currentHoleIndex = 0   // 👈 start from Hole 1
    
    var holes: [HoleInfo] {
        response.holes ?? []
    }

    var currentHole: HoleInfo? {
        guard currentHoleIndex < holes.count else { return nil }
        return holes[currentHoleIndex]
    }

    
    var body: some View {
        ZStack {
            GoogleMapView(
                coordinates: trafficVM.coordinates,
                initialZoom: 18,      // 🔹 start closer
                minZoom: 5,
                maxZoom: 22,          // 🔹 allow deep zoom
                mapType: .satellite,  // 🔹 or .hybrid
                zoomAction: $zoomAction
            )

            .edgesIgnoringSafeArea(.all)
            overlaysLayer
        }
        .task {
            trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
            startPolling()
        }
        .onDisappear {
            stopPolling()
        }
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
            
            // Distance Labels
            // distanceLabelsLayer()
            
            // Bottom Controls
            VStack(spacing: 20) {
                Spacer()
                
                trackShotButton()
                
                holeSelector()
            }
            .padding(.bottom, 20)
            
            // Zoom Controls Left + Scorecard Left
            zoomControlsLayer()
            
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

            // LEFT ICON BLOCK — no inner padding
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
        HStack(spacing: 12) {

            Button {
                if currentHoleIndex > 0 {
                    currentHoleIndex -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
            }

            VStack(spacing: 2) {
                Text("Hole \(currentHole?.hole_number ?? 1)")
                    .font(.system(size: 18, weight: .semibold))

                Text("Enter Score")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#1A1F2F").opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color(hex: "#E7EFFF"))
            .clipShape(RoundedRectangle(cornerRadius: 14))

            Button {
                if currentHoleIndex < (holes.count - 1) {
                    currentHoleIndex += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
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

//                Button("Scorecard") {}
//                    .padding(10)
//                    .background(Color.white)
//                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 200)
        }
    }
    
    func circleButton(
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
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
            location: CourseLocation(latitude: 0, longitude: 0,address: "", city: "", state: "", country: ""), // adjust if you have a different type
            holes_count: "18"
        ),
        tee: TeeInfo(tee_id: "tee_1", tee_name: "Blue"),
        players: [
            RoundPlayer(player_id: "p1", name: "Alice", profile_pic: nil)
        ],
        holes: [
            HoleInfo(hole_number: 1, par: 4, handicap: 8, yardage: 380),
            HoleInfo(hole_number: 2, par: 3, handicap: 12, yardage: 160),
            HoleInfo(hole_number: 3, par: 5, handicap: 2, yardage: 520)
        ],
        scores: []
    )
    GolfHoleScreen(courseId: "course_1", response: mockResponse)
}

extension GolfHoleScreen {

    func startPolling() {

        // first immediate calls
        trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
        callUpdateAPI()

        // 🔁 fetch live traffic every 15s
        pollTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            trafficVM.fetchLiveTraffic(courseId: courseId, token: token)
        }

        // 🔁 update live traffic every 20s
        updateTimer = Timer.scheduledTimer(withTimeInterval: 14, repeats: true) { _ in
            callUpdateAPI()
        }
    }

    func callUpdateAPI() {

        // 💡 Example payload — adjust fields as needed
        guard let userId = SessionManager.load()?.id else { return }
        
        if let lat = locationManager.latitude,
           let lng = locationManager.longitude {
            
            
            let payload = UpdateLiveTrafficRequest(
                course_id: courseId,
                hole_number: currentHole?.hole_number ?? 1,
                lat: lat,//41.050833,
                lng: lng,//-73.803112,
                user_id: "\(userId)",
                round_id: response.round_id ?? "",
                token: token
            )

            Task {
                await trafficVM.updateLiveTraffic(payload)
            }
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
