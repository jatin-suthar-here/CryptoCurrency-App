//
//  InputView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text: String
    var title: String
    var placeholder: String
    var isSecureField: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10)
        {
            Text(title)
                .foregroundColor(Color(.gray))
                .fontWeight(.semibold)
                .font(.footnote)
                .padding(.bottom, -3)
            
            if isSecureField
            {
                SecureField("", text: $text,prompt: Text(placeholder)
                    .foregroundColor(.gray)
                )
                    .font(.system(size: 14))
                    .foregroundColor(Color(.white))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 13)
                    .background(.gray.opacity(0.22))
                    .cornerRadius(7)
            }
            else
            {
                TextField("", text: $text,prompt: Text(placeholder)
                    .foregroundColor(.gray)
                )
                    .font(.system(size: 14))
                    .foregroundColor(Color(.white))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 13)
                    .background(.gray.opacity(0.22))
                    .cornerRadius(7)
                    .frame(height: 40)
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@apple.com ")
    }
}
