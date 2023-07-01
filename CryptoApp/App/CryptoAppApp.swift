//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 21/03/23.
//

import SwiftUI
import Firebase

@main
struct CryptoAppApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    @StateObject var authMinor = AuthMinorModel()
    @StateObject var successNotificationManager = SuccessNotificationManager()
    
    init()
    {
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(authMinor)
                .environmentObject(successNotificationManager)

        }
    }
}
