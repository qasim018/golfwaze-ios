//
//  LocationManager.swift
//  golfWaze
//
//  Created by Naveed Tahir on 05/01/2026.
//


import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject {

    static let shared = LocationManager()

    private let manager = CLLocationManager()

    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var locationError: String?
    @Published var isLocationReady = false

    
    override private init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5 // meters
    }

    // MARK: - Permission Request
    func requestLocationAccess() {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            locationError = "Location permission denied. Enable it in Settings."

        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()

        @unknown default:
            break
        }
    }

    // MARK: - Single Fetch (One-time location)
    func getCurrentLocation() {
        manager.requestLocation()
    }
}

// MARK: - CLLocation Delegate
extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        requestLocationAccess()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        latitude = loc.coordinate.latitude
        longitude = loc.coordinate.longitude
        locationError = nil
        isLocationReady = true   // 👈 trigger API load
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
    }
}
