//
//  AddFriendsScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 06/12/2025.
//

import SwiftUI

struct AddFriendsScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = AddFriendsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            headerView
            tabSelector
            contentView
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .ignoresSafeArea()
    }
}
private extension AddFriendsScreen {
    var headerView: some View {
        HStack {
            Spacer()
            Text("Add Friends")
                .font(Font.customFont(.robotoBold, .pt14))
            Spacer()
            Button("Close") {
                dismiss()
            }
            .font(Font.customFont(.robotoBold, .pt14))
            .foregroundColor(.gray)
        }
        .padding()
    }
}

private extension AddFriendsScreen {
    var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton("Send Link", isSelected: vm.selectedTab == .sendLink) {
                vm.selectedTab = .sendLink
            }

            tabButton("Search Friends", isSelected: vm.selectedTab == .searchFriends) {
                vm.selectedTab = .searchFriends
            }
        }
        .padding(.horizontal)
    }

    func tabButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.customFont(.robotoBold, .pt14))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color(hex: "#00213D") : Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
private extension AddFriendsScreen {
    @ViewBuilder
    var contentView: some View {
        switch vm.selectedTab {
        case .sendLink:
            sendLinkView
        case .searchFriends:
            searchFriendsView
        }
    }
}

private extension AddFriendsScreen {
    var sendLinkView: some View {
        VStack(spacing: 30) {
            Spacer()

            Image("invite_friend_icon")

            Text("Invite Friends")
                .font(.customFont(.robotoBold, .pt16))

            Text("Share a link to invite your\nfriends to join you on golfwaze")
                .font(.customFont(.robotoBold, .pt16))
                .foregroundColor(Color(hex: "#1A1F2F"))
                .multilineTextAlignment(.center)

            Button(action: {}) {
                HStack {
                    Image("link_icon")
                    Text("Share link")
                        .font(.customFont(.robotoBold, .pt14))
                        .foregroundStyle(Color(hex: "#00213D"))
                }
                .foregroundColor(.blue)
                .padding(.vertical, 12)
                .frame(maxWidth: 163)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}
private extension AddFriendsScreen {
    var searchFriendsView: some View {
        VStack(spacing: 20) {
            searchField
                .padding(.top, 18)

            if vm.searchText.isEmpty {
                emptySearchPrompt
            } else if vm.isSearching {
                ProgressView()
                    .padding(.top, 40)
            } else {
                suggestionsList
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}
private extension AddFriendsScreen {
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search by name or username...", text: $vm.searchText)
                .font(.customFont(.robotoMedium, .pt14))
                .foregroundStyle(
                    Color(hex: "#1A1F2F").opacity(0.7)
                )

            if !vm.searchText.isEmpty {
                Button(action: { vm.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
private extension AddFriendsScreen {
    var emptySearchPrompt: some View {
        VStack(spacing: 10) {
            Text("Search for a friend")
                .font(.customFont(.robotoMedium, .pt14))
                .foregroundColor(
                    Color(hex: "#1A1F2F").opacity(0.7)
                )

            Text("or")
                .font(.customFont(.robotoMedium, .pt14))
                .foregroundColor(
                    Color(hex: "#1A1F2F").opacity(0.7)
                )

            Button(action: {}) {
                Text("Invite a friend")
                    .font(.customFont(.robotoMedium, .pt14))
                    .foregroundColor(
                        Color(hex: "#00213D")
                    )
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.top, 150)
    }
}

private extension AddFriendsScreen {
    var suggestionsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(vm.suggestions) { user in
                    suggestionRow(user)
                    Divider().padding(.leading, 72)
                }
            }
        }
    }

    func suggestionRow(_ user: UserSuggestion) -> some View {
        HStack {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.customFont(.robotoBold, .pt14))
                    .foregroundColor(Color(hex: "#1A1F2F"))

                Text(user.username)
                    .font(.customFont(.robotoRegular, .pt12))
                    .foregroundColor(Color(hex: "#1A1F2F"))
            }

            Spacer()

            Button("Add Friend") {}
                .font(.customFont(.robotoBold, .pt14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(hex: "#1A1F2F"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.vertical, 12)
    }
}
//  improve this screen, spacing, font etc
#Preview {
    AddFriendsScreen()
}
