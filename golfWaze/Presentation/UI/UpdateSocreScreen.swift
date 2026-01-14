//
//  UpdateSocreScreen.swift
//  golfWaze
//
//  Created by Naveed Tahir on 14/01/2026.
//

import SwiftUI

struct HoleStatsModel {
    var score: Int?
    var putts: Int?
    var fairwayHit: Bool?
    var gir: Bool?
    var chipShots: Int?
    var sandShots: Int?
    var penalties: Int?
}

struct HoleStatsView: View {
    
    @State private var model = HoleStatsModel(
        score: 3,
        putts: 1,
        fairwayHit: true,
        gir: true,
        chipShots: 1,
        sandShots: 0,
        penalties: 0
    )
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // Header
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Text("Finish hole")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                VStack(spacing: 20) {
                    
                    CardSection(title: "Score") {
                        scoreGrid(values: [2,3,4,5,6,7,8,9,10], selection: $model.score)
                    }
                    
                    CardSection(title: "Putts") {
                        row(values: [2,1,2,3,4], selection: $model.putts)
                    }
                    
                    CardSection(title: "Fairway Hit") {
                        boolRow(selection: $model.fairwayHit)
                    }
                    
                    CardSection(title: "Greens in Regulation") {
                        boolRow(selection: $model.gir)
                    }
                    
                    CardSection(title: "Chip Shots") {
                        row(values: [0,1,2,3,4], selection: $model.chipShots)
                    }
                    
                    CardSection(title: "Greenside Sand Shots") {
                        row(values: [0,1,2,3,4], selection: $model.sandShots)
                    }
                    
                    CardSection(title: "Penalties") {
                        row(values: [0,1,2,3,4], selection: $model.penalties)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemGray6))
    }
    
    // MARK: - Components
    
    func scoreGrid(values: [Int], selection: Binding<Int?>) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach([2,3,4], id: \.self) { val in
                    ScoreChip(
                        title: "\(val)",
                        isSelected: selection.wrappedValue == val,
                        isCircle: val <= 4
                    )
                    .onTapGesture {
                        selection.wrappedValue = val
                    }
                }
            }
            
            HStack(spacing: 12) {
                ForEach([5,6,7], id: \.self) { val in
                    ScoreChip(
                        title: "\(val)",
                        isSelected: selection.wrappedValue == val,
                        isCircle: false
                    )
                    .onTapGesture {
                        selection.wrappedValue = val
                    }
                }
            }
            
            HStack(spacing: 12) {
                ForEach([8,9,10], id: \.self) { val in
                    ScoreChip(
                        title: "\(val)",
                        isSelected: selection.wrappedValue == val,
                        isCircle: false
                    )
                    .onTapGesture {
                        selection.wrappedValue = val
                    }
                }
            }
        }
    }
    
    func row(values: [Int], selection: Binding<Int?>) -> some View {
        HStack(spacing: 12) {
            ForEach(values, id: \.self) { val in
                SelectionChip(
                    title: "\(val)",
                    isSelected: selection.wrappedValue == val
                )
                .onTapGesture {
                    selection.wrappedValue = val
                }
            }
        }
    }
    
    func boolRow(selection: Binding<Bool?>) -> some View {
        HStack(spacing: 16) {
            BoolChip(icon: "checkmark", isSelected: selection.wrappedValue == true)
                .onTapGesture { selection.wrappedValue = true }
            
            Spacer()
            
            BoolChip(icon: "xmark", isSelected: selection.wrappedValue == false)
                .onTapGesture { selection.wrappedValue = false }
        }
    }
}

struct CardSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ScoreChip: View {
    let title: String
    let isSelected: Bool
    let isCircle: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue.opacity(0.16) : Color(hex: "#F5F7F9"))
                .frame(height: 64)
            
            if isCircle {
                Circle()
                    .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 44, height: 44)
                
                if Int(title) == 4 {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                        .frame(width: 36, height: 36)
                }
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                    .frame(width: 36, height: 36)
                
                if Int(title) ?? 0 >= 7 {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color.gray.opacity(0.6), lineWidth: 1)
                        .frame(width: 44, height: 44)
                }
            }
            
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

struct SelectionChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(isSelected ? Color.blue.opacity(0.16) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(8)
    }
}

struct BoolChip: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.16) : Color.white)
                .frame(width: 160, height: 52)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    HoleStatsView()
}
