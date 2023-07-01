//
//  AuthViewModel.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 06/05/23.
//

import Foundation
import Firebase
// for encoding/decoding
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

protocol AuthenticationFormProtocol
{
    var formIsValid: Bool { get }
}

// Synchronous : code is executed in a blocking manner, meaning that the program waits for the current operation to finish before executing the next one. Synchronous code is useful when it's important to execute operations in a specific order.

// Asynchronous : code, on the other hand, allows the program to continue executing while the current operation is still in progress. Asynchronous code is useful when the operation takes a long time to complete, such as network calls or disk I/O, or when it's important to keep the user interface responsive.

@MainActor
// The @MainActor attribute can be used to mark actor methods and properties that must be accessed or modified only on the main thread.
class AuthViewModel: ObservableObject
{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    var activeUserString: String = ""
    var authMinorModel = AuthMinorModel()
    
    init()
    {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    // making authMinorModel Call By Referance, so that any changes in userCollection will reflect to the original one.
    var userCollectionReference: Binding<[User?]>
    {
        return Binding<[User?]>(
            get: { self.authMinorModel.userCollection },
            set: { self.authMinorModel.userCollection = $0 }
        )
    }
    
    func signIn(withEmail email: String, password: String) async throws
    {
        do {
            print("signing in")
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let strr = String(describing: uid) + "," + String(describing: self.currentUser?.fullname ?? "NameError") + "," + String(describing: email) + "," + String(describing: password)
            createActiveUser(userString: strr)
        } catch {
            print("DEBUG : Failed to sign in user with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async
    {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("Result : ", result)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let strr = String(describing: uid) + "," + String(describing: self.currentUser?.fullname ?? "NameError") + "," + String(describing: email) + "," + String(describing: password)
            createActiveUser(userString: strr)
        } catch {
            print("Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut()
    {
        print("signing out")
        do {
            try Auth.auth().signOut()
            // this will wipes out the user session and takes us back to the login screen
            self.userSession = nil
            // contentView is dependent on the userSession.
            self.currentUser = nil
        }
        catch { print("DEBUG : Failed to sign out user with error \(error.localizedDescription)") }
    }
    
    func deleteAccount()
    {
        print("deleting account...")
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            print("USER ID : ", userId)
            
            let userObj = User(id: userId, fullname: currentUser?.fullname ?? "NameError", email: currentUser?.email ?? "EmailError")
            
            // -------------------
            let index = authMinorModel.userCollection.firstIndex(of: userObj)
            let fbb = Firestore.firestore().collection("metaData").document("activeUsers")
            fbb.getDocument {
                (document, error) in
                if let document = document, document.exists {
                    var myArray = document.data()?["activeUsersList"] as? [String] ?? []
                    let strUser = String(describing: userObj.id ) + "," + String(describing: userObj.fullname ) + "," + String(describing: userObj.email ) + "," + String(describing: self.authMinorModel.userPassCollection[index ?? 0])
                    if (myArray.contains(strUser))
                    {
                        let ind = myArray.firstIndex(of: strUser)
                        myArray.remove(at: ind ?? 0)
                        // Write the updated array back to the document
                        fbb.updateData(["activeUsersList": myArray]) { error in
                            if let error = error {
                                print("createActiveUser : Error updating document: \(error)")
                            }
                            else { print("createActiveUser : Document successfully updated")
                            }
                        }
                    }
                    Task {
                        self.authMinorModel.userCollection.remove(at: index ?? 10)
                        self.authMinorModel.userPassCollection.remove(at: index ?? 10)
                        await self.authMinorModel.fetchActiveUsers() // Fetch updated user data
                        print("AFTER COLL : ", self.authMinorModel.userCollection)
                        
                        let rf = Firestore.firestore().collection("users").document(userId)
                        self.userSession = nil
                        self.currentUser = nil
                        try await rf.delete()
                        user.delete { error in
                            if let error = error { print("Error deleting user: \(error.localizedDescription)") }
                            else { print("User account deleted successfully.") }
                        }
                    }
                    
                } else { print("createActiveUser : Document does not exist") }
            }
        }
    }
    
    func fetchUser() async
    {
        print("fetching user")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        // we have a struct User with some keys...this '.data(as: )' will map the property automatically according to the User's keys.
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG : Current user is \(String(describing: self.currentUser))")
    }
    
    func createActiveUser(userString: String)
    {
        let fb = Firestore.firestore().collection("metaData").document("activeUsers")
        fb.getDocument {
            (document, error) in
            if let document = document, document.exists {
                var myArray = document.data()?["activeUsersList"] as? [String] ?? []
                
                if !(myArray.contains(userString))
                {
                    myArray.append(userString)
                    // Write the updated array back to the document
                    fb.updateData(["activeUsersList": myArray]) { error in
                        if let error = error {
                            print("createActiveUser : Error updating document: \(error)")
                        }
                        else { print("createActiveUser : Document successfully updated") }
                    }
                }
                Task {
                    await self.authMinorModel.fetchActiveUsers()
                }
                
            } else { print("createActiveUser : Document does not exist") }
        }
    }
    
    func checkUserExists(email: String, password: String) async -> Bool
    {
        var userCheck = false
        do {
            // withCheckedThrowingContinuation : allows to write asynchronous code in synchronous style
            // we are using the
            userCheck = try await withCheckedThrowingContinuation { continuation in
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        print(" >>> Error in Signing In user while [CheckUserExist]: \(error.localizedDescription)")
                        continuation.resume(returning: false)
                    } else {
                        guard let uid = authResult?.user.uid else { continuation.resume(returning: false)
                            return }
                        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
                            if let error = error {
                                print("Error getting user details from the collection : \(error.localizedDescription)")
                                continuation.resume(returning: false)
                            } else if snapshot?.exists ?? false {
                                userCheck = true
                                print("User already exists")
                                continuation.resume(returning: userCheck)
                            } else {
                                userCheck = false
                                print("User does not exist")
                                continuation.resume(returning: userCheck)
                            }
                        }
                        self.signOut()
                    }
                }
            }
        } catch {
            print("DEBUG : Failed to check if user exists with error \(error.localizedDescription)")
            return false
        }
        return userCheck
    }
    
    func addToFavourite(coinName: String)
    {
        print("Adding to Favourites...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument {
            (document, error) in
            if let document = document, document.exists {
                var myArray = document.data()?["favourites"] as? [String] ?? []
                
                if myArray.contains(coinName)
                {
                    let index = myArray.firstIndex(of: coinName)
                    // If the element already exists in the array, remove it
                    myArray.remove(at: index ?? 0)
                } else {
                    // Otherwise, append the new element to the array
                    myArray.append(coinName)
                }
                
                // Write the updated array back to the document
                fb.updateData(["favourites": myArray]) { error in
                    if let error = error {
                        print("AddTOFavourites : Error updating document: \(error)")
                    } else {
                        print("AddTOFavourites : Document successfully updated")
                    }
                }
            } else {
                print("AddTOFavourites : Document does not exist")
            }
        }
    }
    
    func CheckIsFavourite(coinName: String, completion: @escaping (Bool) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else { completion(false); return }

        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                let myArray = document.data()?["favourites"] as? [String] ?? []

                if myArray.contains(coinName) {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("CheckIsFavourite : Document does not exist")
                completion(false)
            }
        }
    }
    
    func ListFavourites(isReversed: Bool, completion: @escaping ([String]) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else { completion([""]); return }

        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                let myArray = document.data()?["favourites"] as? [String] ?? []
                
                // filter selected is "latest"
                if isReversed {
                    completion(myArray.reversed())
                }
                else
                {
                    completion(myArray)
                }
            } else {
                print("CheckIsFavourite : Document does not exist")
            }
        }
    }
    
    func DeleteSaved()
    {
        print("Deleting Saved Coins...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument {
            (document, error) in
            if let document = document, document.exists {
                var myArray = document.data()?["favourites"] as? [String] ?? []
                
                // append the empty element to the array
                myArray.removeAll()
                
                // Write the updated array back to the document
                fb.updateData(["favourites": myArray]) { error in
                    if let error = error {
                        print("DELETE_SAVED : Error updating document: \(error)")
                    } else {
                        print("DELETE_SAVED : Document successfully updated")
                    }
                }
            } else {
                print("DELETE_SAVED : Document does not exist")
            }
        }
    }
    
    func getBalance(completion: @escaping (String?) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(nil)
        }
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                let balance = document.data()?["balance"] as? String
//                print("GET_BALANCE : ", balance)
                completion(balance)
            } else {
                completion(nil)
            }
        }
    }
    
    func buyCoin(coinName: String, coinPrice: Double, coinQty: String)
    {
        print("Buying Coin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                var myMap = document.data()?["buy"] as? [String: String] ?? [:]
                var myMapQty = document.data()?["qty"] as? [String: String] ?? [:]
                let balance = document.data()?["balance"] as? String
                
                if myMap[coinName] != nil {
                    // If the coin already exists in the map, remove it
                    print("Buy Coin Already exists.....")
                } else {
                    // Otherwise, add the new coin with its price to the map
                    myMap[coinName] = String(describing: coinPrice)
                }
                
                if myMapQty[coinName] != nil {
                    // If the coin already exists in the map, increase by current qty
                    let currqty = Int(myMapQty[coinName] ?? "aa") ?? 0
                    myMapQty[coinName] = String(describing: currqty + (Int(coinQty) ?? 0))
                } else {
                    // Otherwise, add the new coin with its price to the map
                    myMapQty[coinName] = String(describing: coinQty)
                }
                
                var bal: String?
                
                let coinQtyDouble = Double(coinQty) ?? 0.0
                let balanceDouble = Double(balance ?? "errror value") ?? 0.0
                let newBalance = balanceDouble - (coinPrice * coinQtyDouble)
                bal = String(format: "%.2f", newBalance)
                
                // Write the updated map back to the document
                fb.updateData(["qty": myMapQty]) { error in
                    if let error = error {
                        print("buyCoin: QTY > Error updating document: \(error)")
                    } else {
                        print("buyCoin: Document successfully updated")
                    }
                }
                // Update the Qty list
                fb.updateData(["buy": myMap]) { error in
                    if let error = error {
                        print("buyCoin: BUY > Error updating document: \(error)")
                    } else {
                        print("buyCoin: Document successfully updated")
                    }
                }
                // Update the balance
                fb.updateData(["balance": bal ?? "balanceError"])
                {   error in
                    if let error = error {
                        print("buyCoin: BALANCE > Error updating balance: \(error)")
                    } else {
                        print("buyCoin: Balance successfully updated")
                    }
                }
                    
            } else {
                print("buyCoin: Document does not exist")
            }
        }
    }

    func getAvailableQty(coinName: String, completion: @escaping (String?) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(nil)
        }
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                let qtyMap = document.data()?["qty"] as? [String: String]
                let coinQty = qtyMap?[coinName]
                print("AVAILABLE QTY iss : ", coinQty as Any)
                completion(coinQty)
            } else {
                completion(nil)
            }
        }
    }

    func sellCoin(coinName: String, coinPrice: Double, coinQty: String)
    {
        print("Selling Coin")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let fb = Firestore.firestore().collection("users").document(uid)
        fb.getDocument { (document, error) in
            if let document = document, document.exists {
                var myMap = document.data()?["sell"] as? [String: [String]] ?? [:]
                var myMapQty = document.data()?["qty"] as? [String: String] ?? [:]
                var myMapBuy = document.data()?["buy"] as? [String: String] ?? [:]
                let balance = document.data()?["balance"] as? String
                
                // sell
                if myMap[coinName] != nil {
                    // [ oldPrice, newPrice, Qty, ......., oldPrice, newPrice, Qty, ... ]
                    myMap[coinName]?.append(contentsOf: [myMapBuy[coinName] ?? "valueError", String(describing: coinPrice), coinQty])
                }
                else {
                    myMap[coinName] = [myMapBuy[coinName] ?? "valueError", String(describing: coinPrice), coinQty]
                }
                
                // buy & qty
                let prevQtyValue  = Int(myMapQty[coinName] ?? "bb") ?? 0
                if (prevQtyValue - (Int(coinQty) ?? 0)) == 0
                {
                    myMapQty.removeValue(forKey: coinName)
                    myMapBuy.removeValue(forKey: coinName)
                }
                else
                {
                    myMapQty[coinName] = String(describing: prevQtyValue - (Int(coinQty) ?? 0))
                }
                
                // balance
                var bal: String?
                let coinQtyDouble = Double(coinQty) ?? 0.0
                let balanceDouble = Double(balance ?? "errror value") ?? 0.0
                let newBalance = balanceDouble + (coinPrice * coinQtyDouble)
                bal = String(format: "%.2f", newBalance)
                
                
                // Write the updated buy map back to the document
                fb.updateData(["qty": myMapQty]) { error in
                    if let error = error {
                        print("SellCoin: QTY > Error updating document: \(error)")
                    } else {
                        print("SellCoin: Document successfully updated")
                    }
                }
                
                // Update the sell list
                fb.updateData(["sell": myMap]) { error in
                    if let error = error {
                        print("SellCoin: SELL > Error updating document: \(error)")
                    } else {
                        print("SellCoin: Document successfully updated")
                    }
                }
                
                // Update the buy list
                fb.updateData(["buy": myMapBuy]) { error in
                    if let error = error {
                        print("SellCoin: BUY > Error updating document: \(error)")
                    } else {
                        print("SellCoin: Document successfully updated")
                    }
                }
                
                // Update the balance
                fb.updateData(["balance": bal ?? "balanceError"])
                {   error in
                    if let error = error {
                        print("SellCoin: BALANCE > Error updating balance: \(error)")
                    } else {
                        print("SellCoin: Balance successfully updated")
                    }
                }
                
            } else {
                print("buyCoin: Document does not exist")
            }
        }
    }
    
    
}



