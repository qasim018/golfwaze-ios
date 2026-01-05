//
//  CourseMarkerView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 14/12/2025.
//

import SwiftUI
import GoogleMaps
import Foundation
import Combine

struct CourseMarker {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let holeTitle: String
    let clubName: String
    let groupsText: String
    let courseName: String
    let status: Int // 0 = red, 1 = yellow, 2 = green
}

enum CourseStatus: Int {
    case red = 0
    case yellow = 1
    case green = 2
}


extension CourseStatus {
    var color: UIColor {
        switch self {
        case .red: return .systemRed
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        }
    }
}

final class CourseMarkerView: UIView {
    
    init(
        courseTitle: String,
        courseName: String,
        status: CourseStatus
    ) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
        // MARK: Bubble container
        let bubble = UIView()
        bubble.backgroundColor = .white
        bubble.layer.cornerRadius = 16
        bubble.layer.shadowColor = UIColor.black.cgColor
        bubble.layer.shadowOpacity = 0.15
        bubble.layer.shadowRadius = 6
        bubble.layer.shadowOffset = .zero
        bubble.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = courseTitle
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        // Location Row
        let pinIcon = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        pinIcon.tintColor = .black
        pinIcon.setContentHuggingPriority(.required, for: .horizontal)

        let locationLabel = UILabel()
        locationLabel.text = courseName
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = .darkGray
        
        let locationRow = UIStackView(arrangedSubviews: [pinIcon, locationLabel])
        locationRow.axis = .horizontal
        locationRow.spacing = 6
        locationRow.alignment = .center
        
        // Vertical content stack
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            locationRow
        ])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        bubble.addSubview(stack)
        addSubview(bubble)
        
        NSLayoutConstraint.activate([
            bubble.widthAnchor.constraint(lessThanOrEqualToConstant: 180),

            bubble.topAnchor.constraint(equalTo: topAnchor),
            bubble.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubble.trailingAnchor.constraint(equalTo: trailingAnchor),

            stack.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -12)
        ])
        
        // MARK: Pointer triangle
        let triangle = TriangleView()
        triangle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(triangle)

        NSLayoutConstraint.activate([
            triangle.topAnchor.constraint(equalTo: bubble.bottomAnchor),
            triangle.centerXAnchor.constraint(equalTo: bubble.centerXAnchor),
            triangle.widthAnchor.constraint(equalToConstant: 18),
            triangle.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        // MARK: Status ellipse
        let ellipse = UIView()
        ellipse.backgroundColor = status.color
        ellipse.layer.cornerRadius = 18
        ellipse.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ellipse)

        NSLayoutConstraint.activate([
            ellipse.topAnchor.constraint(equalTo: triangle.bottomAnchor, constant: 6),
            ellipse.centerXAnchor.constraint(equalTo: centerXAnchor),
            ellipse.widthAnchor.constraint(equalToConstant: 36),
            ellipse.heightAnchor.constraint(equalToConstant: 36),
            bottomAnchor.constraint(equalTo: ellipse.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func statusColor(_ value: Int) -> UIColor {
        switch value {
        case 0: return .systemRed
        case 1: return .systemYellow
        default: return .systemGreen
        }
    }
}

final class TriangleView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.close()
        
        UIColor(white: 0.97, alpha: 1).setFill()
        backgroundColor = .clear
        path.fill()
    }
}

final class CoursesMapVM: ObservableObject {
    
    @Published var coordinates: [CLLocationCoordinate2D] = []
    @Published var markers: [CourseMarker] = []
    
    @MainActor func getNearbyCourses() {

        let lat = LocationManager.shared.latitude ?? 41.051548
        let lng = LocationManager.shared.longitude ?? -73.80265

        APIClient.shared.getNearbyCourses(
            lat: lat,
            lng: lng
        ) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):

                self.coordinates = response.courses.compactMap { course in
                    guard
                        let lat = course.location?.latitude,
                        let lng = course.location?.longitude
                    else { return nil }

                    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
                }

                self.markers = response.courses.map { course in
                    let lat = course.location?.latitude ?? 0.0
                    let lng = course.location?.longitude ?? 0.0
                    let holesCount = course.holesCount ?? 0
                    let parTotal = course.parTotal ?? 0

                    return CourseMarker(
                        id: course.id ?? "",
                        coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                        holeTitle: "Holes: \(holesCount)",
                        clubName: course.clubName ?? "",
                        groupsText: "Par: \(parTotal)",
                        courseName: course.courseName ?? "",
                        status: 1
                    )
                }

            case .failure(let error):
                print("Nearby courses error:", error)
            }
        }
    }

}
