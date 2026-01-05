//
//  ScheduleEventDetailsScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

struct ScheduleEventDetailsScreen: View {

    var body: some View {
        VStack(spacing: 20) {

            // Top Bar
            topBar()

            // Main Card
            mainCard()

            Spacer()

            bottomStatusButton()
        }
        .padding(.horizontal)
        .background(Color.white)
    }

    // MARK: - Top Bar
    @ViewBuilder
    private func topBar() -> some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "eye")
                .font(.system(size: 22))
                .foregroundColor(.black)

            Button(action: {}) {
                Image(systemName: "trash")
                    .font(.system(size: 22))
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 16)
    }

    // MARK: - Main Card
    @ViewBuilder
    private func mainCard() -> some View {
        VStack(alignment: .leading, spacing: 24) {

            // Course Selected Section
            courseSelectedSection()

            Divider()

            // Group Section
            myGroupSection()

        }
        .padding(20)
        .background(Color(hex: "#F5F7F9"))
        .cornerRadius(12)
    }

    // MARK: - Course Selected
    @ViewBuilder
    private func courseSelectedSection() -> some View {
        HStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Course Selected")
                    .font(Font.customFont(.robotoRegular, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))

                Text("Avon Fields Golf Course")
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F"))

                Text("(1-9) + (10-18)")
                    .font(Font.customFont(.robotoMedium, .pt14))
                    .foregroundStyle(Color(hex: "#1A1F2F"))

                // Timings label
                Text("Timings")
                    .font(Font.customFont(.robotoRegular, .pt12))
                    .foregroundStyle(Color(hex: "#1A1F2F"))
                    .padding(.top, 12)

                // Date + Time Buttons
                HStack(spacing: 16) {
                    timingBox("11/15/2025")
                    timingBox("4:10 PM")
                }
            }

            Spacer()

            changeButton()
        }
    }

    // MARK: - Timing Box
    @ViewBuilder
    private func timingBox(_ text: String) -> some View {
        Text(text)
            .font(Font.customFont(.robotoBold, .pt14))
            .foregroundStyle(Color(hex: "#1A1F2F"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.white)
            .cornerRadius(18)
    }

    // MARK: - Change Button
    @ViewBuilder
    private func changeButton() -> some View {
        Button(action: {}) {
            Text("Change")
                .font(Font.customFont(.robotoBold, .pt14))
                .foregroundColor(Color(hex: "#001F3F"))
                .padding(.vertical, 14)
                .padding(.horizontal, 22)
                .background(Color(hex: "#DCE2E8"))
                .cornerRadius(12)
        }
    }

    // MARK: - My Group Section
    @ViewBuilder
    private func myGroupSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("My Group")
                .font(Font.customFont(.robotoRegular, .pt12))
                .foregroundStyle(Color(hex: "#1A1F2F"))

            HStack(spacing: 28) {
                groupItem(image: "profile_placeholder", name: "My Group")
                groupItem(image: "profile_placeholder", name: "Carlcare h")
                addPlayerButton()
            }
        }
    }

    // MARK: - Group Player Item
    @ViewBuilder
    private func groupItem(image: String, name: String) -> some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            Text(name)
                .font(Font.customFont(.robotoRegular, .pt12))
                .foregroundColor(Color(hex: "#1A1F2F"))
        }
    }

    // MARK: - Add Player Button
    @ViewBuilder
    private func addPlayerButton() -> some View {
        VStack(spacing: 8) {
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white)
//                        .stroke(Color(hex: "#001F3F"), lineWidth: 2)
                        .frame(width: 60, height: 60)

                    Image(systemName: "plus")
                        .font(Font.customFont(.robotoRegular, .pt12))
                        .foregroundColor(Color(hex: "#1A1F2F"))
                }
            }

            Text("Add Player")
                .font(Font.customFont(.robotoRegular, .pt12))
                .foregroundColor(Color(hex: "#1A1F2F"))
        }
    }

    // MARK: - Bottom Status Button
    @ViewBuilder
    private func bottomStatusButton() -> some View {
        Text("Waiting for the Event")
            .font(Font.customFont(.robotoBold, .pt14))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#001F3F"))
            .cornerRadius(12)
            .padding(.bottom, 20)
    }
}

struct ScheduleEventDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleEventDetailsScreen()
    }
}
