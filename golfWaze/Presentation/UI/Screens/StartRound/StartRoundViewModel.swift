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
//            let response = try decoder.decode(CreateRoundResponse.self, from: data)
            let response = mockRoundWithAllHoles()
            await MainActor.run {
                self.roundResponse = response//mockRoundWithAllHoles()
                UserDefaults.standard.saveRound(response)
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

func mockRoundWithAllHoles() -> CreateRoundResponse {
    return CreateRoundResponse(
        success: true,
        round_id: "r_mock_12345",
        status: "active",
        created_at: "2026-01-07T12:00:00Z",
        course: CourseInfo(
            course_id: "19417",
            club_name: "Sunrise Country Club",
            course_name: "Sunrise Country Club",
            location: CourseLocation(
                latitude: 33.753296,
                longitude: -116.414055,
                address: "",
                city: "",
                state: "",
                country: ""
            ),
            holes_count: "18"
        ),
        tee: TeeInfo(
            tee_id: "blue",
            tee_name: "Blue",
        ),
        players: [
            RoundPlayer(player_id: "3", name: "Umair Khan", profile_pic: nil)
        ],
        holes: allMockHoles(),
        scores: []
    )
}

func allMockHoles() -> [HoleInfo] {
    return [

        HoleInfo(hole_number: 1, par: 4, handicap: 9, yardage: 484,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29036110112124, lng: -118.49514484405519),
                    mid:   HoleCoordinate(lat: 34.29024863790201, lng: -118.49689967930316),
                    green: HoleCoordinate(lat: 34.289850583377465, lng: -118.49933512508869)
                 )),

        HoleInfo(hole_number: 2, par: 4, handicap: 7, yardage: 430,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.294972794462836, lng: -118.49379636347292),
                    mid:   HoleCoordinate(lat: 34.292501474630306, lng: -118.49335011094807),
                    green: HoleCoordinate(lat: 34.29070125989269,  lng: -118.49387548863888)
                 )),

        HoleInfo(hole_number: 3, par: 4, handicap: 5, yardage: 410,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29309895236256, lng: -118.49264234304427),
                    mid:   HoleCoordinate(lat: 34.29419888750721, lng: -118.49280595779418),
                    green: HoleCoordinate(lat: 34.29571040923819, lng: -118.4936310723424)
                 )),

        HoleInfo(hole_number: 4, par: 4, handicap: 11, yardage: 420,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.287835905491775, lng: -118.49344566464424),
                    mid:   HoleCoordinate(lat: 34.29042675076335, lng: -118.49328104406595),
                    green: HoleCoordinate(lat: 34.292542746988566, lng: -118.49280394613744)
                 )),

        HoleInfo(hole_number: 5, par: 5, handicap: 3, yardage: 520,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.284465443332884, lng: -118.49509757012129),
                    mid:   HoleCoordinate(lat: 34.28556936975939,  lng: -118.494552411139),
                    green: HoleCoordinate(lat: 34.28728271241974,  lng: -118.49353551864625)
                 )),

        HoleInfo(hole_number: 6, par: 3, handicap: 15, yardage: 165,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.283403333304754, lng: -118.4956618398428),
                    mid:   HoleCoordinate(lat: 34.28416071830249,  lng: -118.4955357760191),
                    green: HoleCoordinate(lat: 34.28485853699012,  lng: -118.49537048488855)
                 )),

        HoleInfo(hole_number: 7, par: 4, handicap: 1, yardage: 445,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.28360777806226, lng: -118.49908769130705),
                    mid:   HoleCoordinate(lat: 34.28361414963886, lng: -118.49780827760698),
                    green: HoleCoordinate(lat: 34.28285454349511, lng: -118.49547173827887)
                 )),

        HoleInfo(hole_number: 8, par: 3, handicap: 17, yardage: 155,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.28500092564136, lng: -118.49949739873408),
                    mid:   HoleCoordinate(lat: 34.28444909901839, lng: -118.49947359412907),
                    green: HoleCoordinate(lat: 34.28382191817611, lng: -118.49942464381456)
                 )),

        HoleInfo(hole_number: 9, par: 4, handicap: 13, yardage: 390,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.28864865225279, lng: -118.49924493581055),
                    mid:   HoleCoordinate(lat: 34.287558339868795, lng: -118.49917117506266),
                    green: HoleCoordinate(lat: 34.28561175359663, lng: -118.49917989224197)
                 )),

        HoleInfo(hole_number: 10, par: 4, handicap: 6, yardage: 420,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29267210384588, lng: -118.50059408694506),
                    mid:   HoleCoordinate(lat: 34.29187823185615, lng: -118.5008569434285),
                    green: HoleCoordinate(lat: 34.289850306372955, lng: -118.50010357797144)
                 )),

        HoleInfo(hole_number: 11, par: 5, handicap: 4, yardage: 520,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29688924989729, lng: -118.50015588104725),
                    mid:   HoleCoordinate(lat: 34.29511655091103, lng: -118.4998621791601),
                    green: HoleCoordinate(lat: 34.29302416400564, lng: -118.50013207644224)
                 )),

        HoleInfo(hole_number: 12, par: 4, handicap: 10, yardage: 405,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29909288416805, lng: -118.50064639002085),
                    mid:   HoleCoordinate(lat: 34.29771049541979, lng: -118.50061051547527),
                    green: HoleCoordinate(lat: 34.29631229588036, lng: -118.50061487406492)
                 )),

        HoleInfo(hole_number: 13, par: 3, handicap: 18, yardage: 165,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.30095606778804, lng: -118.50124418735504),
                    mid:   HoleCoordinate(lat: 34.30048660591291, lng: -118.50098803639412),
                    green: HoleCoordinate(lat: 34.29984818894595, lng: -118.5005709528923)
                 )),

        HoleInfo(hole_number: 14, par: 4, handicap: 8, yardage: 430,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.301122248353956, lng: -118.4978213533759),
                    mid:   HoleCoordinate(lat: 34.30095939140257, lng: -118.49913194775581),
                    green: HoleCoordinate(lat: 34.30133080449891, lng: -118.50063398480414)
                 )),

        HoleInfo(hole_number: 15, par: 5, handicap: 2, yardage: 540,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29719836045276, lng: -118.49707704037426),
                    mid:   HoleCoordinate(lat: 34.29862562768347, lng: -118.4975206106901),
                    green: HoleCoordinate(lat: 34.300369447761476, lng: -118.49737644195557)
                 )),

        HoleInfo(hole_number: 16, par: 4, handicap: 12, yardage: 410,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.293315838221176, lng: -118.49795781075954),
                    mid:   HoleCoordinate(lat: 34.29524313393822, lng: -118.49708441644906),
                    green: HoleCoordinate(lat: 34.297285055234056, lng: -118.49658753722906)
                 )),

        HoleInfo(hole_number: 17, par: 3, handicap: 14, yardage: 170,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29263831042486, lng: -118.49695734679698),
                    mid:   HoleCoordinate(lat: 34.29248014595399, lng: -118.49739119410515),
                    green: HoleCoordinate(lat: 34.29221478352841, lng: -118.49808655679225)
                 )),

        HoleInfo(hole_number: 18, par: 4, handicap: 16, yardage: 405,
                 locations: HoleLocations(
                    tee:   HoleCoordinate(lat: 34.29034531195915, lng: -118.4988422691822),
                    mid:   HoleCoordinate(lat: 34.291026182254065, lng: -118.49825419485569),
                    green: HoleCoordinate(lat: 34.29251670939578, lng: -118.49626131355764)
                 ))
    ]
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

private let kSavedRoundKey = "saved_active_round"

extension UserDefaults {

    func saveRound(_ round: CreateRoundResponse) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(round) {
            self.set(data, forKey: kSavedRoundKey)
        }
    }

    func loadRound() -> CreateRoundResponse? {
        guard let data = self.data(forKey: kSavedRoundKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(CreateRoundResponse.self, from: data)
    }

    func clearSavedRound() {
        self.removeObject(forKey: kSavedRoundKey)
    }
}



func finishRoundAPI(requestModel: FinishRoundRequest) async {
    
    guard let url = URL(string: "https://golfwaze.com/dashbord/new_api.php?action=finish_round") else {
        print("❌ Invalid URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let bodyData = try JSONEncoder().encode(requestModel)
        request.httpBody = bodyData
        
        print("📤 Request JSON:")
        print(String(data: bodyData, encoding: .utf8) ?? "")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("📥 Raw Response:")
        print(String(data: data, encoding: .utf8) ?? "")
        
        let decoded = try JSONDecoder().decode(FinishRoundResponse.self, from: data)
        
        print("✅ Decoded Response:")
        print(decoded)
        
    } catch {
        print("❌ API Error:", error.localizedDescription)
    }
}
