//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 16/04/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction (#selector (UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
