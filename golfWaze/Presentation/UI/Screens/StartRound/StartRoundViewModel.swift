//
//  StartRoundView.swift
//  golfWaze
//
//  Created by Naveed Tahir on 04/01/2026.
//

import Foundation
import GoogleMaps

func printRawJSON(_ data: Data) {
    if let jsonString = String(data: data, encoding: .utf8) {
        print("\n========= RAW JSON RESPONSE =========\n\(jsonString)\n=====================================\n")
    } else {
        print("⚠️ Unable to decode JSON as UTF-8 string")
    }
}
import Foundation
import GoogleMaps
import CoreLocation

@MainActor
class StartRoundViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var roundResponse: CreateRoundResponse?

    private let apiURL = URL(string:
        "https://golfwaze.com/dashbord/new_api.php?action=create_round"
    )!

    func createRound(_ body: CreateRoundRequest) async {
        isLoading = true
        errorMessage = nil

        do {
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)

            let (data, _) = try await URLSession.shared.data(for: request)
            printRawJSON(data)

            let decoder = JSONDecoder()
            let response = try decoder.decode(CreateRoundResponse.self, from: data)

            await MainActor.run {
                self.roundResponse = response
            }

        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }

        await MainActor.run {
            self.isLoading = false
        }
    }
}
@MainActor
class LiveTrafficViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var traffic: LiveTrafficResponse?
    @Published var coordinates: [CLLocationCoordinate2D] = []

    private var currentTask: Task<Void, Never>?

    func cancelRequests() {
        currentTask?.cancel()
        currentTask = nil
        isLoading = false
    }

    func fetchLiveTraffic(courseId: String, token: String) {

        guard isLoading == false else { return }

        isLoading = true
        errorMessage = nil

        currentTask = Task {

            guard let url = URL(string:
                "https://golfwaze.com/dashbord/new_api.php?action=get_live_traffic&course_id=\(courseId)&token=\(token)"
            ) else {
                await MainActor.run {
                    self.errorMessage = "Invalid URL"
                    self.isLoading = false
                }
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                printRawJSON(data)

                try Task.checkCancellation()

                let response = try JSONDecoder().decode(LiveTrafficResponse.self, from: data)

                await MainActor.run {

                    self.traffic = response

                    // fallback to course location if no active players
                    let coords = response.active_players.map {
                        CLLocationCoordinate2D(latitude: $0.location.lat,
                                               longitude: $0.location.lng)
                    }

                    self.coordinates = coords
                    print("🟢 Updated coordinates =", coords)
                }

            } catch {
                if error is CancellationError {
                    print("🔹 API Cancelled")
                } else {
                    await MainActor.run {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }

            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

extension LiveTrafficViewModel {

    func updateLiveTraffic(_ payload: UpdateLiveTrafficRequest) async {

        guard let url = URL(string:
            "https://golfwaze.com/dashbord/new_api.php?action=update_live_traffic"
        ) else {
            await MainActor.run {
                errorMessage = "Invalid URL"
            }
            return
        }

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = try JSONEncoder().encode(payload)
            request.httpBody = body

            let (data, _) = try await URLSession.shared.data(for: request)
            printRawJSON(data)

            let decoder = JSONDecoder()
            let response = try decoder.decode(UpdateLiveTrafficResponse.self, from: data)

            print("Updated player:", response.data)

        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
}
