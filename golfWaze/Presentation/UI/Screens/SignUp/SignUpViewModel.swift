//
//  SignUpViewModel.swift
//  golfWaze
//
//  Created by Naveed Tahir on 05/01/2026.
//
import SwiftUI
@MainActor
class SignUpViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var signUpResponse: SignUpResponse?
    @Published var signupCompleted = false   // 👈 trigger navigation

    private let url = URL(string:
        "https://golfwaze.com/dashbord/new_api.php?action=signup"
    )!

    func signUp(
        name: String,
        username: String,
        email: String,
        password: String
    ) async {

        isLoading = true
        errorMessage = nil

        let body = SignUpRequest(
            name: name,
            email: email,
            username: username,
            password: password,
            device_id: UIDevice.current.identifierForVendor?.uuidString ?? "ios-device"
        )

        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)

            // 🔹 Log request body
            if let json = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 SIGNUP REQUEST BODY:\n\(json)")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            // 🔹 Log HTTP status
            if let http = response as? HTTPURLResponse {
                print("📡 STATUS CODE:", http.statusCode)
            }

            // 🔹 Log raw response JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📥 SIGNUP RAW RESPONSE:\n\(jsonString)")
            }

            // 🔹 Decode
            let decoded = try JSONDecoder().decode(SignUpResponse.self, from: data)
            self.signUpResponse = decoded

            guard decoded.success, let user = decoded.user else {
                errorMessage = decoded.message ?? "Signup failed"
                print("❌ SIGNUP API ERROR:", errorMessage ?? "Unknown error")
                isLoading = false
                return
            }

            let session = UserSession(
                id: user.id ?? 0,
                name: user.name,
                username: user.username,
                profileImage: user.profile_image,
                handicap: user.handicap,
                accessToken: decoded.access_token
            )

            SessionManager.save(session)
            signupCompleted = true

        } catch {
            print("🔥 SIGNUP ERROR:", error.localizedDescription)

            if let decodingError = error as? DecodingError {
                debugPrint("🧩 DECODING ERROR:", decodingError)
            }

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

}
