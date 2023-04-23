//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 16/04/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    
    let Screenwidth = UIScreen.main.bounds.width
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.leading, 15)
            
            TextField("Search coin...", text: $searchText)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding([.leading, .top, .bottom], 10)
                        .opacity (searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        } 
                    , alignment: .trailing
                )
                .padding(.trailing, 13)
        }
        .font(.headline)
        .padding([.vertical, .horizontal], 10)
        .background (
            RoundedRectangle (cornerRadius: 15)
                .fill(colorScheme == .dark ? .white.opacity(0.1) : .black.opacity(0.1))
                .frame(width: Screenwidth-30)
            )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant("")) 
    }
}
