
import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        
        NavigationView() {
            ScrollView(showsIndicators: false) {
                Portfolio()
                
                TopMoversView(viewModel: viewModel)
                
                AllCoinsView(viewModel: viewModel)
            }
            .navigationTitle("Summary")
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
