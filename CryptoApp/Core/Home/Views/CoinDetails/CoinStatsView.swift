//
//  CoinStatsView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/04/23.
//

import SwiftUI

struct CoinStatsView: View {
    var data : [Double]
    var maxY : Double
    var minY : Double
    var lineColor : Color
    var Screenwidth : Double
    
    var coin : Coin
    
    
    var backgroundColor : Color
    @Environment(\.colorScheme) var colorScheme
    
    init(coin: Coin, backgroundCol: Color) {
        if let prices = coin.sparklineIn7D?.price {
            self.data = prices
            self.maxY = data.max() ?? 0
            self.minY = data.min() ?? 0
            self.Screenwidth = (UIScreen.main.bounds.width) - 30
            let priceChange = (data.last ?? 0) - (data.first ?? 0)
            self.lineColor = priceChange > 0 ? .green : .red
            self.coin = coin
        } else {
            // Initialize the properties with default values
            self.data = []
            self.maxY = 0
            self.minY = 0
            self.Screenwidth = 0
            self.lineColor = .clear
            self.coin = coin
        }
        self.backgroundColor = backgroundCol
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack
            {
                Rectangle()
                    .frame(width: Screenwidth, height: 130)
                    .foregroundColor(.white.opacity(0.04))
                    .cornerRadius(15)
                Rectangle()
                    .frame(width: Screenwidth, height: 130)
                    .foregroundColor(backgroundColor.opacity(0.3))
                    .cornerRadius(15)
                
                VStack(alignment: .leading)
                {
                    Text(coin.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    HStack {
                        Text(coin.symbol.uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("\(coin.marketCapRank)")
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                        Spacer()
                        VStack(alignment: .trailing)
                        {
                            Text("PC 24H")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                            let sign = (coin.priceChangePercentage24H > 0 ? "+" : "")
                            Text(sign + coin.priceChangePercentage24H.toPercetString())
                                .fontWeight(.bold)
                                .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
                        }
                    }
                    .font(.headline)
                    
                    HStack
                    {
                        Text(coin.currentPrice.toCurrency())
                            .font(.system(size: 23))
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        Text("CP")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .offset(x: -1, y: 2)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            
            ZStack
            {
                let excludedProperties = ["sparklineIn7D", "image", "id", "symbol", "name", "currentPrice",  "priceChangePercentage24H", "circulatingSupply", "totalSupply", "maxSupply", "ath", "athChangePercentage", "athDate", "atl", "atlChangePercentage", "atlDate", "lastUpdated", "priceChangePercentage24HInCurrency", "marketCapChange24H", "marketCapChangePercentage24H", "priceChangePercentage24H", "marketCapRank", "high24H", "low24H"]
                let arr = Array(Mirror(reflecting: coin).children).filter { !excludedProperties.contains($0.label ?? "") }
                
                Rectangle()
                    .frame(width: Screenwidth)
                    .foregroundColor(.white.opacity(0.04))
                    .cornerRadius(15)
                Rectangle()
                    .frame(width: Screenwidth)
                    .foregroundColor(backgroundColor.opacity(0.3))
                    .cornerRadius(15)
                
                VStack(alignment: .leading)
                {
                    ForEach(arr , id: \.label)
                    {
                        index in
                        HStack {
                            let label = index.label!
                            Text(label + " :")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: (Screenwidth/2), alignment: .leading)
                                .padding(.leading, 10)
                            
                            if let val = optionalToString(val: index.value)
                            {
                                Text(val)
                                    .font(.headline)
                                    .foregroundColor(Color(.lightGray))
                            }
                            else
                            {
                                Text("ERROR")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                            
                        }
                        .padding(.vertical, 10)
                        
                        Divider()
                            .frame(width: Screenwidth-40)
                            .padding(.leading, 20)
                            .overlay(.gray)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

