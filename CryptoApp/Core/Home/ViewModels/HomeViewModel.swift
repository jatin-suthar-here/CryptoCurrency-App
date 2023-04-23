
import SwiftUI

class BindableString: ObservableObject {
    var value: String {
        didSet {
            onChange?()
        }
    }
    
    var onChange: (() -> Void)?
    
    init(_ value: String) {
        self.value = value
    }
}

class HomeViewModel : ObservableObject {
    // creating empty array of type "Coin"
    // () -> represents empty array...
    @Published var coins = [Coin]()
    @Published var topMovingCoins = [Coin]()
    
    @Published var searchText: String = ""
    
    // @Published is wrapper property used in conjunction with ObservableObject.
    // Any changes in object will reflect in Views...
    
    init()
    {
        fetchCoinData()
    }
    
    func fetchCoinData() {
        //  Defining URL for API communication
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h"
        
        // Converting into actual URL object
        guard let url = URL(string: urlString) else { return }
        
        // Extracting Data, Response, Error from the API
        URLSession.shared.dataTask(with: url)
        {
            data, response, error in
            
            // in case of error it will return / terminates
            if let err = error {
                print("DEBUG : Error : \(err.localizedDescription)")
                return
            }
            
            // getting HTTP Response
            if let response = response as? HTTPURLResponse {
                print("DEBUG : Response Code \(response.statusCode)")
            }
            
            // getting API generated Data
            guard let data = data else { return }
            let _ = String(data: data, encoding: .utf8)
//            print("DEBUG : \(dataString ?? "value")")
            
            
            do {
                // decoding data as an array : "decode([Coin].self"
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                
                DispatchQueue.main.async {
                    self.coins = coins
                    self.configureTopMovingCoins()
                }
            }
            catch let error {
                print("DEBUG : failed to decode data \(error)")
            }
            
        }
        .resume()
    }
    
    
    func filtercoins() -> [Coin]
    {
        let searchTextLowercased = searchText.lowercased()
//        print(" FILTERED DATA : \(coins.filter { $0.name.lowercased().contains(searchTextLowercased) }.map { $0.name })")
        return coins.filter { $0.name.lowercased().contains(searchTextLowercased) || $0.symbol.lowercased().contains(searchTextLowercased) }
    }
    
    
    
    
    func configureTopMovingCoins()
    {
        // creating array of top coins in descending order of "priceChangePercentage24H"
        let topMovers = coins.sorted(by: { $0.priceChangePercentage24H > $1.priceChangePercentage24H})
        // $0 and $1 are just 2 Coins which are being compared for achieving descending order (>).
        
        self.topMovingCoins = Array(topMovers.prefix(5))
    }
    
    
}


