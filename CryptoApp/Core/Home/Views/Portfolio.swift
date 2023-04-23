//
//  Portfolio.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 16/04/23.
//

import SwiftUI

struct Portfolio: View {
    
    let Screenwidth = (UIScreen.main.bounds.width) - 30
    
    var body: some View {

        VStack(alignment: .leading) {
            Text("Total Balance")
                .font(.headline)
                .padding(.top, 5)
                .padding(.leading, 18)
            
            ZStack
            {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(1))
                    .frame(width: Screenwidth, height: 100)
                
                HStack
                {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.cyan))
                        .blur(radius: 80)
                        .frame(width: 300, height: 200)
                        .offset(y: 20)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.indigo)
                        .blur(radius: 70)
                        .frame(width: 200, height: 200)
                        .offset(y: 20)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.purple))
                        .blur(radius: 80)
                        .frame(width: 300, height: 200)
                        .offset(y: 20)
                    
                }
                .frame(width: Screenwidth, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                // upper layer of white rectangle
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: Screenwidth, height: 100)
                
                // text contents
                HStack {
                    VStack(alignment: .leading)
                    {
                        Text("$24,087.83")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        let percentText = "4,511.65 (18.73%)"
                        let percentTextLen = percentText.count
                        
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                            
                            Text(percentText)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: CGFloat(percentTextLen) * 11.3, height: 26)
                                .foregroundColor(Color(hue: 0.208, saturation: 0.879, brightness: 0.981))
                        )
                        .padding(.top, -30)
                        .offset(x: 7)
                        
                    }
                    .padding(.leading, 40)
                    Spacer()
                }
                
                
            }
        }
        
        
        
        
        
        
        
        
        
    }
}

struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
        Portfolio()
    }
}
