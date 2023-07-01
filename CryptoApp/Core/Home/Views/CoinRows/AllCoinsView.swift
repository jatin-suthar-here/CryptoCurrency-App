//
//  AllCoinsView.swift
//  CryptoCurrencyApp
//
//  Created by Jatin Suthar on 11/03/23.
//

import SwiftUI

struct AllCoinsView: View {
    
    @StateObject var viewModel : HomeViewModel
    
    // Sheet Changes
    @State private var isExpanded = false
    @Binding var selectedCoin: Coin?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("All Coins")
                    .font(.headline)
                    .padding(.vertical, 5)
                    .padding(.top, 5)
                
                Spacer()

                Button(action: {
                    self.isExpanded.toggle()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.down")
                            .resizable()
                            .fontWeight(.bold)
                            .frame(width: 13, height: 8)
                            .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                            .padding([.top, .leading, .bottom, .trailing], 10)
                    }
                })
                .offset(y: 4)
            }
            .padding(.horizontal, 18)
            
            if isExpanded {
                SearchBarView(searchText: $viewModel.searchText)
            }
            
            HStack {
                Text("Coins")
                    .fontWeight(.bold)
                Spacer()
                Text("Prices")
                    .fontWeight(.bold)
            }
            .foregroundColor(.gray)
            .font(.subheadline)
            .padding(.horizontal, 25)
            
            if viewModel.filtercoins().count > 0
            {
                ScrollView {
                    ForEach(viewModel.filtercoins()) { coin in
                        
                        NavigationLink {
                            CoinDetailsView(coin: coin)
                        }
                        label: {
                            CoinRowView(coin: coin)
                                // Sheet Changes
                                .onTapGesture {
                                    selectedCoin = coin
                                }
                        }
                    }
                }
                .foregroundColor(Color("ForegroundColorText"))
            }
            else if viewModel.searchText.isEmpty
            {
                ScrollView {
                    ForEach(viewModel.coins) { coin in
                        
                        NavigationLink {
                            CoinDetailsView(coin: coin)
                        }
                        label: {
                            CoinRowView(coin: coin)
                                // Sheet Changes
                                .onTapGesture {
                                    selectedCoin = coin
                                }
                        }
                    }
                }
                .foregroundColor(Color("ForegroundColorText"))
            }
            else
            {
                HStack {
                    Spacer()
                    Text("No results found.")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .padding(.top, 30)
                    Spacer()
                }
            }
        }
        
        
        
        
    }
}

//struct AllCoinsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AllCoinsView(viewModel: HomeViewModel())
//    }
//}
