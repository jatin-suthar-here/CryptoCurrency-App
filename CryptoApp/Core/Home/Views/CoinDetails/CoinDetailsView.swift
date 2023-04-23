//
//  CoinDetailsView2.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/04/23.
//

import SwiftUI


import SwiftUI
import Kingfisher

func optionalToStringNew(val : Any) -> String
{
    switch val
    {
        case let val as Double:
            return String(val)
        case let val as Int:
            return String(val)
        case let val as String:
            return String(val)
        default:
            return ""
    }
}

struct CoinDetailsView: View {
    
    var data : [Double]
    var maxY : Double
    var minY : Double
    var lineColor : Color
    var Screenwidth : Double
    
    var coin : Coin
    
    let options = ["Overview", "Charts", "Stats"]
    
    @State private var selectedOption = "Charts"
    @State private var backgroundColor: Color = .clear
    @Environment(\.colorScheme) var colorScheme
    
    init(coin: Coin) {
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
    }
    
    var body: some View {
        
        ZStack
        {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(.linearGradient(colors: [backgroundColor, .black, .black], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false)
            {
                KFImage(URL(string: coin.image))
                    .onSuccess { result in
                        
                        let uiColor = result.image.averageColor
                        backgroundColor = Color(uiColor ?? .purple)
                    }
                    .resizable()
                    .frame(width: 230, height: 230)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(.blue, lineWidth: 5)
                            .frame(width: 250, height: 250)
                    }
                    .padding([ .horizontal, .vertical ])
                    .padding(.top, 20)
                
                
                Picker("Select an option", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: Screenwidth)
                .padding()
                
                getViewForSelectedOption()
            }
            .navigationTitle(coin.name)
            .navigationBarTitleDisplayMode(.inline)
            
            
            
        }
        
        
        
        
    }
    
    private func getViewForSelectedOption() -> some View {
        switch selectedOption {
            case "Overview":
                return AnyView(CoinStatsView(coin: coin, backgroundCol: backgroundColor))
            case "Charts":
                return AnyView(CoinChartsView(coin: coin, backgroundCol: backgroundColor))
            case "Stats":
                return AnyView(OverviewView(coin: coin, backgroundCol: backgroundColor))
            default:
                return AnyView(Text("Invalid option default"))
        }
    }
    
    func getCurrentMonth() -> [String] {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        let dict : [String : Int] = [
            "Jan" : 1,
            "Feb" : 2,
            "Mar" : 3,
            "Apr" : 4,
            "May" : 5,
            "Jun" : 6,
            "Jul" : 7,
            "Aug" : 8,
            "Sep" : 9,
            "Oct" : 10,
            "Nov" : 11,
            "Dec" : 12,
        ]
        var month_arr : [String] = []
        var prevMonth = month
        for _ in 1...4 { // add 4 months
            if prevMonth < 1 { // handle Jan to Dec wraparound
                prevMonth += 12
            }
            for (monthName, monthNum) in dict {
                if monthNum == prevMonth {
                    month_arr.append(monthName)
                    break
                }
            }
            prevMonth -= 3 // go back 3 months
        }
        return month_arr
    }
}


