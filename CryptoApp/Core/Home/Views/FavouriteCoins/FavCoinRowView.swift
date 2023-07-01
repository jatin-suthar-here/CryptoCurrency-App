//
//  FavCoinRowView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/05/23.
//

import SwiftUI
import Kingfisher


struct FavCoinRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    @State private var backgroundColor2: UIColor = .clear
    @State private var backgroundColor: Color = .clear
    @State private var isFavourite: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    var body: some View {
        ZStack
        {
            Rectangle()
                .frame(width: (UIScreen.main.bounds.width - 26), height: 65)
                .foregroundColor(colorScheme == .dark ? .gray.opacity(0.11) : .clear)
                .cornerRadius(15)
                .padding(.leading, 13)
                .padding(.bottom, 2)
            
            VStack
            {
                HStack {
                    Text("\(coin.marketCapRank)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("ForegroundColorText"))
                        .frame(width: coin.marketCapRank > 99 ? 25 : 20, alignment: .center)
                        .offset(x:-5)
                    
                    KFImage(URL(string: coin.image))
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.orange)
                        .offset(x: -7)
                    
                    VStack(alignment: .leading) {
                        Text(coin.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .padding(.leading, 1)
                    }
                    .padding(.leading, -5)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(coin.currentPrice.toCurrency())
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(coin.priceChangePercentage24H > 0 ? "+" + coin.priceChangePercentage24H.toPercetString() : coin.priceChangePercentage24H.toPercetString())
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
                            .padding(.leading, 1)
                    }
                    
                    Button(action: {
                        if isFavourite {
                            isFavourite = false
                            viewModel.addToFavourite(coinName: coin.name)
                        }
                        else {
                            isFavourite = true
                            viewModel.addToFavourite(coinName: coin.name)
                        }
                    },
                           label: {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .resizable()
                            .fontWeight(.semibold)
                            .foregroundColor(colorScheme == .dark ? (isFavourite ? .red : .white) : (isFavourite ? .red : Color(.darkGray).opacity(0.7)))
                            .frame(width: 24, height: 21)
                            .padding(.leading, 20)
                            .padding(.trailing, 10)
                    })
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
            }
            .onAppear {
                viewModel.CheckIsFavourite(coinName: coin.name) { result in
                    isFavourite = result
                }
            }
            .frame(width: (UIScreen.main.bounds.width - 26), height: 65)
            .background(colorScheme == .dark ? AnyView( LinearGradient(gradient: Gradient(colors: [Color(red: 0.07, green: 0.13, blue: 0.26), Color(red: 0.13, green: 0.26, blue: 0.19)]), startPoint: .bottomTrailing, endPoint: .topLeading)) : AnyView(Color.gray.opacity(0.3)))
            .cornerRadius(15)
            .padding(.leading, 13)
            .padding(.bottom, 2)
        }
    }
}
