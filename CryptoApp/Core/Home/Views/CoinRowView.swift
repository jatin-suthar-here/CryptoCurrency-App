
import SwiftUI
import Kingfisher

struct CoinRowView: View {
    
    var data : [Double]
    var maxY : Double
    var minY : Double
    var lineColor : Color
    
    @Environment(\.colorScheme) var colorScheme
    var coin: Coin
    @State private var backgroundColor2: UIColor = .clear
    @State private var backgroundColor: Color = .clear
    
    
    init(coin: Coin) {
        if let prices = coin.sparklineIn7D?.price {
            self.data = prices
            self.maxY = data.max() ?? 0
            self.minY = data.min() ?? 0
            let priceChange = (data.last ?? 0) - (data.first ?? 0)
            self.lineColor = priceChange > 0 ? .green : .red
            self.coin = coin
        } else {
            // Initialize the properties with default values
            self.data = []
            self.maxY = 0
            self.minY = 0
            self.lineColor = .clear
            self.coin = coin
        }
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
                        .onSuccess { result in
                            
                            let uiColor = result.image.averageColor
                            backgroundColor2 = result.image.averageColor ?? UIColor(red:0.96, green:0.54, blue:0.10, alpha:1.0)
                            backgroundColor = Color(uiColor ?? .purple)
                        }
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
                    
                    GeometryReader { geometry in
                        Path { path in
                            
                            for index in data.indices
                            {
                                let xpostion = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                                
                                let yAxis = maxY - minY
                                
                                // here we are subtracting from 1 because (0,0) is at the top left of the screen and 1000 is at the bottom right of the screen, which is like inverse of the actual graph... so we are making it inverse again so that (0,0) lies at the botton left and 1000 lies at top right of the screen.
                                let yPosition = (1-CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                                
                                if index == 0 {
                                    path.move(to: CGPoint(x: xpostion, y: yPosition))
                                }
                                path.addLine(to: CGPoint(x: xpostion, y: yPosition))
                                
                            }
                        }
                        .stroke(lineColor, style: StrokeStyle(lineWidth: 0.5, lineCap: .round, lineJoin: .round))
                    }
                    .frame(width: 80, height: 25)
                    .background(
                        VStack
                        {
                            Spacer()
                            Divider()
                                .overlay(lineColor)
                            Spacer()
                        }
                    )
                    
                    
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
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.leading, 2)
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
            }
            .frame(width: (UIScreen.main.bounds.width - 26), height: 65)
            
//            .background(colorScheme == .dark ? backgroundColor.opacity(0.2) : backgroundColor.opacity(0.5))
            
            // Gradient Color
            .background(colorScheme == .dark ? (.linearGradient(colors: [backgroundColor.opacity(0.3), .black.opacity(0.1)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.3, y: 1.3)))
                                :
                        (.linearGradient(colors: [backgroundColor.opacity(0.4)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1.7, y: 1.7))))
            .cornerRadius(15)
            .padding(.leading, 13)
            .padding(.bottom, 2)
        }
        
        
        
        
        
        
    }
}

//struct CoinRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        CoinRowView()
//    }
//}
