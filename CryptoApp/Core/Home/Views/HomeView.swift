
import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var authViewModel = AuthViewModel()
    @State private var coinDetailsPresented = false
    @State private var selectedCoin: Coin?
    @State private var isLoad = true
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            NavigationView {
                Group {
                    if isLoad {
                        ProgressView("Loading...")
                    }
                    else {
                        ScrollView(showsIndicators: false) {
                            
                            Portfolio()
                            
                            TopMoversView(viewModel: viewModel, selectedCoin: $selectedCoin)
                           
                            AllCoinsView(viewModel: viewModel, selectedCoin: $selectedCoin)
                            
                        }
                        .navigationTitle("Explore")
                    }
                }
                .onAppear {
                    DispatchQueue.global(qos: .background).async {
                        // Load UI components on the background thread
//                        let _ = Portfolio()
                        let _ = TopMoversView(viewModel: viewModel, selectedCoin: $selectedCoin)
                        let _ = AllCoinsView(viewModel: viewModel, selectedCoin: $selectedCoin)
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        DispatchQueue.main.async {
                            isLoad = false
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
            }
            
            
            // Navigation Item 2
            PortfolioView(selectedCoin: $selectedCoin)
                .tabItem {
                    Image(systemName: "bag.fill.badge.plus")
                }

//            // Navigation Item 3
//            PortfolioView(selectedCoin: $selectedCoin)
//                .tabItem {
//                    Image(systemName: "heart.fill")
//                }

            // Navigation Item 4
            CreditCardView()
                .tabItem {
                    Image(systemName: "creditcard")
                }
            
            // Navigation Item 5
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                }
                
        }
        // Sheet Changes
        .fullScreenCover(item: $selectedCoin) { coin in
            CoinDetailsView(coin: coin)
        }
    }
}


//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: HomeViewModel())
//    }
//}
