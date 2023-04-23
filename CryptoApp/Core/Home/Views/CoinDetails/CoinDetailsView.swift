
import SwiftUI
import Kingfisher


struct CoinDetailsView: View {
    
    var data : [Double]
    var maxY : Double
    var minY : Double
    var lineColor : Color
    var Screenwidth : Double
    
    var coin : Coin
    
    
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
            
            ScrollView
            {
                KFImage(URL(string: coin.image))
                    .onSuccess { result in
                        
                        let uiColor = result.image.averageColor
                        backgroundColor = Color(uiColor ?? .purple)
                    }
                    .resizable()
                    .frame(width: 230, height: 230)
                    .clipShape(Circle())
                    .overlay{
                        Circle().stroke(.blue, lineWidth: 5)
                            .frame(width: 250, height: 250)
                    }
                    .padding([ .horizontal, .vertical ])
                    .padding(.top, 20)
                
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
                    
                    ZStack
                    {
                        Rectangle()
                            .frame(width: Screenwidth, height: 230)
                            .foregroundColor(.white.opacity(0.04))
                            .cornerRadius(15)
                            .padding(.bottom, 7)
                        
                        Rectangle()
                            .frame(width: Screenwidth, height: 230)
                            .foregroundColor(backgroundColor.opacity(0.3))
                            .cornerRadius(15)
                            .padding(.bottom, 7)
                        
                        HStack {
                            Spacer()
                            Divider()
                                .overlay(Color(.systemGray3))
                            Spacer()
                            Divider()
                                .overlay(Color(.systemGray3))
                            Spacer()
                            Divider()
                                .overlay(Color(.systemGray3))
                            Spacer()
                            Divider()
                                .overlay(Color(.systemGray3))
                            Spacer()
                        }
                        .frame(height: 228)
                        .offset(y:-3)
                        
                        VStack(alignment: .leading)
                        {
                            Spacer()
                            HStack {
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
                                    .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                }
                                .frame(width: Screenwidth-70, height: 160)
                                .background(
                                    VStack
                                    {
                                        Divider()
                                            .overlay(Color(.systemGray3))
                                        Spacer()
                                        Divider()
                                            .overlay(Color(.systemGray3))
                                        Spacer()
                                        Divider()
                                            .overlay(Color(.systemGray3))
                                        Spacer()
                                        Divider()
                                            .overlay(Color(.systemGray3))
                                        Spacer()
                                        Divider()
                                            .overlay(Color(.systemGray3))
                                    }
                                    .padding(.bottom, 7)
                                )
                                .clipped()
                                
                                VStack
                                {
                                    let point1 = (2 * minY + maxY) / 3
                                    let point2 = (minY + 2 * maxY) / 3
                                    Text("\(maxY.toNormalString())")
                                        .padding(.top, 5)
                                    Spacer()
                                    Text("\(point2.toNormalString())")
                                    Spacer()
                                    Text("\(point1.toNormalString())")
                                    Spacer()
                                    Text("\(minY.toNormalString())")
                                }
                                .font(minY > 10000 ? .caption2 : .caption)
                                .foregroundColor(.white)
                                .offset(x: minY > 10000 ? -5 : 5)
                                .padding(.leading, minY > 300 ? 0 : 10)
                            }
                            Divider()
                                .overlay(Color(.white))
                                .padding(.top, 10)
                            
                            HStack {
                                Text("\(getCurrentMonth()[3])")
                                Spacer()
                                Text("\(getCurrentMonth()[2])")
                                Spacer()
                                Text("\(getCurrentMonth()[1])")
                                Spacer()
                                Text("\(getCurrentMonth()[0])")
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .padding(.bottom, 15)
                            .font(.subheadline)
                            
                        }
                        
                    }
                    
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
                    }
                }
                .padding()
            }
            .navigationTitle(coin.name)
            .navigationBarTitleDisplayMode(.inline)
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
