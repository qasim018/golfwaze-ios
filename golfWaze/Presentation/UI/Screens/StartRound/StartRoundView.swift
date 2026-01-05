//
//  StartRoundView.swift
//  golfWaze
//
//  Created by Naveed Tahir on 04/01/2026.
//
import SwiftUI

struct StartRoundView: View {

    @State private var selectedRoundType = "18 Holes"
    @State private var showCourseDropdown = false
    @State private var selectedCourseSplit = "(1-9)+(10-18)"

    @StateObject var viewModel = StartRoundViewModel()

    @State private var startHole = 1

    let courseOptions = [
        "(1-9)+(10-18)",
        "(10-18)+(19-27)",
        "(1-9)+(19-27)"
    ]

    @State private var courseID = ""
    @State private var courseName = ""
    
    let userID = SessionManager.load()?.id ?? 0
    let token  = SessionManager.load()?.accessToken ?? ""


    init(courseID: String, courseName: String) {
        _courseID = State(initialValue: courseID)   // ✅ Proper
        _courseName = State(initialValue: courseName)   // ✅ Properinitialization
    }


    var startHoleValue: Int {
        switch selectedCourseSplit {
        case "(10-18)+(19-27)":
            if selectedRoundType == "Back 9" { return 19 }
            return 10
        case "(1-9)+(19-27)":
            if selectedRoundType == "Back 9" { return 19 }
            return 1
        default:
            if selectedRoundType == "Back 9" { return 10 }
            return 1
        }
    }

    @State private var showAddPlayerSheet = false

    var body: some View {
        ZStack {

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // MARK: Course Card + Dropdown
                        VStack(alignment: .leading, spacing: 0) {

                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showCourseDropdown.toggle()
                                }
                            } label: {

                                VStack(alignment: .leading, spacing: 10) {

                                    HStack {
                                        Text(courseName)
                                            .font(.system(size: 17, weight: .semibold))

                                        Spacer()

                                        Image("edit")
                                            .foregroundColor(Color(hex: "#FF6B2C"))
                                    }

                                    Text(selectedCourseSplit)
                                        .font(.system(size: 15))
                                        .foregroundColor(.black.opacity(0.8))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(12)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .padding(16)
                                .background(Color(hex: "#F5F7F9"))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)

                            if showCourseDropdown {

                                VStack(spacing: 0) {

                                    ForEach(courseOptions, id: \.self) { option in
                                        Button {
                                            selectedCourseSplit = option
                                            updateStartHole()
                                            withAnimation { showCourseDropdown = false }
                                        } label: {
                                            Text(option)
                                                .font(.system(size: 15))
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(12)
                                        }
                                        .buttonStyle(.plain)

                                        if option != courseOptions.last {
                                            Divider()
                                        }
                                    }
                                }
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.12), radius: 6, y: 4)
                                .padding(.top, 6)
                            }
                        }

                        // MARK: Round Type Segment
                        VStack(alignment: .leading, spacing: 12) {

                            Text("Round Type")
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.leading, 10)
                                .padding(.top, 10)

                            HStack(spacing: 10) {
                                roundTypeButton("18 Holes")
                                roundTypeButton("Front 9")
                                roundTypeButton("Back 9")
                            }
                            .padding(10)

                        }
                        .background(Color(hex: "#F5F7F9"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // MARK: Settings Group
                        VStack(spacing: 0) {

                            settingsRow(
                                title: "Tee Selection",
                                value: "Black 3436 yds"
                            )

                            settingsRow(
                                title: "Round Visibility",
                                value: "Everyone",
                                showChevron: true,
                                showDivider: false
                            )

                        }
                        .padding(12)
                        .background(Color(hex: "#F2F5FA"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        // MARK: Exclude Round
                        VStack(alignment: .leading, spacing: 6) {

                            HStack {
                                Text("Exclude Round")
                                    .font(.system(size: 15, weight: .semibold))

                                Spacer()

                                Toggle("", isOn: .constant(true))
                                    .labelsHidden()
                            }

                            Text("Round won't count toward your stats, handicap, or leaderboards")
                                .font(.system(size: 13))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(16)
                        .background(Color(hex: "#F2F5FA"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                }

                // MARK: Bottom Primary Button
                Button {
                    showAddPlayerSheet = true
                } label: {
                    Text("Start Round")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "#00213D"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }

            // MARK: Overlay Sheet
            if showAddPlayerSheet {
                AddPlayerSheet(
                    showSheet: $showAddPlayerSheet,
                    courseID: $courseID,startHole: $startHole,
                    courseType: $selectedCourseSplit,
                    viewModel: viewModel
                )
                .transition(.move(edge: .bottom))
                .animation(.easeInOut, value: showAddPlayerSheet)
            }
        }
    }

    // MARK: Round Type Button
    func roundTypeButton(_ title: String) -> some View {
        Button {
            selectedRoundType = title
            updateStartHole()
        } label: {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    selectedRoundType == title
                    ? Color(hex: "#00213D")
                    : Color.white
                )
                .foregroundColor(
                    selectedRoundType == title ? .white : .black
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    func updateStartHole() {
        switch selectedCourseSplit {
        case "(10-18)+(19-27)":
            startHole = selectedRoundType == "Back 9" ? 19 : 10
        case "(1-9)+(19-27)":
            startHole = selectedRoundType == "Back 9" ? 19 : 1
        default:
            startHole = selectedRoundType == "Back 9" ? 10 : 1
        }
    }

    func settingsRow(
        title: String,
        value: String,
        showChevron: Bool = true,
        showDivider: Bool = true
    ) -> some View {

        VStack(spacing: 0) {

            HStack(spacing: 12) {

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#1A1F2F"))

                Spacer()

                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.7))

                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
            .frame(height: 52)

            if showDivider {
                Divider()
            }
        }
    }
}

#Preview {
    StartRoundView(courseID: "", courseName: "")
}


// MARK: ADD PLAYER SHEET + API CALL
struct AddPlayerSheet: View {

    @Binding var showSheet: Bool
    @Binding var courseID: String
    @Binding var startHole: Int
    @Binding var courseType: String
    @State private var searchText = ""
    @EnvironmentObject var coordinator: TabBarCoordinator

    @ObservedObject var viewModel: StartRoundViewModel

    let userID = SessionManager.load()?.id ?? 0
    let token  = SessionManager.load()?.accessToken ?? ""

    struct Player: Identifiable, Hashable {
        let id = UUID()
        let index: Int
        let name: String
        let status: String
        let imageName: String
    }

    @State private var selectedPlayers: [Player] = [
        .init(index: 0,
              name: SessionManager.load()?.name ?? "Unknown",
              status: "Active",
              imageName: "p1")
    ]

    let friends: [Player] = [
        .init(index: 1, name: "Eden Alley", status: "Active", imageName: "p1"),
        .init(index: 2, name: "John Smith", status: "Active", imageName: "p1")
    ]

    let contacts: [Player] = [
        .init(index: 3, name: "Adam Lee", status: "Active", imageName: "p1"),
        .init(index: 4, name: "Maria Reed", status: "Active", imageName: "p1"),
        .init(index: 5, name: "James Paul", status: "Active", imageName: "p1"),
        .init(index: 6, name: "Chris Young", status: "Active", imageName: "p1")
    ]

    var filteredFriends: [Player] {
        searchText.isEmpty ? friends :
        friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var filteredContacts: [Player] {
        searchText.isEmpty ? contacts :
        contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {

        ZStack(alignment: .bottom) {

            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { showSheet = false }

            VStack(spacing: 0) {

                HStack {
                    Spacer()
                    Text("Add Player to my group")
                        .font(.system(size: 17, weight: .semibold))
                    Spacer()
                    Button("Close") { showSheet = false }
                }
                .padding()
                .background(Color.white)

                Divider()

                ScrollView(showsIndicators: false) {

                    VStack(alignment: .leading, spacing: 16) {

                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Search by name or username…", text: $searchText)
                                .foregroundColor(.black)
                        }
                        .padding(12)
                        .background(Color(hex: "#F2F5FA"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        if !selectedPlayers.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(selectedPlayers) { player in
                                        VStack(spacing: 4) {
                                            Image(player.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 44, height: 44)
                                                .clipShape(Circle())

                                            Text(player.name)
                                                .font(.system(size: 12))
                                        }
                                    }
                                }
                            }
                        }

                        Text("Friends on 18 birdies")
                            .font(.system(size: 15, weight: .semibold))

                        VStack(spacing: 16) {
                            ForEach(filteredFriends) { player in
                                playerRow(player: player,
                                          isSelected: selectedPlayers.contains(player))
                            }
                        }

                        Text("Other Contacts")
                            .font(.system(size: 15, weight: .semibold))
                            .padding(.top, 6)

                        VStack(spacing: 16) {
                            ForEach(filteredContacts) { player in
                                playerRow(player: player,
                                          isSelected: selectedPlayers.contains(player))
                            }
                        }
                    }
                    .padding(16)
                }

                // MARK: PLAY BUTTON → CALL API
                Button {

                    Task {

                        let playerIDs = selectedPlayers
                            .map { "\($0.index)" }

                        let req = CreateRoundRequest(
                            owner_player_id: "\(userID)",
                            course_id: courseID,
                            round_style: courseType,
                            start_hole: startHole,
                            tee_id: "blue",
                            players: playerIDs,
                            token: token
                        )

                        await viewModel.createRound(req)

                        if viewModel.roundResponse != nil {
                            showSheet = false
                            if let response = viewModel.roundResponse {
                                coordinator.push(.golfHole(courseID: courseID, response: response))
                            }
                        }
                    }

                } label: {
                    Text(viewModel.isLoading ? "Starting..." : "Play")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color(hex: "#00213D"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .padding()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .ignoresSafeArea(edges: .bottom)
        }
    }

    func playerRow(player: Player, isSelected: Bool) -> some View {
        Button {
            if isSelected {
                selectedPlayers.removeAll { $0 == player }
            } else {
                selectedPlayers.append(player)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color(hex: "#0E1A36") : .gray)
                    .font(.system(size: 22))

                Image(player.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(player.name)
                        .font(.system(size: 15, weight: .semibold))

                    Text(player.status)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
