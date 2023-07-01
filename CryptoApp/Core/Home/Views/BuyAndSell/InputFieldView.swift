//
//  InputFieldView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 24/05/23.
//

import SwiftUI

struct InputFieldView: View {
    
    @Binding var text: String
    var placeholder: String
    let Screenwidth = (UIScreen.main.bounds.width)
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder)
            .foregroundColor(.white.opacity(0.5))
        )
        .font(.system(size: 16))
        .foregroundColor(Color(.white))
        .frame(width: (Screenwidth/3) - 40)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.white.opacity(0.1))
        .cornerRadius(7)
        .keyboardType(.numberPad)
//        .disabled(text.count99 >= 4)
        .onChange(of: text) { newValue in
            if let amount = Int(newValue), amount > 1001 {
                text = "1000" // Restrict the input to 1000
            }
        }
        
    }
}


struct InputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldView(text: .constant(""), placeholder: "name@apple.com ")
    
    }
}
