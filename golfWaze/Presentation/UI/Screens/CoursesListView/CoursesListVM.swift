//
//  CoursesListVM.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 15/12/2025.
//

import Foundation
import Combine

final class CoursesListVM: ObservableObject {
    
    @Published var courses: [Course] = []

    func onAppear() {

//        APIClient.shared.getNearbyCourses { result in
//            switch result {
//            case .success(let course):
//                self.courses = course.courses
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
        APIClient.shared.getNearbyCourses(
            lat: 33.88,
            lng: -116.55
        ) { result in
            switch result {
            case .success(let course):
                self.courses = course.courses
            case .failure(let error):
                print("Error: \(error)")
            }
        }

    }

    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearch()
    }

    private func getNearby() {
        
//        APIClient.shared.getNearbyCourses { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let course):
//                    self?.courses = course.courses
//                case .failure(let error):
//                    print("Error:", error)
//                }
//            }
//        }
        APIClient.shared.getNearbyCourses(
            lat: 33.88,
            lng: -116.55
        ) { result in
            switch result {
            case .success(let course):
                self.courses = course.courses
            case .failure(let error):
                print("Error: \(error)")
            }
        }

        
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }

                if text.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.getNearby()
                } else {
                    self.fetchCourses(query: text)
                }
            }
            .store(in: &cancellables)
    }
    

    private func fetchCourses(query: String) {
        APIClient.shared.searchCourses(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.courses = response.courses
                case .failure(let error):
                    print("Search error:", error)
                }
            }
        }
    }

    
}
