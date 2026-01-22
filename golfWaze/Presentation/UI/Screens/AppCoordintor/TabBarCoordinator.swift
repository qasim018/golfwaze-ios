//
//  TabBarCoordinator.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 14/12/2025.
//

import SwiftUI

final class TabBarCoordinator: ObservableObject {
    enum Route: Hashable {
        case writeReview
        case coursesList
        case courseReview
        case golfCourseDetailView(course: CourseDetail)
        case friendsList
        case addFriends
        case editProfile(data: BasicProfile)
        case golfHole(course: CourseDetail, response: CreateRoundResponse)
        case createRound(course: CourseDetail)
        case scoreCardView

        static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {

            case (.golfHole(let c1, let r1), .golfHole(let c2, let r2)):
                return c1 == c2 && r1.round_id == r2.round_id

            default:
                return String(describing: lhs) == String(describing: rhs)
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {

            case .golfHole(let course, let response):
                hasher.combine("golfHole")
                hasher.combine(course)
                hasher.combine(response.round_id)

            default:
                hasher.combine(String(describing: self))
            }
        }
    }

    
    @Published var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
