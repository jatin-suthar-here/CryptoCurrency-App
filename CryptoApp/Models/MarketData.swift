
import Foundation


struct MarketData: Codable, Hashable
{
    let prices, marketCaps, totalVolumes: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(prices)
        hasher.combine(marketCaps)
        hasher.combine(totalVolumes)
    }
}
