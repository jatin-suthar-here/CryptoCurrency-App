//
//  ManageActiveUsers.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 17/06/23.
//

import SwiftUI

struct ManageActiveUsers: View {
    
    @EnvironmentObject var authMinor: AuthMinorModel
    @Environment(\.presentationMode) var presentationMode
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    let Screenheight = (UIScreen.main.bounds.height) - 290
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if authMinor.userCollection.count <= 3
                { renderUserCollection(authMinor.userCollection) }
                else {
                    ScrollView(showsIndicators: false)
                    { renderUserCollection(authMinor.userCollection) }
                }
                
                Spacer()
            }
            .navigationBarTitle("Manage Profiles", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
                }, label: {
                Image(systemName: "chevron.backward")
                    .font(.subheadline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                })
                , trailing:
                    Menu {
                        Button(action: { authMinor.deleteAllProfiles() }, label: {
                            Label("Remove all profiles", systemImage: "trash")
                        })
                        
                        Button(action: {}, label: {
                            Label("Info", systemImage: "info.circle")
                        })
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .offset(x: -5)
                    }
                )
            .padding(.top, 10)
            
        }
    }
    
    private func renderUserCollection(_ userCollection: [User?]) -> some View {
        ForEach(authMinor.userCollection, id: \.self)
        {
            user in
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
                
                Button { authMinor.deleteProfile(user: user) {} }
                label : {
                    Circle()
                        .foregroundColor(Color(.red).opacity(0.2))
                        .overlay(
                            Image(systemName: "trash")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.6))
                        )
                        .frame(width: 45, height: 45)
                }
                .padding(.trailing, 5)
                    
            }
            .padding(.leading, 5)
            .padding(10)
            .frame(width: Screenwidth)
            .background(.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.top, 3)
        }
    }
    
}

struct ManageActiveUsers_Previews: PreviewProvider {
    static var previews: some View {
        ManageActiveUsers()
    }
}
