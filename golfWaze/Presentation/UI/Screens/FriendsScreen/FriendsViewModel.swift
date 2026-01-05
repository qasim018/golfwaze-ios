//
//  FriendsViewModel.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 06/12/2025.
//

import Foundation

final class FriendsViewModel: ObservableObject {
    @Published var friendRequests: [FriendRequest] = []
    @Published var friends: [Friend] = []

    var isEmptyState: Bool {
        friendRequests.isEmpty && friends.isEmpty
    }
}

struct Friend: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let timeAgo: String
    let imageName: String
}

struct FriendRequest: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let timeAgo: String
    let imageName: String
}
