//
//  SwiftUIView.swift
//  golfWaze
//
//  Created by Naveed Tahir on 13/01/2026.
//
import SwiftUI

import SwiftUI

struct ScorecardView: View {

    let holes = Array(1...18)
    let par = [4,5,4,3,5,4,4,4,3, 4,5,4,3,5,4,4,4,3]
    let handicap = [7,18,5,1,6,10,4,2,9, 7,18,5,1,6,10,4,2,9]

    let jamesScores = [5,6,4,3,6,5,4,5,3, 5,6,4,3,6,5,4,5,3]
    let putts = [1,2,1,2,3,2,1,2,1, 1,2,1,2,3,2,1,2,1]
    let penalties = [0,0,1,0,0,1,0,0,0, 0,0,1,0,0,1,0,0,0]

    let greens = [true,false,true,true,false,true,true,false,true, true,false,true,true,false,true,true,false,true]
    let fairways = [false,true,false,true,true,false,true,true,false, false,true,false,true,true,false,true,true,false]

    @EnvironmentObject var coordinator: TabBarCoordinator
    @State private var showUpdateCard = false

    var body: some View {
        ZStack(alignment: .bottom){
            VStack(spacing: 0) {

                HeaderView {
                    coordinator.pop()
                }

                HStack(spacing: 0) {

                    // LEFT FIXED COLUMN
                    VStack(alignment: .leading, spacing: 0) {
                        fixedRow("Hole", height: 40, background: Color(red: 0.38, green: 0.47, blue: 0.58), foregroundColor: .white)
                        fixedDoubleRow("Par", secondtitle: "handicap", height: 70)

                        
                       
                        fixedRow("Putts", height: 40)
                        fixedRow("Greens", height: 50)
                        fixedRow("Fairways", height: 50)
                        fixedRow("Penalties", height: 40)
                    }
                    .frame(width: 70)
                    .background(Color.white)

                    // SCROLLING CONTENT
                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {

                            numberRow(holes.map { "\($0)" }, height: 40, isHeader: true)
                            doubleTextRow(par.map { "\($0)" }, sub: par.map { "\($0)" }, height: 70)
                           
                          
                            numberRow(putts.map { "\($0)" }, height: 40)
                            boolRow(greens)
                            boolRow(fairways)
                            numberRow(penalties.map { "\($0)" }, height: 40)
                        }
                    }

                    // RIGHT FIXED TOTALS
                    VStack(spacing: 0) {
                        totalCell("Total", height: 40, bold: true, color: .white, background: Color(red: 0.38, green: 0.47, blue: 0.58))
                        totalCell("72", height: 60, color: .red)
                        
                      
                        totalCell("72", height: 40, color: .red)
                        totalCell("", height: 50)
                        totalCell("", height: 50)
                        totalCell("4", height: 50, color: .red)
                    }
                    .frame(width: 60)
                    .background(Color.white)
                }

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            
            AppButton("Edit Score Card", .primary) {
                showUpdateCard = true
            }
            .padding()
        }
        .sheet(isPresented: $showUpdateCard) {
            HoleStatsView() // or UpdateCardScreen
                .presentationDetents([.large])
        }

        
    }

    // MARK: - Components

    func fixedRow(_ title: String, height: CGFloat, background: Color = .white, foregroundColor: Color = .black) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .frame(height: height)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 12)
            .background(background)
            .foregroundColor(foregroundColor)
    }

    func fixedDoubleRow(_ title: String, secondtitle: String, height: CGFloat, background: Color = .white, foregroundColor: Color = .black) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(secondtitle)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: height)
//        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 12)
        .background(background)
        .foregroundColor(foregroundColor)
    }


    func numberRow(_ values: [String], height: CGFloat, isHeader: Bool = false) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                Text(values[i])
                    .font(.system(size: isHeader ? 15 : 14, weight: isHeader ? .semibold : .regular))
                    .foregroundColor(isHeader ? .white : .black)
                    .frame(width: 40, height: height)
                    .background(isHeader ? Color(red: 0.38, green: 0.47, blue: 0.58) : Color.white)
            }
        }
    }

    func doubleTextRow(_ values: [String], sub: [String], height: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                VStack(spacing: 2) {
                    Text(values[i]).font(.system(size: 14, weight: .medium))
                    Text(sub[i]).font(.system(size: 14, weight: .medium))
                }
                .frame(width: 40, height: height)
                .background(Color.white)
            }
        }
    }

    func boolRow(_ values: [Bool]) -> some View {
        HStack(spacing: 0) {
            ForEach(values.indices, id: \.self) { i in
                ZStack {
                    Circle()
                        .fill(values[i] ? Color.green : Color.purple)
                        .frame(width: 26, height: 26)

                    Image(systemName: values[i] ? "checkmark" : "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .bold))
                }
                .frame(width: 40, height: 50)
                .background(Color.white)
            }
        }
    }

    func totalCell(_ text: String, height: CGFloat, bold: Bool = false, color: Color = .black, background: Color = .white) -> some View {
        Text(text)
            .font(.system(size: bold ? 15 : 14, weight: bold ? .semibold : .regular))
            .foregroundColor(color)
            .frame(height: height)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 8)
            .background(background)
    }
    
    struct HeaderView: View {
        var pop: (() -> Void)?
        
        var body: some View {
            HStack {
                Spacer()

                Button(action: {}) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }

}


struct ScorecardView_Previews: PreviewProvider {
    static var previews: some View {
        ScorecardView()
    }
}

