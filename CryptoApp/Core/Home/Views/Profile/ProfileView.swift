//
//  ProfileView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showAlert = false
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteSavedAlert = false
    
    let Screenwidth = (UIScreen.main.bounds.width)
    
    var body: some View {
        if let user = viewModel.currentUser
        {
            NavigationView {
                    List {
                        Section {
                            HStack
                            {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 72, height: 72)
                                    .background(Color (.systemGray2))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        //                    .listRowBackground(colorScheme == .dark ? Color.gray.opacity(0.25) : Color.white)
                        .listRowBackground(colorScheme == .dark ? AnyView(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.white))
                        
                        
                        
                        Section("General") {
                            HStack {
                                SettingRowView(imageName: "gear", title: "App Version", tintColor: Color(.systemGray))
                                Spacer()
                                Text("3.1.0")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .listRowBackground(colorScheme == .dark ? AnyView(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.white))
                        
                        
                        Section("Content Control") {
                            Button {
                                self.showDeleteSavedAlert = true
                            }
                            label: {
                                SettingRowView(imageName:"heart.slash.circle.fill", title:"Delete Saved", tintColor: .red)
                            }
                            .alert(isPresented: $showDeleteSavedAlert) {
                                Alert(title: Text("Are you sure you want to delete your favourite coins?"),
                                message: Text("This action cannot be undone and you will lose all your saved coin data."),
                                      
                                // Handle OK button action
                                primaryButton: .default(Text("Delete Saved Coins"), action: {
                                viewModel.DeleteSaved()
                                }),
                                    // Handle cancel button action
                                    secondaryButton: .cancel(Text("Cancel"), action: {
                                }))
                            }
                        }
                        .listRowBackground(colorScheme == .dark ? AnyView(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.white))
                        
                        
                        Section("Account Actions") {
                            Button {
                                self.showAlert = true
                            }
                            label: {
                                SettingRowView(imageName:"arrow.left.circle.fill", title:"Sign Out", tintColor: .red)
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Sign out of your account?"),
                                      
                                      // Handle OK button action
                                      primaryButton: .default(Text("Sign Out"), action: {
                                    viewModel.signOut()
                                }),
                                      // Handle cancel button action
                                      secondaryButton: .cancel(Text("Cancel"), action: {
                                }))
                            }
                            
                            Button {
                                self.showDeleteAccountAlert = true
                            }
                            label: {
                                SettingRowView(imageName:"xmark.circle.fill", title:"Delete Account", tintColor: .red)
                            }
                            .alert(isPresented: $showDeleteAccountAlert) {
                                Alert(title: Text("Are you sure you want to delete your account?"),
                                    message: Text("This action is irreversible and you will lose all your data, including your saved information, history, and preferences."),
                                    primaryButton: .default(Text("Delete Account"), action: {
                                        print("DELETE ACCOUNT : OK button tapped")
                                    viewModel.deleteAccount()
                                    }),
                                      secondaryButton: .cancel(Text("Cancel"), action: {
                                    print("DELETE ACCOUNT : Cancel button tapped")
                                }))
                            }
                            
                        }
                        .listRowBackground(colorScheme == .dark ? AnyView(LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.white))
                    }
                    .navigationTitle("User details")

            }
        
        }

        
    }
 }

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
