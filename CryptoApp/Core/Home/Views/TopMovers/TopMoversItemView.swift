import SwiftUI
import Kingfisher
struct TopMoversItemView: View {
    
    var coin : Coin
    @Environment(\.colorScheme) var colorScheme
    @State private var backgroundColor: Color = .clear
    @State private var backgroundColor2: UIColor = .clear
    
    var body: some View {
        VStack(alignment: .leading)
        {
            HStack {
                KFImage(URL(string: coin.image))
                    .onSuccess { result in
                        
                        let uiColor = result.image.averageColor
                        backgroundColor2 = result.image.averageColor ?? UIColor(red:0.96, green:0.54, blue:0.10, alpha:1.0)
                        backgroundColor = Color(uiColor ?? .purple)
                    }
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .foregroundColor(.orange)
                    .padding(.trailing, 1)
                    
                
                VStack(alignment: .leading)
                {
                    Text(coin.symbol.uppercased())
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Text(coin.currentPrice.toCurrency())
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TopMoversColor"))
                    
                    // Coin Percentage Change
                    Text(coin.priceChangePercentage24H.toPercetString())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
                }
            }
            
        }
        .frame(width: 200, height: 140)
//        .background(colorScheme == .dark ? backgroundColor : backgroundColor)
        .background(.linearGradient(colors: colorScheme == .dark ? [backgroundColor, Color(backgroundColor2.adjust(by: -70) ?? .purple)] : [Color(backgroundColor2.adjust(by: 30) ?? .purple), Color(backgroundColor2.adjust(by: 60) ?? .purple)], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 2.7, y: 2.7)))
        .cornerRadius(15)
    }
}

