//
//  GoogleMapView.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 30/11/2025.
//

//import SwiftUI
//import GoogleMaps
//
//struct GoogleMapView: UIViewRepresentable {
//
//    var coordinates: [CLLocationCoordinate2D]
//
//    func makeUIView(context: Context) -> GMSMapView {
//        let camera = GMSCameraPosition(
//            latitude: coordinates.first?.latitude ?? 0,
//            longitude: coordinates.first?.longitude ?? 0,
//            zoom: 16
//        )
//
//        let options = GMSMapViewOptions()
//        options.camera = camera
//        options.frame = .zero
//        //let map = GMSMapView(frame: .zero, camera: camera)
//        let map = GMSMapView(options: options)
//        map.isMyLocationEnabled = false
//        map.settings.zoomGestures = true
//        map.settings.scrollGestures = true
//        map.settings.rotateGestures = true
//        map.settings.tiltGestures = false
//        //map.mapType = .satellite
//        map.mapType = .normal
//        return map
//    }
//
//    func updateUIView(_ mapView: GMSMapView, context: Context) {
//        mapView.clear()
//
//        drawPolyline(on: mapView)
//        drawConcentricCircles(on: mapView)
//    }
//
//    // MARK: - Draw Line Between Coordinates
//    private func drawPolyline(on map: GMSMapView) {
//        guard coordinates.count >= 2 else { return }
//
//        let path = GMSMutablePath()
//        coordinates.forEach { path.add($0) }
//
//        let polyline = GMSPolyline(path: path)
//        polyline.strokeColor = .systemBlue
//        polyline.strokeWidth = 4
//        polyline.map = map
//    }
//
//    // MARK: - Draw Concentric Circles
//    private func drawConcentricCircles(on map: GMSMapView) {
//        let radii = [30.0, 60.0, 90.0]   // meters (adjust as needed)
//
//        coordinates.forEach { coordinate in
//            radii.forEach { radius in
//                let circle = GMSCircle(position: coordinate, radius: radius)
//                circle.strokeColor = UIColor.systemBlue.withAlphaComponent(0.7)
//                circle.fillColor = UIColor.systemBlue.withAlphaComponent(0.08)
//                circle.strokeWidth = 2
//                circle.map = map
//            }
//        }
//    }
//}

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {

    var coordinates: [CLLocationCoordinate2D]

    // 🔹 Optional configurable settings (with defaults)
    var initialZoom: Float = 18
    var minZoom: Float = 5
    var maxZoom: Float = 22
    var mapType: GMSMapViewType = .satellite   // default satellite

    @Binding var zoomAction: ZoomAction?
    
    enum ZoomAction {
        case zoomIn
        case zoomOut
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GMSMapView {
        // 🔹 Start with a default valid location (e.g., center of US or your region)
        let defaultLocation = CLLocationCoordinate2D(latitude:  41.050833, longitude: -73.803112) // San Francisco
        
        let camera = GMSCameraPosition(
            latitude: defaultLocation.latitude,
            longitude: defaultLocation.longitude,
            zoom: 2  // 🔹 Start zoomed out
        )

        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.setMinZoom(minZoom, maxZoom: maxZoom)
        mapView.mapType = mapType
        
        context.coordinator.mapView = mapView

        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.clear()

        // 🔹 Add markers and update camera when coordinates arrive
        if !coordinates.isEmpty {
//            coordinates.forEach {
//                let marker = GMSMarker(position: $0)
//                marker.map = mapView
//            }
            
            coordinates.forEach { coord in
                let marker = GMSMarker(position: coord)

                // 🔹 Placeholder profile image (replace with downloaded image)
                let profileImage = UIImage(named: "p1") ?? UIImage()

                marker.icon = makeProfileMarkerIcon(image: profileImage)
                marker.groundAnchor = CGPoint(x: 0.5, y: 1.0) // pin tip aligns correctly
                marker.map = mapView
            }

            
            // 🔹 Move camera to first coordinate (only once when data first loads)
            if !context.coordinator.hasSetInitialPosition, let first = coordinates.first {
                let camera = GMSCameraPosition(
                    target: first,
                    zoom: initialZoom
                )
                mapView.animate(to: camera)
                context.coordinator.hasSetInitialPosition = true
            }
        }

        // handle zoom
        if let action = zoomAction {
            var zoom = mapView.camera.zoom
            zoom += (action == .zoomIn ? 1 : -1)

            mapView.animate(toZoom: zoom)
            DispatchQueue.main.async {
                zoomAction = nil   // reset
            }
        }
    }

    class Coordinator {
        weak var mapView: GMSMapView?
        var hasSetInitialPosition = false  // 🔹 Track if we've set the camera position
    }
    
    func makeProfileMarkerIcon(image: UIImage) -> UIImage {

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 90))
        container.backgroundColor = .clear

        // Pin background
        let pin = UIImageView(frame: container.bounds)
        pin.image = UIImage(named: "pin_blue")
        pin.contentMode = .scaleAspectFit
        container.addSubview(pin)

        // 🔹 Avatar tuned to fit perfectly in white circle
        let avatarSize: CGFloat = 38
        let avatarCenterY: CGFloat = 6   // move up/down to fine-tune

        let avatar = UIImageView(
            frame: CGRect(
                x: (container.bounds.width - avatarSize) / 2,
                y: avatarCenterY,
                width: avatarSize,
                height: avatarSize
            )
        )

        avatar.image = image
        avatar.layer.cornerRadius = avatarSize / 2
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 2
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.contentMode = .scaleAspectFill
        container.addSubview(avatar)

        // Render UIView → UIImage
        UIGraphicsBeginImageContextWithOptions(container.bounds.size, false, 0)
        container.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        return result
    }


}
