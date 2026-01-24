//
//  GolfCourseDetailView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 22/11/2025.
//

import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    let index: Int
    let name: String
    let status: String
    let imageName: String   // you will assign real images later
}


struct GolfCourseDetailView: View {
    
    @EnvironmentObject var coordinator: TabBarCoordinator
     @StateObject private var viewModel: GolfCourseDetailVM
    @ObservedObject private var liveTrafficViewModel = LiveTrafficViewModel()
    @State private var showPlayPopup = false

     let course: CourseDetail

    init(course: CourseDetail) {
         self.course = course
         _viewModel = StateObject(
            wrappedValue: GolfCourseDetailVM(courseID: course.id ?? "")
         )
     }
    
    let samplePlayers: [Player] = [
        Player(index: 1, name: "John Doe", status: "Active", imageName: "activeplayerImage"),
        Player(index: 2, name: "John Doe", status: "Active", imageName: "activeplayerImage"),
        Player(index: 3, name: "John Doe", status: "Active", imageName: "activeplayerImage")
    ]

    private var activePlayersFromAPI: [Player] {
        guard let traffic = liveTrafficViewModel.traffic else { return [] }

        return traffic.active_players.enumerated().map { index, apiPlayer in
            Player(
                index: index + 1,
                name: apiPlayer.name,
                status: apiPlayer.status.capitalized,
                imageName: apiPlayer.profile_pic ?? "activeplayerImage"
            )
        }
    }

    
    var body: some View {
        BottomSheetView(
            sheetBackgroundColor: Color(hex: "#F5F7F9")
        ) {
            mainContent()
        }
        topContent: {
            topContent()
        }
        background: {
            Images.bg_1.resizable()
        }
        .overlay {
            if showPlayPopup {
                PlayTimePopup(
                    onNow: {
                        showPlayPopup = false
                        //"19443"
                        coordinator.push(.createRound(course: viewModel.courseDetail ?? course))
                    },
                    onFuture: {
                        showPlayPopup = false
                        // navigate to scheduling screen
                    },
                    onDismiss: {
                        showPlayPopup = false
                    }
                )
            }
        }
        .onAppear {
            liveTrafficViewModel.fetchLiveTraffic(
                courseId: course.id ?? "",
                token: SessionManager.load()?.accessToken ?? ""
            )
        }
        .onDisappear {
            liveTrafficViewModel.cancelRequests()
        }

    }
    
    private func mainContent() -> some View {
        VStack(spacing: 12) {
            addressCard()
            reviewCard()
                .onTapGesture {
                    coordinator.push(.courseReview)
                }
//            leaderboardCard()
//            activePlayersCard(players: samplePlayers)
           activePlayersCard(players: activePlayersFromAPI)
            
        }
        //        .background(Color(hex: "#F5F7F9"))
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    
    private func addressCard() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.golfCourseName)
                .font(Font.customFont(.robotoSemiBold, .pt14))
            
            HStack(spacing: 4) {
                Images.locationPin
                Text(viewModel.address)
            }
            .padding(.bottom, 8)
            
            AppButton(Strings.startARound, .primary) {
                if let round = UserDefaults.standard.loadRound() {
                    coordinator.push(.golfHole(course: course, response: round))
                }
                else{
                    showPlayPopup = true
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 20)
        .background(
            Color.white.clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
    
    private func reviewCard() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(Strings.courseReview)
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                Spacer()
                Text(viewModel.reviewText)
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(
                        Color(hex: "#1A1F2F").opacity(0.7)
                    )
                Images.chevronRightBlack
            }
            
            HStack() {
                VStack {
                    HStack {
                        Images.ratingStar
                        Text("3.6")
                            .font(Font.customFont(.robotoMedium, .pt20))
                    }
                    Spacer()
                }
                Spacer()
                VStack {
                    Text(Strings.value)
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F").opacity(0.7)
                        )
                    Text(viewModel.valueValue)
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F")
                        )
                }
                Spacer()
                VStack {
                    Text("Condition")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F").opacity(0.7)
                        )
                    Text("3.8")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F")
                        )
                }
                Spacer()
                VStack {
                    Text("Difficulty")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F").opacity(0.7)
                        )
                    Text("3.8")
                        .font(Font.customFont(.robotoMedium, .pt12))
                        .foregroundStyle(
                            Color(hex: "#1A1F2F")
                        )
                }
                //                Spacer()
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
            HStack {
                Circle()
                    .fill(ThemeManager.shared.primaryColor)
                    .frame(width: 10, height: 10)
                Text("Green Speed: Medium")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(
                        Color(hex: "#1A1F2F").opacity(0.7)
                    )
                Circle()
                    .fill(ThemeManager.shared.primaryColor)
                    .frame(width: 10, height: 10)
                    .padding(.leading, 12)
                Text("Pace of Play: Fast")
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundStyle(
                        Color(hex: "#1A1F2F").opacity(0.7)
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 20)
        .background(
            Color.white.clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
    
    private func activePlayersCard(players: [Player]) -> some View {
        VStack(alignment: .leading, spacing: 22) {

            // 🔹 Header
            HStack {
                Text("Active Players")
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(Color(hex: "#1A1F2F"))

                Spacer()

                Images.chevronRightBlack
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black.opacity(0.9))
            }

            ZStack {
                VStack(spacing: 14) {
                    // 🔹 Real players
                    ForEach(players.prefix(4)) { player in
                        playerRow(player)
                    }

                    // 🔹 Fill remaining slots (if < 4)
                    ForEach(0..<max(0, 4 - players.count), id: \.self) { _ in
                        playerRowPlaceholder()
                    }
                }

                // 🔹 Empty state text (only when 0 players)
                if players.isEmpty {
                    Text("No live players found")
                        .font(Font.customFont(.robotoMedium, .pt13))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
    }
    
    private func playerRowPlaceholder() -> some View {
        playerRow(
            Player(
                index: 0,
                name: "",
                status: "",
                imageName: ""
            )
        )
        .opacity(0)   // keeps layout, hides content
    }

    
    private func playerRow(_ player: Player) -> some View {
        HStack(spacing: 14) {

            // 🔹 Rank Number Bubble
            Text("\(player.index)")
                .font(Font.customFont(.robotoMedium, .pt11))
                .foregroundColor(.black)
                .frame(width: 22, height: 22)
                .background(
                    Circle().fill(Color.blue.opacity(0.35))
                )

            // 🔹 Avatar (Async with fallback)
            AsyncImage(url: URL(string: player.imageName)) { phase in
                switch phase {
                case .empty:
                    Image("activeplayerImage")
                        .resizable()
                        .scaledToFill()

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    Image("activeplayerImage")
                        .resizable()
                        .scaledToFill()

                @unknown default:
                    Image("activeplayerImage")
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())

            // 🔹 Name
            Text(player.name)
                .font(Font.customFont(.robotoMedium, .pt13))
                .foregroundStyle(Color(hex: "#1A1F2F"))

            Spacer()

            // 🔹 Status
            Text(player.status)
                .font(Font.customFont(.robotoMedium, .pt12))
                .foregroundColor(Color.green)
        }
    }


    
    private func leaderboardCard() -> some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("LeaderBoards")
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                    HStack(spacing: 8) {
                        Circle()
                            .fill(ThemeManager.shared.primaryColor)
                            .frame(width: 10, height: 10)
                        
                        Text("(1-9)+(19-27)-Best Gross(Last 365 Days)")
                            .font(Font.customFont(.robotoMedium, .pt11))
                            .foregroundStyle(
                                Color(hex: "#1A1F2F")
                                    .opacity(0.7)
                            )
                    }
                }
                
                Spacer()
                
                Images.chevronRightBlack
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black.opacity(0.8))
            }
            leaderboardRow()
            leaderboardRow()
            leaderboardRow()
            
        }
        .padding(24)
        .background(
            Color.white.clipShape(RoundedRectangle(cornerRadius: 12))
        )
    }
    
    private func leaderboardRow() -> some View {
        HStack(spacing: 16) {
            Text("1")
                .font(Font.customFont(.robotoMedium, .pt10))
                .foregroundColor(Color.black)
                .frame(width: 14, height: 14)
                .background(
                    Circle().fill(Color.blue.opacity(0.15))
                )
            Images.logo
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            Spacer()
            Text("+19(91)")
                .font(Font.customFont(.robotoMedium, .pt14))
                .foregroundColor(Color(hex: "#1A1F2F"))
        }
        .padding(.horizontal, 4)
    }
    
    private func topContent() -> some View {
        VStack{
            Spacer()
            HStack(spacing: 42) {
                VStack {
                    Text("\(viewModel.holesCount)")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color.white)
                    Text(Strings.holes)
                        .font(Font.customFont(.robotoRegular, .pt16))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Text("\(viewModel.par)")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color.white)
                    Text(Strings.par)
                        .font(Font.customFont(.robotoRegular, .pt16))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Text("\(viewModel.length)")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color.white)
                    Text(Strings.length)
                        .font(Font.customFont(.robotoRegular, .pt16))
                        .foregroundStyle(Color.white)
                }
                VStack {
                    Images.chevronWhiteRight
                    Text(Strings.more)
                        .font(Font.customFont(.robotoRegular, .pt14))
                        .foregroundStyle(Color.white)
                }
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0),
                        Color.black.opacity(1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .padding(.bottom, -38)
            )
            
        }
    }
}

struct GolfCourseDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        GolfCourseDetailView(courseID: "")
    }
}



