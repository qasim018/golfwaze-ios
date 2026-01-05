//
//  AppDelegate.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FontManager.registerAllFonts()
        // let success = GMSServices.provideAPIKey("AIzaSyC9s2o5LHBYv8X-sZUyDUk83qiycyLv2C8")
//        let success = GMSServices.provideAPIKey("AIzaSyDWcjG_SiSPpoaS3yK7oaeKCCWNBjlC-14")
//        GMSServices.provideAPIKey("AIzaSyC9s2o5LHBYv8X-sZUyDUk83qiycyLv2C8")
        GMSServices.provideAPIKey("AIzaSyCSWt8Larh8ULBrFCEzO_v2kIAtBgKC-B8")
        LocationManager.shared.requestLocationAccess()

        LocationManager.shared.getCurrentLocation()

//        if GMSServices.openSourceLicenseInfo().isEmpty {
//            print("Google Maps SDK initialized")
//        }
//        
        return true
    }
}
