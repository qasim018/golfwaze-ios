//
//  CourseDesignerScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI
import SwiftUI

struct CourseDesignerScreen: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // MARK: - Back Button
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .medium))
            }
            .padding(.top, 8)

            // MARK: - Profile Row
            HStack(spacing: 16) {
                Image("course_image")  // replace with your asset
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                Text("Designer")
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)   // ⬅ FIXES SIDE SHIFT
        .padding(.leading, 20)                             // ⬅ Matches design margin
        .padding(.trailing, 20)
        .navigationBarHidden(true)
    }
}

struct CourseDesignerScreen_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            CourseDesignerScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
            CourseDesignerScreen()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE (3rd generation)")
            
        }
    }
}
