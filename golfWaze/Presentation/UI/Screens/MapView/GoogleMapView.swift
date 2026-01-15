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
import CoreLocation

struct GoogleMapView: UIViewRepresentable {

    var coordinates: [CLLocationCoordinate2D]
    @Binding var mapLinescoordinates: [CLLocationCoordinate2D]

    var initialZoom: Float = 18
    var minZoom: Float = 5
    var maxZoom: Float = 22
    var mapType: GMSMapViewType = .satellite
    var currentHole: Int = 0
    
    @Binding var zoomAction: ZoomAction?
    var onPinTap: ((CLLocationCoordinate2D) -> Void)?   // 👈 NEW
    
    enum ZoomAction {
        case zoomIn
        case zoomOut
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(mapLinescoordinates: $mapLinescoordinates)
    }

    func makeUIView(context: Context) -> GMSMapView {

        let camera = GMSCameraPosition(
            latitude: mapLinescoordinates.first?.latitude ?? 41.05,
            longitude: mapLinescoordinates.first?.longitude ?? -73.80,
            zoom: initialZoom
        )

        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.mapType = mapType
        mapView.setMinZoom(minZoom, maxZoom: maxZoom)
        mapView.delegate = context.coordinator

        context.coordinator.mapView = mapView
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {

        if context.coordinator.isDragging { return }

        mapView.clear()

        // ===============================
        // DRAW LINE
        // ===============================
        if mapLinescoordinates.count >= 2 {

            let path = GMSMutablePath()
            mapLinescoordinates.forEach { path.add($0) }

            let polyline = GMSPolyline(path: path)
            polyline.strokeColor = .white
            polyline.strokeWidth = 4
            polyline.map = mapView
            context.coordinator.polyline = polyline

            let bounds = GMSCoordinateBounds(path: path)

            let currentHoleHash = GoogleMapView.holeHash(mapLinescoordinates)

            if context.coordinator.lastHoleHash != currentHoleHash {
                context.coordinator.lastHoleHash = currentHoleHash
//                
//                let totalDistance = GoogleMapView.totalHoleDistance(mapLinescoordinates)
//                let padding = GoogleMapView.dynamicPadding(for: totalDistance)

                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: currentHole == 0 ? -70 : 90))

                if mapLinescoordinates.count >= 3 {
                    let tee = mapLinescoordinates[0]
                    let green = mapLinescoordinates[2]
                    let bearing = GoogleMapView.bearingBetween(green, tee)
                    mapView.animate(toBearing: bearing)
                }
            }
        }

        // ===============================
        // PLAYER MARKERS
        // ===============================
        coordinates.forEach {
            let m = GMSMarker(position: $0)
            m.icon = makeProfileMarkerIcon(image: UIImage(named: "p1") ?? UIImage())
            m.groundAnchor = CGPoint(x: 0.5, y: 1)
            m.map = mapView
        }

        // ===============================
        // TEE / MID / GREEN
        // ===============================
        if mapLinescoordinates.count >= 3 {

            let tee = GMSMarker(position: mapLinescoordinates[0])
            tee.icon = UIImage(named: "teeImage")
            tee.isDraggable = true
            tee.userData = "tee"
            tee.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            tee.map = mapView
            context.coordinator.teeMarker = tee

            let mid = GMSMarker(position: mapLinescoordinates[1])
            mid.icon = UIImage(named: "centerImage")
            mid.isDraggable = true
            mid.userData = "mid"
            mid.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            mid.map = mapView
            context.coordinator.midMarker = mid

            let green = GMSMarker(position: mapLinescoordinates[2])
            green.icon = UIImage(named: "holeImage")
            green.isDraggable = false
            green.userData = "green"
            green.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            green.map = mapView
            context.coordinator.greenMarker = green

            let teeCoord = mapLinescoordinates[0]
            let midCoord = mapLinescoordinates[1]
            let greenCoord = mapLinescoordinates[2]

            let teeMidDistance = GoogleMapView.distanceBetween(teeCoord, midCoord)
            let teeMidCenter = GoogleMapView.midPoint(teeCoord, midCoord)

            let teeMidLabel = GMSMarker(position: teeMidCenter)
            teeMidLabel.icon = GoogleMapView.createDistanceLabel(distance: teeMidDistance)
            teeMidLabel.map = mapView
            context.coordinator.teeToMidLabel = teeMidLabel

            let midGreenDistance = GoogleMapView.distanceBetween(midCoord, greenCoord)
            let midGreenCenter = GoogleMapView.midPoint(midCoord, greenCoord)

            let midGreenLabel = GMSMarker(position: midGreenCenter)
            midGreenLabel.icon = GoogleMapView.createDistanceLabel(distance: midGreenDistance)
            midGreenLabel.map = mapView
            context.coordinator.midToGreenLabel = midGreenLabel
        }

        // ===============================
        // ZOOM ACTIONS
        // ===============================
        if let action = zoomAction {
            mapView.animate(toZoom: mapView.camera.zoom + (action == .zoomIn ? 1 : -1))
            DispatchQueue.main.async { zoomAction = nil }
        }
    }
    
    static func totalHoleDistance(_ coords: [CLLocationCoordinate2D]) -> Double {
        guard coords.count >= 3 else { return 0 }
        let tee = coords[0]
        let mid = coords[1]
        let green = coords[2]

        let d1 = distanceBetween(tee, mid)
        let d2 = distanceBetween(mid, green)

        return d1 + d2
    }

    static func dynamicPadding(for distance: Double) -> CGFloat {
        switch distance {
        case 0..<100:
            return 160
        case 100..<200:
            return 130
        default:
            return 90
        }
    }


    // MARK: - Coordinator
    class Coordinator: NSObject, GMSMapViewDelegate {

        weak var mapView: GMSMapView?
        @Binding var mapLinescoordinates: [CLLocationCoordinate2D]

        var polyline: GMSPolyline?
        var teeMarker: GMSMarker?
        var midMarker: GMSMarker?
        var greenMarker: GMSMarker?

        var teeToMidLabel: GMSMarker?
        var midToGreenLabel: GMSMarker?

        var isDragging = false
        var lastHoleHash: Int?

        init(mapLinescoordinates: Binding<[CLLocationCoordinate2D]>) {
            self._mapLinescoordinates = mapLinescoordinates
        }

        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let id = marker.userData as? String, id != "green" {
                marker.isDraggable = true
                mapView.selectedMarker = marker
                return true
            }
            return false
        }

        func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
            isDragging = true
        }

        func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
            guard let id = marker.userData as? String else { return }

            if id == "tee" { mapLinescoordinates[0] = marker.position }
            if id == "mid" { mapLinescoordinates[1] = marker.position }

            let path = GMSMutablePath()
            mapLinescoordinates.forEach { path.add($0) }
            polyline?.path = path

            let tee = mapLinescoordinates[0]
            let mid = mapLinescoordinates[1]
            let green = mapLinescoordinates[2]

            let teeMidDistance = GoogleMapView.distanceBetween(tee, mid)
            let teeMidCenter = GoogleMapView.midPoint(tee, mid)
            teeToMidLabel?.position = teeMidCenter
            teeToMidLabel?.icon = GoogleMapView.createDistanceLabel(distance: teeMidDistance)

            let midGreenDistance = GoogleMapView.distanceBetween(mid, green)
            let midGreenCenter = GoogleMapView.midPoint(mid, green)
            midToGreenLabel?.position = midGreenCenter
            midToGreenLabel?.icon = GoogleMapView.createDistanceLabel(distance: midGreenDistance)
        }

        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            isDragging = false
        }
    }

    // MARK: - Helpers

    static func holeHash(_ coords: [CLLocationCoordinate2D]) -> Int {
        var hasher = Hasher()
        coords.forEach {
            hasher.combine($0.latitude)
            hasher.combine($0.longitude)
        }
        return hasher.finalize()
    }

    static func distanceBetween(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
        CLLocation(latitude: a.latitude, longitude: a.longitude)
            .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude)) * 1.09361
    }

    static func midPoint(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: (a.latitude + b.latitude) / 2,
            longitude: (a.longitude + b.longitude) / 2
        )
    }

    static func bearingBetween(_ start: CLLocationCoordinate2D, _ end: CLLocationCoordinate2D) -> CLLocationDegrees {
        let lat1 = start.latitude * .pi / 180
        let lon1 = start.longitude * .pi / 180
        let lat2 = end.latitude * .pi / 180
        let lon2 = end.longitude * .pi / 180

        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansBearing * 180 / .pi
    }

    static func createDistanceLabel(distance: Double) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.text = "\(Int(distance)) y"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .white
        label.backgroundColor = UIColor(hex: "#FD6602")//UIColor.black.withAlphaComponent(0.75)
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.masksToBounds = true

        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }

    func makeProfileMarkerIcon(image: UIImage) -> UIImage {
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
