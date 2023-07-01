//
//  SettingRowView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 01/05/23.
//

import SwiftUI

struct SettingRowView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
        .padding(.vertical, 4)
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRowView(imageName: "gear", title: "App Version", tintColor: Color(.systemGray))
    }
}
