
import SwiftUI

struct TopMoversView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Top Movers")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.topMovingCoins) {
                        coin in
                        NavigationLink {
                            CoinDetailsView(coin: coin)
                        }
                    label: {
                        TopMoversItemView(coin: coin)
                            .padding(.trailing, 3)
                    }
                        
                    }
                    
                }
            }
        }
        .padding(14)
        
        
        
        
    }
}

struct TopMoversView_Previews: PreviewProvider {
    static var previews: some View {
        TopMoversView(viewModel: HomeViewModel())
    }
}
