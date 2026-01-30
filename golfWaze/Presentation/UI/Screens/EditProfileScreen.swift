//
//  EditProfileScreen.swift
//  golfWaze
//
//  Created by Abdullah-Shahid  on 29/11/2025.
//

import SwiftUI

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

final class EditProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccess = false
    @Published var profileImageURL: String?
    @Published var showError: Bool = false
    
    func updateProfile(
        name: String,
        username: String,
        bio: String,
        gender: String,
        birthYear: String,
        country: String,
        mobile: String,
        handicap: String,
        image: UIImage?
    ) {
        guard let token = SessionManager.load()?.accessToken else {
            print("❌ Access token not found")
            return
        }
        
        isLoading = true
        errorMessage = nil
        isSuccess = false

        let url = URL(string: "https://golfwaze.com/dashbord/new_api.php?action=edit_profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func addField(_ name: String, _ value: String) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        // Add all fields
        addField("token", token)
        addField("name", name)
        addField("bio", bio)
        addField("gender", gender)
        addField("birth_year", birthYear)
        addField("country", country)
        addField("handicap", handicap)

        // Add image with correct JPEG format
        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.25) {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"profile_pic\"; filename=\"profile_pic.jpg\"\r\n")
            body.appendString("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.appendString("\r\n")
        } else {
            print("❌ Image data is nil or conversion failed.")
        }

        body.appendString("--\(boundary)--\r\n")
        request.httpBody = body

        // Debug: Print the HTTP Body
        if let bodyString = String(data: body, encoding: .utf8) {
            print("📧 HTTP Body:\n", bodyString)
        }

        // Add timeout
        request.timeoutInterval = 30

        // Make the API call
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }

            if let error = error {
                print("❌ API Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                }
                return
            }

            // Check HTTP status code
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status Code:", httpResponse.statusCode)
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Server error: \(httpResponse.statusCode)"
                        self?.showError = true
                    }
                    return
                }
            }

            // Ensure data is received
            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    self?.errorMessage = "No response from server"
                    self?.showError = true
                }
                return
            }

            // Debug: Print raw response
            if let jsonResponse = String(data: data, encoding: .utf8) {
                print("📦 RAW RESPONSE:\n", jsonResponse)
            }

            // Handle response
            do {
                let result = try JSONDecoder().decode(EditProfileResponse.self, from: data)
                print("✅ Decoded successfully:", result)

                DispatchQueue.main.async {
                    self?.profileImageURL = result.profile_image_url ?? ""
                    self?.isSuccess = true
                    NotificationCenter.default.post(name: .profileUpdated, object: nil)
                }
            } catch {
                print("❌ Decode error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to process response: \(error.localizedDescription)"
                    self?.showError = true
                }
            }
        }.resume()
    }
    
}



struct EditProfileScreen: View {
    @EnvironmentObject var coordinator: TabBarCoordinator
    let basicProfile: BasicProfile
    
    @StateObject private var vm = EditProfileViewModel()
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    // MARK: - State variables
    @State private var firstName: String
    @State private var username: String
    @State private var bio: String
    @State private var gender: String
    @State private var birthYear: String
    @State private var country: String
    @State private var mobile: String
    @State private var handicap: String
    

    init(basicProfile: BasicProfile) {
        self.basicProfile = basicProfile
        
        _firstName = State(initialValue: basicProfile.name)
        _username = State(initialValue: basicProfile.username)
        _bio = State(initialValue: basicProfile.bio)
        _gender = State(initialValue: basicProfile.gender)
        _birthYear = State(initialValue: basicProfile.birthdate)
        _country = State(initialValue: basicProfile.country)
        _mobile = State(initialValue: basicProfile.mobile)
        _handicap = State(initialValue: "\(basicProfile.handicap)")
       
        if let urlString = basicProfile.profileImage,
                 let url = URL(string: urlString) {
                  loadImage(from: url)
              }
        
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Fixed Header
            HStack(spacing: 12) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 18))
                }

                Text("Edit Profile")
                    .font(Font.customFont(.robotoMedium, .pt18))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color.white)

            Divider()

            // MARK: - Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    // MARK: - Profile Image
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            }
                            else if let urlString = vm.profileImageURL,
                                    let url = URL(string: urlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                    default:
                                        Image("course_image").resizable().scaledToFill()
                                    }
                                }
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                            }
                            else {
                                Image("course_image")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        Button(action: {
                            showImagePicker = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(ThemeManager.shared.primaryColor)
                                    .frame(width: 36, height: 36)

                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                            }
                        }
                        .offset(x: -7, y: -4)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                    Group {
                        profileField(title: "Name", text: $firstName)
                        profileField(title: "Username", text: $username)
                        profileField(title: "Handicap", text: $handicap)
                        profileField(title: "Gender", text: $gender)
                        profileField(title: "Country", text: $country)
                        profileField(title: "Bio", text: $bio)
                        profileField(title: "Birth Year", text: $birthYear)
//                        profileField(title: "Mobile", text: $mobile)
                    }

                    Spacer().frame(height: 80)
                }
                .padding(.horizontal, 20)
            }

            // MARK: - Sticky Bottom Button
            VStack {
                AppButton("Edit Profile", .primary) {
                    vm.updateProfile(
                        name: firstName,
                        username: username,
                        bio: bio,
                        gender: gender,
                        birthYear: birthYear,
                        country: country,
                        mobile: mobile,
                        handicap: handicap,
                        image: selectedImage
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .overlay {
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Updating...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
        }
        .onChange(of: vm.isSuccess) { success in
            if success {
                coordinator.pop()
            }
        }
        .onAppear {
                   if let profileImage = basicProfile.profileImage,
                      let urlString = profileImage as? String,
                      let url = URL(string: urlString) {
                       loadImage(from: url)
                   }
               }
    }

    // MARK: - Reusable Field
    @ViewBuilder
    func profileField(title: String, text: Binding<String>, placeholder: String = "", height: CGFloat = 50) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.customFont(.robotoSemiBold, .pt14))
                .foregroundColor(.black)

            TextField(placeholder, text: text)
                .padding()
                .frame(height: height)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .font(Font.customFont(.robotoRegular, .pt14))
        }
    }

    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    selectedImage = image
                }
            } else {
                DispatchQueue.main.async {
                    selectedImage = nil
                }
            }
        }.resume()
    }
    
}



//struct EditProfileScreen_Previews: PreviewProvider {
//
//    static var previews: some View {
////        Group {
//            EditProfileScreen()
////                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
////                .previewDisplayName("iPhone 15 Pro Max")
////            EditProfileScreen()
////                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
////                .previewDisplayName("iPhone SE (3rd generation)")
//            
////        }
//    }
//}

struct EditProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileScreen(
            basicProfile: BasicProfile(
                id: 1,
                name: "John Doe",
                username: "johndoe",
                profileImage: "https://example.com/profile.jpg",
                handicap: 12.5,
                mobile: "+1234567890",
                gender: "Male",
                bio: "Golf enthusiast",
                country: "USA",
                birthdate: "1990"
            )
        )
    }
}

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
