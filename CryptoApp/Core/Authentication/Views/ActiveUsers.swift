//
//  ActiveUsers.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 15/06/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct ActiveUsers: View {
    @EnvironmentObject var authMinor: AuthMinorModel
    @EnvironmentObject var viewModel : AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    let Screenheight = (UIScreen.main.bounds.height) - 290
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    Spacer()
                    
                    // Texts
                    VStack {
                        HStack {
                            Text("Welcome back!")
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        HStack {
                            Text("Please select your profile to continue.")
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 5)
                    
                    if !(authMinor.userCollection.isEmpty)
                    {
                        if authMinor.userCollection.count <= 3
                        {
                            renderUserCollection(authMinor.userCollection)
                        }
                        else {
                            ScrollView(showsIndicators: false)
                            {
                                renderUserCollection(authMinor.userCollection)
                            }
                            .frame(maxHeight: min(CGFloat(authMinor.userCollection.count * 85), Screenheight))
                        }
                    }
                    
                    
                    // Login to another account button
                    NavigationLink {
                        LoginView()
//                            .navigationBarBackButtonHidden()
                    }
                    label: {
                        HStack {
                            Text("Log in to another account")
                                .fontWeight(.semibold)
                            Image(systemName: "arrow.right")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-32, height: 58)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        )
                    }
                    .background(Color(.systemBlue).opacity(0.2))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                        
                    
                    Spacer()
                    
                    
                    // Create New User button
                    NavigationLink {
                        SignupView()
//                            .navigationBarBackButtonHidden()
                    }
                    label: {
                    HStack(spacing: 3)
                    {
                        Text("Create new account")
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .font(.system(size: 14))
                    .padding(.bottom, 15)
                }
                    
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading))
                
                
                // Delete Profile Button
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ManageActiveUsers())
                        {
                            Image(systemName: "gearshape")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .accentColor(.white)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 5)
                    .frame(width: Screenwidth)
                    Spacer()
                }
                   
            }
            .onAppear { Task { await authMinor.fetchActiveUsers() } }
            
        }
    }

    private func renderUserCollection( _ userCollection: [User?]) -> some View {
        ForEach(authMinor.userCollection, id: \.self)
        {
            user in
            Button {
                Task {
                    viewModel.currentUser = user
                    let index = authMinor.userCollection.firstIndex(of: user)
                    let pass = authMinor.userPassCollection[index ?? 0]
                    try await viewModel.signIn(withEmail: user?.email ?? "mail", password: pass)
                }
            }
            label:
            {
                HStack {
                    Text(user?.initials ?? "initials")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 56, height: 56)
                        .background(Color (.systemGray2))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.fullname ?? "fullname")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                        
                        Text(user?.email ?? "email")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.leading, 3)
                    Spacer()
                }
                .padding(.leading, 3)
                .padding(10)
                .frame(width: Screenwidth)
            }
            .background(.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.top, 3)
            
        }
        .padding(.bottom, userCollection.count < 4 ? 5 : 0)
    }
    
}



struct ActiveUsers_Previews: PreviewProvider {
    static var previews: some View {
        ActiveUsers()
    }
}
