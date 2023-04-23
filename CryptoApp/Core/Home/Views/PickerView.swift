//
//  PickerView.swift
//  CryptoApp
//
//  Created by Jatin Suthar on 18/04/23.
//

import SwiftUI

struct PickerView: View {
    
    let options = ["Option 1", "option 2", "Option 3"]
    @State private var selectedOption = "Option 1"
    
    var body: some View {
        VStack {
            Text("Selected option: \(selectedOption)")
            Picker("Select an option", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}
