
import Foundation
import SwiftUI

extension UIColor {
    var isLight: Bool {
        var white: CGFloat = 0
        getWhite(&white, alpha: nil)
        return white > 0.5
    }
}


extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}



// finds the averge color of the image
extension UIImage {
    /// Average color of the image, nil if it cannot be found
    var averageColor: UIColor?
    {
        // convert our image to a Core Image Image
        guard let inputImage = CIImage(image: self) else {
            print("guard 1 error")
            return nil }
        
        // Create an extent vector (a frame with width and height of our current input image)
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)
        
        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else {
            print("guard 2 error")
            return nil }
        guard let outputImage = filter.outputImage else {
            print("guard 3 error")
            return nil }
        
        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        // Convert our bitmap images of r, g, b, a to a UIColor
        let color = UIColor(red: CGFloat(bitmap[0]) / 255,
                            green: CGFloat(bitmap[1]) / 255,
                            blue: CGFloat(bitmap[2]) / 255,
                            alpha: CGFloat(bitmap[3]) / 255)
        
        // Check if the color is white or a shade of white
//        let isWhite = color.isWhiteOrShadeOfWhite()
        
        if isShadeOfWhite(color: color)
        {
//            if isWhite{
//                return nil
//            }
            return nil
        }
        else {
            return color
        }
        
        
    }
}


func isShadeOfWhite(color: UIColor) -> Bool {
    // Get the color's RGB components
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // Check if the RGB values are all greater than or equal to 0.9
    // This threshold can be adjusted to fit your needs
    
    return red >= 0.9 && green >= 0.9 && blue >= 0.9
}
extension UIColor {
    func isWhiteOrShadeOfWhite() -> Bool {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let maxColorComponent = max(r, g, b)
        let isWhiteOrShadeOfWhite = (maxColorComponent > 0.9 && abs(r - g) < 0.03 && abs(r - b) < 0.03 && abs(g - b) < 0.03)
        return isWhiteOrShadeOfWhite
    }
}

