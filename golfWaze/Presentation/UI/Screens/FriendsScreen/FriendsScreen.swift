//
//  FriendsScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 06/12/2025.
//

import SwiftUI

struct FriendsScreen: View {
    
    @EnvironmentObject var coordinator: TabBarCoordinator
    
    @StateObject private var vm = FriendsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            headerView

            ScrollView {
                contentView
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadDummyData()   // Remove in production
        }
    }

    var headerView: some View {
        HStack {
            Button {
                coordinator.pop()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text("Friends")
                        .font(.customFont(.robotoSemiBold, .pt16))
                        .foregroundStyle(Color(hex: "#00213D"))
                }
            }

            

            Spacer()
            if !vm.friends.isEmpty {
                Button(action: {
                    coordinator.push(.addFriends)
                }) {
                    Text("Add Friend")
                        .font(.customFont(.robotoMedium, .pt14))
                        .padding(.horizontal, 20)
                        .frame(height: 38)
                        .background(Color(hex: "#00213D"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
    }
    
    var contentView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Friend Requests Section
            
            HStack {
                Text("Friend Requests (\(vm.friendRequests.count))")
                    .font(.customFont(.robotoSemiBold, .pt14))
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
            if !vm.friendRequests.isEmpty {
                VStack(spacing: 0) {
                    ForEach(vm.friendRequests) { req in
                        FriendRequestRow(request: req)
                        Divider()
                            .padding(.leading, 72)
                    }
                }
            } else {
                Text("No Friend Requests")
                    .font(.customFont(.robotoRegular, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F").opacity(0.7))
                    .padding(.leading)
            }
            
            // Friends Section
            HStack {
                Text("Friends (\(vm.friends.count))")
                    .font(.customFont(.robotoSemiBold, .pt14))
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal)
            if !vm.friends.isEmpty {
                VStack(spacing: 0) {
                    ForEach(vm.friends) { friend in
                        FriendRow(friend: friend)
                        Divider()
                            .padding(.leading, 72)
                    }
                }
            } else {
                emptyStateView
            }
        }
        .padding(.top, 10)
    }
    
    var emptyStateView: some View {
        VStack(spacing: 30) {
            // Friends Empty

            Image("golf_man")
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .foregroundColor(.blue.opacity(0.85))

            Text("Add Friends")
                .font(.customFont(.robotoBold, .pt16))

            Text("Share a link to invite your\nfriends to join you on golfwaze")
                .font(.customFont(.robotoMedium, .pt14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button(action: {
                coordinator.push(.addFriends)
            }) {
                Text("Add Friend")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#00213D"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
    }
}

#Preview {
    FriendsScreen()
}

struct FriendRequestRow: View {
    let request: FriendRequest

    var body: some View {
        HStack {
            profileImage
            
            VStack(alignment: .leading) {
                Text(request.name)
                    .font(.customFont(.robotoSemiBold, .pt14))
                Text(request.timeAgo)
                    .font(.customFont(.robotoRegular, .pt12))
                    .foregroundColor(.gray)
            }
            
            Spacer()

            Button(action: {}) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: "#F5F7F9"))
                        .frame(width: 32, height: 32)
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                .frame(width: 32, height: 32)
            }

            Button(action: {}) {
                Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: 32, height: 32)
                    .overlay(Image(systemName: "checkmark").tint(.black))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private var profileImage: some View {
        Image(request.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 54, height: 54)
            .clipShape(Circle())
    }
}

struct FriendRow: View {
    let friend: Friend

    var body: some View {
        HStack {
            Image(friend.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 54, height: 54)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(friend.name)
                    .font(.system(size: 18, weight: .semibold))
                Text(friend.timeAgo)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

private extension FriendsScreen {
    func loadDummyData() {
        vm.friendRequests = [
            FriendRequest(name: "Eden Alley", timeAgo: "1 day ago", imageName: "p1"),
            FriendRequest(name: "Eden Alley", timeAgo: "1 day ago", imageName: "p1")
        ]

        vm.friends = [
            Friend(name: "Eden Alley", timeAgo: "1 day ago", imageName: "p1"),
            Friend(name: "Eden Alley", timeAgo: "1 day ago", imageName: "p1"),
            Friend(name: "Eden Alley", timeAgo: "1 day ago", imageName: "p1")
        ]
    }
}
