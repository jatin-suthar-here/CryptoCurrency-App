//  PortfolioView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 14/05/23.

import SwiftUI

struct PortfolioView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject var authViewModel = AuthViewModel()

    @Binding var selectedCoin: Coin?
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                Portfolio()
                
                FavouriteCoinsView(selectedCoin: selectedCoin)
                
            }
            .navigationTitle("Portfolio")
        }
    }
}

//struct PortfolioView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioView()
//    }
//}
