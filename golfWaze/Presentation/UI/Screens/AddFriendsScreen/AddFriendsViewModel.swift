//
//  AddFriendsViewModel.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 06/12/2025.
//

import Combine
import Foundation

final class AddFriendsViewModel: ObservableObject {
    @Published var selectedTab: AddFriendTab = .sendLink
    @Published var searchText: String = ""
    @Published var suggestions: [UserSuggestion] = []
    @Published var isSearching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchListener()
    }
    
    private func setupSearchListener() {
        $searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                self.handleSearch(text: text)
            }
            .store(in: &cancellables)
    }
    
    private func handleSearch(text: String) {
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            suggestions = []
            return
        }
        
        isSearching = true
        
        // Simulate async API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.suggestions = [
                UserSuggestion(name: "Eden Alley", username: "@edenalley", imageName: "p1"),
                UserSuggestion(name: "Eden Alley", username: "@edenalley", imageName: "p1"),
                UserSuggestion(name: "Eden Alley", username: "@edenalley", imageName: "p1")
            ]
            self.isSearching = false
        }
    }
}

enum AddFriendTab { case sendLink, searchFriends }

struct UserSuggestion: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let username: String
    let imageName: String
}
