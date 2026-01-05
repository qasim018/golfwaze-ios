//
//  golfWazeApp.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 20/11/2025.
//

import SwiftUI
import GoogleMaps

@main
struct golfWazeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            RootFlowView()
                .preferredColorScheme(.light)

        }
    }
    
    init() {
        print("🏁 golfWazeApp.init() CALLED")
        // GMSServices.provideAPIKey("AIzaSyC9s2o5LHBYv8X-sZUyDUk83qiycyLv2C8")
        GMSServices.provideAPIKey("AIzaSyBDId_4WLG95wAKlylycxr7y_0qPYYx5Ng")
        print("GMS SDK Version: \(GMSServices.sdkVersion())")
    }
}
