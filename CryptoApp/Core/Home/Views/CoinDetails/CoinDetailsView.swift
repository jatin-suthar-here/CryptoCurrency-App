//
//  CoinDetailsView2.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/04/23.
//

import SwiftUI
import Kingfisher

func optionalToStringNew(val : Any) -> String {
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
    
    @State private var selectedOption = "Overview"
    @State private var backgroundColor: Color = .clear
    @State private var scale: CGFloat = 1.0
    @State private var isScaleActive: Bool = false
    @State private var isFavourite: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    // Sheet Changes
    @Environment(\.presentationMode) var presentationMode
    
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
        NavigationView {
        ZStack
        {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(.linearGradient(colors: [backgroundColor, .black, .black], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
            
                VStack
                {
                    // BACK button.....
                    // Sheet Changes
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() },
                               label: {
                            Image(systemName: "chevron.backward")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .frame(minWidth: 40, minHeight: 30)
                                .contentShape(Rectangle())
                        })
                        Spacer()
                    }
                    .padding(.bottom, -20)
                    .padding(.horizontal, 20)
                    
                    
                    // Center Info...
                    ScrollView(showsIndicators: false)
                    {
                        VStack(spacing: 20)
                        {
                            // Coin Image...
                            GeometryReader {
                                geometry in
                                HStack
                                {
                                    let opacityValue = shouldHideImage(in: geometry) ? 0 : 1.0
                                    
                                    Spacer()
                                    KFImage(URL(string: coin.image))
                                        .onSuccess { result in
                                            let uiColor = result.image.averageColor
                                            backgroundColor = Color(uiColor ?? .purple)
                                        }
                                        .resizable()
                                        .onAppear {
                                            viewModel.CheckIsFavourite(coinName: coin.name) { result in
                                                print("check is fav : ", result)
                                                isFavourite = result
                                            }
                                        }
                                    // placing before creating ring...so that only image gets smaller not ring
                                        .scaleEffect(scale)
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                        .overlay {
                                            Circle().stroke(.blue, lineWidth: 5)
                                                .frame(width: 220, height: 220)
                                        }
                                        .padding(.horizontal)
                                        .padding(.top, -15)
                                        .opacity(opacityValue).animation(.easeOut(duration: 0.3), value: opacityValue)
                                        .offset(y: -geometry.frame(in: .global).minY + 110)
                                        .onTapGesture {
                                            withAnimation {
                                                if isScaleActive
                                                {
                                                    scale = 1
                                                    isScaleActive = false
                                                }
                                                else {
                                                    scale = 0.5
                                                    isScaleActive = true
                                                }
                                            }
                                        }
                                        .zIndex(1)
                                    
                                    
                                    Spacer()
                                }
                            }
                            .frame(height: 260)
                            
                            // Picker Options...
                            Picker("Select an option", selection: $selectedOption) {
                                ForEach(options, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(width: Screenwidth)
                            .background(backgroundColor.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.top, -10)
                            .padding(.bottom, -5)
                            .zIndex(2)
                            
                            // Coin Views...
                            getViewForSelectedOption()
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    
                    // BUY & SELL buttons...
                    HStack(spacing: 0) {
                        Spacer()
                        NavigationLink(destination: BuyCoins(backgroundColor: backgroundColor, coin: coin)
                            .navigationBarBackButtonHidden(true)){
                            Text("BUY")
                                .frame(maxWidth: Screenwidth, maxHeight: 20)
                                .padding(10)
                                .fontWeight(.bold)
                                .background(.green.opacity(0.7))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        NavigationLink(destination: SellCoins(backgroundColor: backgroundColor, coin: coin)
                            .navigationBarBackButtonHidden(true)) {
                            Text("SELL")
                                .frame(maxWidth: Screenwidth, maxHeight: 20)
                                .padding(10)
                                .fontWeight(.bold)
                                .background(.red.opacity(0.7))
                                .cornerRadius(6)
                                .foregroundColor(.white)
                                .contentShape(Rectangle())
                        }
                        
                        Spacer()
                        
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
                                .frame(width: Screenwidth/10, height: 20)
                                .padding(10)
                                .fontWeight(.bold)
                                .background(.gray.opacity(0.5))
                                .cornerRadius(6)
                                .foregroundColor(isFavourite ? .red : .white)
                                .contentShape(Rectangle())
                        })
                        Spacer()
                    }
                    .zIndex(1)
                    .padding(.horizontal, 18)
                }
                
            }
        }
        
        
    }
                                       

    
    func shouldHideImage(in geometry: GeometryProxy) -> Bool {
        let minY = geometry.frame(in: .global).minY
        let offset = CGFloat(0)
        return minY < -offset
    }
    
    private func getViewForSelectedOption() -> some View {
        switch selectedOption {
            case "Overview":
                return AnyView(OverviewView(coin: coin, backgroundCol: backgroundColor))
            case "Charts":
                return AnyView(CoinChartsView(coin: coin, backgroundCol: backgroundColor))
            case "Stats":
                return AnyView(CoinStatsView(coin: coin, backgroundCol: backgroundColor))
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

