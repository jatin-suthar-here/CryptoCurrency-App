//
//  FavCoinListView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 16/05/23.
//

import SwiftUI

struct FavCoinListView: View {
    @StateObject var viewModel = HomeViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    
    var body: some View {
        VStack(alignment: .leading)
        {
            ZStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() },
                           label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .frame(minWidth: 40, minHeight: 30)
                            .contentShape(Rectangle())
                    })
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Spacer()
                    Text("Add to favourites")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.top, 10)
            }
            .padding(.top, 50)
            
            
            ScrollView {
                ForEach(viewModel.coins)
                {
                    coin in
                    FavCoinRowView(coin: coin)
                }
            }
            
            
        }
        .ignoresSafeArea()
    }
        
}

//struct FavCoinListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavCoinListView()
//    }
//}
