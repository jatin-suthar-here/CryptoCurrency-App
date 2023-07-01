//
//  testingOnly.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 20/06/23.
//

import SwiftUI

struct testingOnly: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        List {
            Text("Pepperoni pizza")
                .swipeActions {
                    Button("Order") {
                        print("Awesome!")
                    }
                    .tint(.green)
                }
            
            Text("Pepperoni with pineapple")
                .swipeActions {
                    Button("Burn") {
                        print("Right on!")
                    }
                    .tint(.red)
                }
        }
    }
}


struct testingOnly_Previews: PreviewProvider {
    static var previews: some View {
        testingOnly()
    }
}
