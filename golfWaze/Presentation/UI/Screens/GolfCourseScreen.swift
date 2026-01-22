//
//  GolfCourseScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//
import SwiftUI

struct GolfCourseScreen: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
     @StateObject private var viewModel: GolfCourseDetailVM
    @State private var showPlayPopup = false
    @State private var showDeletePopup = false
     let course: CourseDetail
    //courseID = 15733 knollwood
     init(course: CourseDetail) {
         self.course = course
         _viewModel = StateObject(
            wrappedValue: GolfCourseDetailVM(courseID: course.id ?? "")
         )
     }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header Image with Overlay
                headerSection
                
                // MARK: - Preview / Change Buttons
//                HStack(spacing: 16) {
//                    whiteButton("Preview Course")
//                    whiteButton("Change Course")
//                }
//                .padding(.horizontal)
                
                // MARK: - Start Round Block
                VStack(alignment: .leading) {
                    Text(viewModel.golfCourseName)
                        .font(Font.customFont(.robotoSemiBold, .pt14))
                        .foregroundColor(.black)
                        .padding(.vertical, 5)
                    HStack {
                        if let _ = UserDefaults.standard.loadRound(), !viewModel.deleteSuccess {
                            Button(action: {
                                  showDeletePopup = true
                              }) {
                                  Image(systemName: "trash")
                                      .foregroundColor(.red)
                                      .frame(width: 44, height: 44)
                                      .background(Color.white)
                                      .cornerRadius(12)
                                      .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                              }
                        }
                        
                        Button(action: {
                            if let round = UserDefaults.standard.loadRound() {
                                coordinator.push(.golfHole(course: viewModel.courseDetail ?? course, response: round))
                            }
                            else{
                                showPlayPopup = true
                            }
                        }) {
                            Text("Start a round")
                                .font(Font.customFont(.robotoSemiBold, .pt14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#001F3F"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
                .background(Color(hex: "#F5F7F9"))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 8)
                .padding(.horizontal, 16)
                
                // MARK: - Tips / Stats / History
//                HStack(spacing: 16) {
//                    greyPillButton("Course Tips")
//                    greyPillButton("Course Stats")
//                    greyPillButton("Round History")
//                }
//                .padding(.horizontal, 16)
                
                // MARK: - Long Buttons
                VStack(spacing: 16) {
//                    longGreyButton("Schedule Future Round")
                    longGreyButton("Add Past Round")
                }
                .padding(.horizontal, 20)
                
                Spacer().frame(height: 40)
            }
        }
        .background(Color(.white))
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showPlayPopup) {
            PlayTimePopup(
                onNow: {
                    showPlayPopup = false
                    coordinator.push(.createRound(course: viewModel.courseDetail ?? course))
                },
                onFuture: {
                    showPlayPopup = false
                },
                onDismiss: {
                    showPlayPopup = false
                }
            )
            .presentationDetents([.height(216)])
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $showDeletePopup) {
            DeleteRoundPopup {
                if let round = UserDefaults.standard.loadRound() {
                    viewModel.deleteRound(roundId: round.round_id ?? "")
                }
            } onDismiss: {
                showDeletePopup = false
            }
            .presentationDetents([.height(160)])
        }
        .onChange(of: viewModel.deleteSuccess) { success in
            if success {
                viewModel.deleteSuccess = false
                UserDefaults.standard.clearSavedRound()
                showDeletePopup = false
            }
        }

    }
    
    
        
    private var headerSection: some View {
        ZStack(alignment: .bottomLeading) {
            Image("bg_1") // Replace with real asset
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(viewModel.golfCourseName)
                    .font(Font.customFont(.robotoSemiBold, .pt14))
                    .foregroundColor(.white)
                
                Text(viewModel.address)
                    .font(Font.customFont(.robotoMedium, .pt12))
                    .foregroundColor(.white.opacity(0.9))
                
                HStack(spacing: 10) {
                    Text("\(viewModel.length)")
                        .font(Font.customFont(.robotoMedium, .pt11))
                    Circle().frame(width: 4, height: 4)
                    
//                    HStack(spacing: 4) {
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                        Text(viewModel)
//                            .font(Font.customFont(.robotoMedium, .pt11))
//                    }
                }
                .font(Font.customFont(.robotoRegular, .pt14))
                .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
    
    /// White rounded button
    @ViewBuilder
    private func whiteButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoSemiBold, .pt12))
            .foregroundStyle(Color(hex: "#1A1F2F"))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#F5F7F9"))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    /// Small gray pill button
    @ViewBuilder
    private func greyPillButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoBold, .pt12))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#F5F7F9"))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4)
    }
    
    /// Large long gray button
    @ViewBuilder
    private func longGreyButton(_ title: String) -> some View {
        Text(title)
            .font(Font.customFont(.robotoBold, .pt14))
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#00213D").opacity(0.15))
            .cornerRadius(12)
            .foregroundColor(Color(hex: "#001F3F"))
    }
}
struct GolfCourseScreen_Previews: PreviewProvider {
    static var previews: some View {
//        GolfCourseScreen(courseID: "19433")
    }
}


struct DeleteRoundPopup: View {
    var deleteNow: () -> Void
    var onDismiss: () -> Void
    
    @State private var isDeleting = false

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                VStack(spacing: 18) {
                    Text("End Your Round")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundColor(Color(hex: "#1A1F2F"))
                        .padding(.top, 2)

                    // DELETE BUTTON
                    Button {
                        isDeleting = true
                        deleteNow()
                    } label: {
                        ZStack {
                            if isDeleting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            } else {
                                Text("Delete Round")
                                    .font(Font.customFont(.robotoSemiBold, .pt14))
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(14)
                    }
                    .disabled(isDeleting)

                    // CANCEL BUTTON
                    Button(action: onDismiss) {
                        Text("Not Now")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.gray.opacity(0.12))
                            .foregroundColor(Color.black)
                            .cornerRadius(14)
                    }
                    .disabled(isDeleting)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(
                            .rect(
                                topLeadingRadius: 22,
                                topTrailingRadius: 22
                            )
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.spring(), value: true)
    }
}

struct PlayTimePopup: View {
    var onNow: () -> Void
    var onFuture: () -> Void
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
//            
//            // Dimmed Background
//            Color.black.opacity(0.45)
//                .ignoresSafeArea()
//                .onTapGesture { onDismiss() }
//            
            VStack {
                Spacer()   // pushes popup to bottom
                
                VStack(spacing: 18) {
                    
                    Image(systemName: "flag.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#001F3F"))
                    
                    Text("When do you want to play?")
                        .font(Font.customFont(.robotoSemiBold, .pt16))
                        .foregroundColor(Color(hex: "#1A1F2F"))
                        .padding(.top, 2)
                    
                    // NOW Button
                    Button(action: onNow) {
                        Text("Now")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#001F3F"))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                    
                    // FUTURE Button
                    Button(action: onFuture) {
                        Text("Future")
                            .font(Font.customFont(.robotoSemiBold, .pt14))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.gray.opacity(0.12))
                            .foregroundColor(Color(hex: "#1A1F2F"))
                            .cornerRadius(14)
                    }
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(
                    Color.white
                        .clipShape(
                            .rect(
                                topLeadingRadius: 22,
                                topTrailingRadius: 22
                            )
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .animation(.spring(), value: true)
    }
}

