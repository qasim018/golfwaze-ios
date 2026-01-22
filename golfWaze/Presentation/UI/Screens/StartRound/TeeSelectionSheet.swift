//
//  TeeSelectionSheet.swift
//  golfWaze
//
//  Created by Naveed Tahir on 21/01/2026.
//


import SwiftUI

struct TeeSelectionSheet: View {

    let tees: [TeeInfoResponse]
    @Binding var selectedTee: TeeInfoResponse?
    @Binding var showSheet: Bool

    var body: some View {
        VStack(spacing: 0) {

            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
                .padding(.bottom, 12)

            HStack {
                Text("Select a Tee")
                    .font(.system(size: 18, weight: .semibold))

                Spacer()

                Button {
                    withAnimation {
                        showSheet = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .ignoresSafeArea(edges: .bottom)   // 👈 ADD THIS

            VStack(spacing: 0) {
                ForEach(tees, id: \.teeName) { tee in
                    teeRow(tee: tee)
                }
            }
            .padding(.vertical, 20)
            EmptyView()
                .frame(height: 50)
           
            .ignoresSafeArea(edges: .bottom)   // 👈 ADD THIS
        }
//        .cornerRadius(26, corners: [.topLeft, .topRight])
        .background(
            Color.white
                .clipShape(
                    .rect(
                        topLeadingRadius: 22,
                        topTrailingRadius: 22
                    )
                )
        )
        .ignoresSafeArea(edges: .bottom)   // 👈 ADD THIS
    }

    func teeRow(tee: TeeInfoResponse) -> some View {
        Button {
            selectedTee = tee
            withAnimation {
                showSheet = false
            }
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tee.teeName ?? "")
                        .font(.system(size: 16))

                    Text("\(tee.teeYardage ?? 0) yds")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .frame(width: 22, height: 22)

                    if selectedTee?.teeName == tee.teeName {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}
