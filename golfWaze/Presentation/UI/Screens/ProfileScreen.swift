//
//  ProfileScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 30/11/2025.
//
import SwiftUI

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
}


// MARK: - Main Screen
struct ProfileScreen: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    @StateObject private var vm = ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 0) {
            // Navigation bar & header area
            HeaderArea(viewModel: vm) {
                presentationMode.wrappedValue.dismiss()
            } editAction: {
                // Edit profile tapped
                if let basic = vm.basicProfile {
                    coordinator.push(.editProfile(data: basic))
                }
            }

            ScrollView {
                VStack(spacing: 16) {
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
                        if let uiImage = UIImage(named: "profile_photo") {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            // fallback circle with system image
                            Image(systemName: "golfclub")
                                .resizable()
                                .scaledToFit()
                                .padding(12)
                                .foregroundColor(.white)
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                    .frame(width: 74, height: 74)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 2))

                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.name)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

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
