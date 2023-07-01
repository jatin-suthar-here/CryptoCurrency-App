//
//  TickBoxView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 24/06/23.
//

import SwiftUI

class SuccessNotificationManager: ObservableObject {
    @Published var showTick = false
}

struct SuccessNotificationView: View {
    @Binding var showTick: Bool
    
    var body: some View {
        if showTick {
            Rectangle()
                .fill(Color.green)
                .frame(width: 300, height: 300)
                .cornerRadius(7)
                .overlay(
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                )
                .transition(.opacity)
                .animation(.easeIn(duration: 1), value: "")
                .clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }
}

