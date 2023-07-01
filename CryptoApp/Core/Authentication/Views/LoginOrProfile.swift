//
//  LoginOrProfile.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 17/06/23.
//

import SwiftUI

struct LoginOrProfile: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var authMinor : AuthMinorModel
    
    var body: some View {
        // We created this View because this will load the "FetchActiveUser" before if-else condtion which helps in decide to redirect whether in ActiveUsers() or LoginView().
        // This same in "ContenView" file was not working...."FetchActiveUsers" func was not running before if-else.
        // Wherever this View Loads the "FetchActiveUser" function will execute first.
        Group {
            if authMinor.userCollection.count > 1
            {
                ActiveUsers()
            }
            else {
                LoginView()
            }
        }
        .onAppear {
            Task {
                print("$$$$$$$$$$ : runnning over here")
                await authMinor.fetchActiveUsers()
            }
        }
    }
}

struct LoginOrProfile_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrProfile()
    }
}
