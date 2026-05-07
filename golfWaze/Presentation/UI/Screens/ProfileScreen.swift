//
//  ProfileScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 30/11/2025.
//
import SwiftUI
import UIKit

// MARK: - Color palette (adjust to match your design)
extension Color {
    static let navy = Color(red: 6/255, green: 45/255, blue: 73/255)        // deep blue header
    static let cardBackground = Color(red: 245/255, green: 247/255, blue: 249/255) // very light gray card
    static let softBlue = Color(red: 15/255, green: 47/255, blue: 71/255)   // dark navy used for text/buttons
}

// MARK: - View Model
final class ProfileViewModel: ObservableObject {
    
    @Published var name: String = "Chria Harley"
    @Published var handicap: String = "62.7"
    @Published var friendCount: Int = 1
    @Published var roundsCount: Int = 1
    @Published var golfBagCount: Int = 1

    @Published var avgScore: String = "-"
    @Published var parOrBetter: String = "-"

    @Published var driverYds: String = "- Yds"
    @Published var sevenIronYds: String = "- Yds"
    @Published var basicProfile: BasicProfile?
    @Published var isDeletingAccount = false
    @Published var actionErrorMessage: String?
    @Published var isGuestMode = SessionManager.isGuestSession

    init() {
        fetchProfile()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshProfile),
            name: .profileUpdated,
            object: nil
        )
    }
    
    @objc private func refreshProfile() {
        fetchProfile()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func fetchProfile() {
        if SessionManager.isGuestSession {
            applyGuestState()
            return
        }

        guard let token = SessionManager.load()?.accessToken else { return }

        let urlString = "https://golfwaze.com/dashbord/new_api.php?action=get_profile&token=\(token)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data else { return }

            if let json = String(data: data, encoding: .utf8) {
                print("PROFILE RAW JSON 👉\n\(json)")
            }

            do {
                let decoded = try JSONDecoder().decode(ProfileAPIResponse.self, from: data)

                DispatchQueue.main.async {
                    let basic = decoded.profile.basic
                    let stats = decoded.profile.stats
                    let course = decoded.profile.courseStats
                    let swing = decoded.profile.swingClubStats
                    self.basicProfile = decoded.profile.basic

                    self.name = basic.name
                    self.handicap = String(format: "%.1f", basic.handicap)

                    self.friendCount = stats.friends
                    self.roundsCount = stats.rounds
                    self.golfBagCount = stats.golfBagItems

                    self.avgScore = course.avgScore != nil ? String(format: "%.1f", course.avgScore!) : "-"
                    self.parOrBetter = course.parOrBetter != nil ? String(format: "%.1f", course.parOrBetter!) : "-"

                    self.driverYds = swing.driverDistance != nil ? "\(Int(swing.driverDistance!)) Yds" : "- Yds"
                    self.sevenIronYds = swing.iron7Distance != nil ? "\(Int(swing.iron7Distance!)) Yds" : "- Yds"
                }

            } catch {
                print("Profile decode error:", error)
            }

        }.resume()
    }

    func applyGuestState() {
        isGuestMode = true
        name = "Guest User"
        handicap = "-"
        friendCount = 0
        roundsCount = 0
        golfBagCount = 0
        avgScore = "-"
        parOrBetter = "-"
        driverYds = "- Yds"
        sevenIronYds = "- Yds"
        basicProfile = nil
    }

    func deleteAccount() async -> Bool {
        guard let session = SessionManager.load(),
              let token = session.accessToken,
              !token.isEmpty else {
            await MainActor.run {
                actionErrorMessage = "No active session found."
            }
            return false
        }

        await MainActor.run {
            isDeletingAccount = true
            actionErrorMessage = nil
        }

        let payload = DeleteAccountRequest(
            token: token,
            user_id: session.id,
            device_id: SessionManager.currentDeviceId
        )

        do {
            let response = try await performDeleteAccountRequest(payload: payload)

            await MainActor.run {
                isDeletingAccount = false
                if !response.success {
                    actionErrorMessage = response.message ?? "Account deletion failed."
                }
            }

            return response.success
        } catch {
            await MainActor.run {
                isDeletingAccount = false
                actionErrorMessage = error.localizedDescription
            }
            return false
        }
    }

    private func performDeleteAccountRequest(payload: DeleteAccountRequest) async throws -> DeleteAccountResponse {
        let candidates = try buildDeleteAccountRequests(payload: payload)
        var lastError: Error?

        for request in candidates {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)

                if let httpResponse = response as? HTTPURLResponse,
                   !(200...299).contains(httpResponse.statusCode) {
                    lastError = NSError(
                        domain: "ProfileDeleteAccount",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Delete account request failed with status \(httpResponse.statusCode)."]
                    )
                    continue
                }

                let decoded = try JSONDecoder().decode(DeleteAccountResponse.self, from: data)
                return decoded
            } catch {
                lastError = error
            }
        }

        throw lastError ?? NSError(
            domain: "ProfileDeleteAccount",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Unable to delete account."]
        )
    }

    private func buildDeleteAccountRequests(payload: DeleteAccountRequest) throws -> [URLRequest] {
        let baseURLString = "https://golfwaze.com/dashbord/new_api.php?action=delete_account"
        guard let baseURL = URL(string: baseURLString) else {
            throw NSError(
                domain: "ProfileDeleteAccount",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Invalid delete account URL."]
            )
        }

        var jsonRequest = URLRequest(url: baseURL)
        jsonRequest.httpMethod = "POST"
        jsonRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        jsonRequest.httpBody = try JSONEncoder().encode(payload)

        var components = URLComponents(string: baseURLString)
        components?.queryItems = [
            URLQueryItem(name: "action", value: "delete_account"),
            URLQueryItem(name: "token", value: payload.token),
            URLQueryItem(name: "user_id", value: String(payload.user_id)),
            URLQueryItem(name: "device_id", value: payload.device_id)
        ]

        var queryRequest = URLRequest(url: components?.url ?? baseURL)
        queryRequest.httpMethod = "POST"

        return [jsonRequest, queryRequest]
    }
}

struct DeleteAccountRequest: Codable {
    let token: String
    let user_id: Int
    let device_id: String
}

struct DeleteAccountResponse: Codable {
    let success: Bool
    let message: String?
}


// MARK: - Main Screen
struct ProfileScreen: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var coordinator: TabBarCoordinator
    @StateObject private var vm = ProfileViewModel()
    @State private var showLogoutConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var showGuestExitConfirmation = false

    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar & header area
            HeaderArea(viewModel: vm) {
                coordinator.moveToFirstTab()
            } editAction: {
                // Edit profile tapped
                if let basic = vm.basicProfile {
                    coordinator.push(.editProfile(data: basic))
                }
            }

            ScrollView {
                VStack(spacing: 16) {
                    if vm.isGuestMode {
                        guestModeCard
                    }

                    // Quick stats row inside rounded card
                    StatsRowCard(friendCount: vm.friendCount,
                                 roundsCount: vm.roundsCount,
                                 golfBagCount: vm.golfBagCount)

                    // Course and Round Stats card
                    StatsCard(title: "Course and Round Stats",
                              subtitle: "18 Holes , All Rounds") {
                        HStack(spacing: 16) {
                            SmallStatBox(title: "Avg Score", value: vm.avgScore)
                            SmallStatBox(title: "Par or better", value: vm.parOrBetter)
                        }
                        .padding(.horizontal, 4)
                    }

                    // Swing & Club Stats card
                    StatsCard(title: "Swing & Club Stats",
                              subtitle: "18 Holes , All Rounds") {
                        HStack(spacing: 16) {
                            SmallStatBox(title: "Driver", value: vm.driverYds)
                            SmallStatBox(title: "7i", value: vm.sevenIronYds)
                        }
                        .padding(.horizontal, 4)
                    }

                    // Row items (Tracked Shots, Activity Feed)
                    VStack(spacing: 12) {
                        NavigationRow(title: "Tracked Shots") {
                            // action
                        }

                        NavigationRow(title: "Activity Feed") {
                            // action
                        }

                        if vm.isGuestMode {
                            ActionRow(
                                title: "Log In",
                                color: .softBlue,
                                isLoading: false
                            ) {
                                showGuestExitConfirmation = true
                            }
                        } else {
                            ActionRow(
                                title: "Log Out",
                                color: .softBlue,
                                isLoading: false
                            ) {
                                showLogoutConfirmation = true
                            }

                            ActionRow(
                                title: "Delete Account",
                                color: .red,
                                isLoading: vm.isDeletingAccount
                            ) {
                                showDeleteConfirmation = true
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding(.top, 18)
                .padding(.horizontal, 18)
            }
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(UIColor.systemBackground))
        .confirmationDialog("Account actions", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
            Button("Log Out", role: .destructive) {
                handleLogout()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You will need to log in again to access your account.")
        }
        .confirmationDialog("Exit guest mode?", isPresented: $showGuestExitConfirmation, titleVisibility: .visible) {
            Button("Continue to Login") {
                exitGuestMode()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your guest session will end and you will return to the login flow.")
        }
        .confirmationDialog("Delete account?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive) {
                Task {
                    await handleDeleteAccount()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This removes the account and blocks login from this device.")
        }
        .alert("Account Error", isPresented: .constant(vm.actionErrorMessage != nil)) {
            Button("OK") {
                vm.actionErrorMessage = nil
            }
        } message: {
            Text(vm.actionErrorMessage ?? "")
        }
    }

    private func handleLogout() {
        SessionManager.clear()
        coordinator.popToRoot()
        appCoordinator.moveToAuth()
    }

    private func exitGuestMode() {
        SessionManager.clear()
        coordinator.popToRoot()
        appCoordinator.moveToAuth()
    }

    private func handleDeleteAccount() async {
        let deleted = await vm.deleteAccount()
        guard deleted else { return }

        SessionManager.clear()
        SessionManager.blockLoginOnCurrentDevice()
        coordinator.popToRoot()
        await MainActor.run {
            appCoordinator.moveToAuth()
        }
    }

    private var guestModeCard: some View {
        StatsCard(title: "Guest Mode", subtitle: "Browse-only access") {
            Text("You can explore courses in guest mode. Log in or create an account to start rounds, join the community, book tee times, and sync profile data.")
                .font(.system(size: 15))
                .foregroundColor(.softBlue.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Header Area
struct HeaderArea: View {
    @ObservedObject var viewModel: ProfileViewModel
    let backAction: () -> Void
    let editAction: () -> Void

    var body: some View {
        ZStack {
            // Navy header background with subtle curve
            Color.navy
                .frame(height: 200)
                .overlay(
                    RoundedCorners(tl: 0, tr: 0, bl: 22, br: 22)
                        .fill(Color.navy)
                )

            VStack {
                HStack {
                    Button(action: backAction) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(8)
                    }
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white.opacity(0.85))
                        .padding(8)
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)

                HStack(alignment: .center, spacing: 16) {
                    // Profile image
                    ZStack {
                        if let urlString = viewModel.basicProfile?.profileImage,
                           let url = URL(string: urlString) {

                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 74, height: 74)

                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()

                                case .failure:
                                    fallbackIcon

                                @unknown default:
                                    fallbackIcon
                                }
                            }

                        } else {
                            fallbackIcon
                        }
                    }
                    .frame(width: 74, height: 74)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 2))

                    

                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        if !viewModel.isGuestMode {
                            Button(action: editAction) {
                                Text("Edit Profile")
                                    .font(.system(size: 14, weight: .semibold))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.white.opacity(0.12))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    Spacer()

                    // Handicap card
                    HandicapBadge(value: viewModel.handicap)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
        }
    }
    var fallbackIcon: some View {
        Image(systemName: "golfclub")
            .resizable()
            .scaledToFit()
            .padding(12)
            .foregroundColor(.white)
            .background(Color.gray.opacity(0.3))
    }

}

// MARK: - Handicap Badge
struct HandicapBadge: View {
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            Text("HANDICAP")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
        }
        .frame(width: 86, height: 86)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.06), radius: 6, y: 4)
    }
}

// MARK: - Stats Row Card (Friends / Rounds / Golf Bag)
struct StatsRowCard: View {
    let friendCount: Int
    let roundsCount: Int
    let golfBagCount: Int

    var body: some View {
        HStack(spacing: 12) {
            StatItem(count: friendCount, title: "Friends")
            StatDivider()
            StatItem(count: roundsCount, title: "Rounds")
            StatDivider()
            StatItem(count: golfBagCount, title: "Golf Bag")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.02), radius: 2, y: 1)
    }

    @ViewBuilder
    func StatItem(count: Int, title: String) -> some View {
        VStack {
            Text("\(count)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.softBlue)
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.softBlue)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct StatDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.18))
            .frame(width: 1, height: 44)
    }
}

// MARK: - Stats Card (Generic reusable card with title/subtitle & content)
struct StatsCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: () -> Content

    init(title: String, subtitle: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.softBlue)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }

            content()
                .padding(.vertical, 8)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: Color.black.opacity(0.02), radius: 2, y: 1)
    }
}

// MARK: - SmallStatBox
struct SmallStatBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.softBlue)
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 76)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.02), radius: 2, y: 1)
    }
}

// MARK: - Navigation Row (simple arrow row)
struct NavigationRow: View {
    let title: String
    let action: () -> Void

    init(title: String, action: @escaping () -> Void = {}) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.softBlue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActionRow: View {
    let title: String
    let color: Color
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)

                Spacer()

                if isLoading {
                    ProgressView()
                        .tint(color)
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(color.opacity(0.7))
                }
            }
            .padding()
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLoading)
    }
}

// MARK: - RoundedCorners shape (for header bottom corner radius)
struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // make sure radii don't exceed bounds
        let tl = min(min(self.tl, h/2), w/2)
        let tr = min(min(self.tr, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}

// MARK: - Preview
struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScreen()
                .previewDevice("iPhone 12")
            ProfileScreen()
                .preferredColorScheme(.dark)
                .previewDevice("iPhone 12")
        }
    }
}

extension Notification.Name {
    static let profileUpdated = Notification.Name("profileUpdated")
}
