//
//  CoursesMapViewRepresentable.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 13/12/2025.
//

import SwiftUI
import GoogleMaps

struct CoursesMapViewRepresentable: UIViewRepresentable {

    var coordinates: [CLLocationCoordinate2D]
    var markers: [CourseMarker]
    var onMarkerTap: (CourseMarker) -> Void

    // 🔹 Dynamic Map Options
    var mapType: GMSMapViewType = .normal      // .satellite / .hybrid / .terrain
    var initialZoom: Float = 18               // default closer zoom
    var minZoom: Float = 5
    var maxZoom: Float = 22

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> GMSMapView {

        let camera = GMSCameraPosition(
            latitude: coordinates.first?.latitude ?? 41.051548,
            longitude: coordinates.first?.longitude ?? -73.80265,
            zoom: initialZoom
        )

        let options = GMSMapViewOptions()
        options.camera = camera
        options.frame = .zero

        let mapView = GMSMapView(options: options)

        mapView.delegate = context.coordinator
        mapView.mapType = mapType

        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = false

        mapView.setMinZoom(minZoom, maxZoom: maxZoom)

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.mapType = mapType   // 🔹 live update map style

        mapView.clear()
        addMarkers(on: mapView)

        // Fit all markers in view
        if coordinates.count > 1 {
            var bounds = GMSCoordinateBounds()
            coordinates.forEach { bounds = bounds.includingCoordinate($0) }

            let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
            mapView.animate(with: update)

        } else if let first = coordinates.first {
            mapView.animate(
                to: GMSCameraPosition(latitude: first.latitude,
                                      longitude: first.longitude,
                                      zoom: initialZoom)
            )
        }
    }

    private func addMarkers(on map: GMSMapView) {
        markers.forEach { item in
            let marker = GMSMarker(position: item.coordinate)

            let markerView = CourseMarkerView(
                courseTitle: item.clubName,
                courseName: item.courseName,
                status: CourseStatus(rawValue: item.status) ?? .red
            )

            markerView.layoutIfNeeded()
            let size = markerView.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize
            )
            markerView.bounds = CGRect(origin: .zero, size: size)

            marker.iconView = markerView
            marker.userData = item
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.0)
            marker.tracksViewChanges = false
            marker.map = map
        }
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        let parent: CoursesMapViewRepresentable
        init(_ parent: CoursesMapViewRepresentable) { self.parent = parent }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let item = marker.userData as? CourseMarker {
                parent.onMarkerTap(item)
            }
            return true
        }
    }
}
