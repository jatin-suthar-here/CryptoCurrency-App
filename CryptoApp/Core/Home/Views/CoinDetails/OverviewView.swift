//
//  OverviewView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/04/23.
//

import SwiftUI

struct OverviewView: View {
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
                let excludedProperties = ["sparklineIn7D", "image", "id", "symbol", "name", "currentPrice",  "priceChangePercentage24H"]
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
                .padding(10)
                .padding(.horizontal, 10)
            }
        }
    }
}

//struct OverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverviewView()
//    }
//}
