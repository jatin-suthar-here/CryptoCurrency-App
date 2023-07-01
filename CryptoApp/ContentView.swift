//
//  ContentView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 21/03/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var authMinor : AuthMinorModel
    
    var body: some View {
            if viewModel.userSession != nil {
                HomeView(authViewModel: viewModel)
            }
            else
            {
                LoginOrProfile()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
