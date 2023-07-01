//  FavouriteCoinsView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 14/05/23.
//

import SwiftUI

struct FavouriteCoinsView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var authViewModel = AuthViewModel()
    
    @State var selectedCoin: Coin?
    @State var isAddingToFavorites = false
    @State var favList = [String]()
    
    @State private var option = "Earliest"
    var filterOptions = ["Latest", "Earliest", "Market Cap"]
    
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Favourite Coins")
                    .font(.headline)
                Spacer()
                
                Picker("Select an option", selection: $option) {
                    ForEach(filterOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: option) { newValue in
                    getFilterForSelectedOption()
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 18)
            
            ScrollView {
                if option == "Market Cap"
                {
                    let filteredCoins = viewModel.coins.filter { favList.contains($0.name) }
                    let sortedCoins = filteredCoins.sorted { $0.marketCap ?? 0.0 > $1.marketCap ?? 0.0 }
                    ForEach(sortedCoins) { coin in
                        Button(action: {
                        },
                        label: {
                            CoinRowView(coin: coin)
                                .onTapGesture { selectedCoin = coin }
                        })
                        .foregroundColor(Color("ForegroundColorText"))
                    }
                }
                else
                {
//                    let filteredCoins = viewModel.coins.filter { favList.contains($0.name) }
                    let filteredCoins = favList.compactMap { favoriteCoin in
                        viewModel.coins.first { $0.name == favoriteCoin }
                    }
                    ForEach(filteredCoins) { coin in
                        Button(action: {
                        },
                        label: {
                            CoinRowView(coin: coin)
                                .onTapGesture { selectedCoin = coin }
                        })
                        .foregroundColor(Color("ForegroundColorText"))
                    }
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    Rectangle()
                        .overlay(colorScheme == .dark ? AnyView( LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.white.opacity(0.8)))
                        .cornerRadius(15)

                    Button(action: {
                        isAddingToFavorites = true
                    }) {
                        HStack {
                            Text("Add to favorites")
                                .fontWeight(.semibold)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Image(systemName: "plus.app.fill")
                                .font(.title2)
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : Color(.darkGray).opacity(0.5))

                        }
                        .padding(.horizontal, 15)
                    }
                    .fullScreenCover(isPresented: $isAddingToFavorites) {
                        FavCoinListView()
                            .onDisappear { getFilterForSelectedOption()}
                    }


                }
                .frame(width: (UIScreen.main.bounds.width - 26), height: 60)
                .padding(.leading, 13)


            }
            
            
            
        }
        .onAppear { getFilterForSelectedOption() }
        .fullScreenCover(item: $selectedCoin) {
            coin in
            CoinDetailsView(coin: coin)
                .onDisappear { getFilterForSelectedOption() } }
        
        
    }
    
    private func getFilterForSelectedOption() {
        switch option {
            case "Earliest":
                authViewModel.ListFavourites(isReversed: false) { result in favList = result }
            case "Latest":
                authViewModel.ListFavourites(isReversed: true) { result in favList = result }
            case "Market Cap":
                authViewModel.ListFavourites(isReversed: false) { result in favList = result }
            default:
                print("Invalid option default")
        }
    }
}
