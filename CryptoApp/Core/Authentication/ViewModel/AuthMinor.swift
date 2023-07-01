//  AuthMinor.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 15/06/23.

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI


@MainActor
class AuthMinorModel: ObservableObject
{
    @Published var userCollection: [User?] = []
    @Published var userPassCollection: [String] = []
    
    init() {
        Task { await fetchActiveUsers() }
    }
    
    func fetchActiveUsers() async {
        print("--->>Fetching Active Users")
        guard let snapshot = try? await Firestore.firestore().collection("metaData").document("activeUsers").getDocument() else { return }
        let hello = snapshot.data()
        userCollection.removeAll() // Clear the existing data
        userPassCollection.removeAll() // Clear the existing password data
        if let activeUsersList = hello?["activeUsersList"] as? [String] {
            for userString in activeUsersList {
                let userComponents = userString.components(separatedBy: ",")
                let user = User(id: userComponents[0], fullname: userComponents[1], email: userComponents[2])
                userCollection.append(user)
                userPassCollection.append(userComponents[3])
            }
        } else {
            print("none")
        }
        print(">>>>>>>>>>>>>", self.userCollection)
    }
    
    func deleteProfile(user: User?, completion: @escaping () -> Void) {
        let index = userCollection.firstIndex(of: user)
        let fb = Firestore.firestore().collection("metaData").document("activeUsers")
        fb.getDocument {
            (document, error) in
            if let document = document, document.exists {
                var myArray = document.data()?["activeUsersList"] as? [String] ?? []

                let strr = String(describing: user?.id ?? "IdError") + "," + String(describing: user?.fullname ?? "NameError") + "," + String(describing: user?.email ?? "EmailError") + "," + String(describing: self.userPassCollection[index ?? 10])
                
                if myArray.contains(strr)
                {
                    let index = myArray.firstIndex(of: strr)
                    // If the element already exists in the array, remove it
                    myArray.remove(at: index ?? 0)
                }
                // Write the updated array back to the document
                fb.updateData(["activeUsersList": myArray]) { error in
                    if let error = error {
                        print("deleteProfile : Error updating document: \(error)")
                    } else {
                        self.userCollection.remove(at: index ?? 0)
                        self.userPassCollection.remove(at: index ?? 0)
//                        print("USER COLL (delete Profile) : ", self.userCollection)
//                        print("USER PASS COLL (delete Profile) : ", self.userPassCollection)
                        print("deleteProfile : Document successfully updated")
                    }
                    completion()
                }
            } else {
                print("deleteProfile : Document does not exist")
            }
        }
    }
    
    func deleteAllProfiles() {
        let fb = Firestore.firestore().collection("metaData").document("activeUsers")
        fb.getDocument {
            (document, error) in
            if let document = document, document.exists {
                var myArray = document.data()?["activeUsersList"] as? [String] ?? []
                
                myArray.removeAll()
                // Write the updated array back to the document
                fb.updateData(["activeUsersList": myArray]) { error in
                    if let error = error {
                        print("deleteAllProfiles : Error updating document: \(error)")
                    } else {
                        self.userCollection.removeAll()
                        self.userPassCollection.removeAll()
                        print("deleteAllProfiles : Document successfully updated")
                    }
                }
            } else {
                print("deleteAllProfiles : Document does not exist")
            }
        }
    }
    
    
}
