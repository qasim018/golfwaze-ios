//
//  CoursesMapViewRepresentable.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 13/12/2025.
//

import SwiftUI
import GoogleMaps

// MARK: - SwiftUI → UIKit Map Wrapper
struct CoursesMapViewRepresentable: UIViewRepresentable {

    var coordinates: [CLLocationCoordinate2D]
    var markers: [CourseMarker]
    var onMarkerTap: (CourseMarker) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Make UIView
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition(
            latitude: coordinates.first?.latitude ?? 41.051548,
            longitude: coordinates.first?.longitude ?? -73.80265,
            zoom: 16
        )

        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = .zero

        let mapView = GMSMapView(options: options)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = false
        mapView.mapType = .normal
        mapView.delegate = context.coordinator   // <-- 👈 important
        return mapView
    }

    // MARK: - Update UIView
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()
        addMarkers(on: mapView)
        
        // Adjust camera to show all markers if available
        if !coordinates.isEmpty && coordinates.count > 1 {
            var bounds = GMSCoordinateBounds()
            for coordinate in coordinates {
                bounds = bounds.includingCoordinate(coordinate)
            }
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 80.0)
            mapView.animate(with: update)
        }
    }
    
    // MARK: - Custom Markers
    private func addMarkers(on map: GMSMapView) {

        markers.forEach { item in
            let marker = GMSMarker(position: item.coordinate)

            let markerView = CourseMarkerView(
                courseTitle: item.clubName,
                courseName: item.courseName,
                status: CourseStatus(rawValue: item.status) ?? .red
            )

            // 🔹 Important: layout + size
            markerView.layoutIfNeeded()
            let size = markerView.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            )
            markerView.bounds = CGRect(origin: .zero, size: size)
            marker.userData = item      
            marker.iconView = markerView
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)

            marker.tracksViewChanges = false   // turn true only if animating
            marker.map = map
        }
    }

}
class Coordinator: NSObject, GMSMapViewDelegate {

    let parent: CoursesMapViewRepresentable

    init(_ parent: CoursesMapViewRepresentable) {
        self.parent = parent
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let item = marker.userData as? CourseMarker {
            parent.onMarkerTap(item)   // 🔹 callback only
        }
        return true
    }
}

