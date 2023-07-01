//
//  SwiftUIView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 14/05/23.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State private var showAlert = false
    
    var body: some View {
        
        Button("Show Alert") {
            self.showAlert = true
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Title"),
                  message: Text("Message"),
                  primaryButton: .default(Text("OK"), action: {
                        // Handle cancel button action
                        print("OK button tapped")
                    }),
                  secondaryButton: .cancel(Text("Don't Save"), action: {
                        // Handle cancel button action
                        print("Cancel button tapped")
                    })
                  
            )
        }
        
        
        
        
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
