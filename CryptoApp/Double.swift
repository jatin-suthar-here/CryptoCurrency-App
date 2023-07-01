
import Foundation

// Creating extension (ie. additional functionality) on Double Data Type.
// which contains closure "currencyForamatter" which uses NumberFormatter and returns obj.
// toCurrency func converts the Double value into String with specified Formatter specifications.
extension Double
{
    private var currencyFormatter : NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private var numberFormatter : NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toCurrency() -> String
    {
        return currencyFormatter.string(for: self) ?? "₹0.00"
    }
    
    func toPercetString() -> String
    {
        guard let numberAsString = numberFormatter.string(for: self) else { return "" }
        return numberAsString + "%"
    }
    func toNormalString() -> String
    {
        guard let numberAsString = numberFormatter.string(for: self) else { return "" }
        return numberAsString
    }
}



