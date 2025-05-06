//
//  HandMenuUI.swift
//  HippoHandTestingTest
//
//  Created by Esther Kim on 5/5/25.
//

import SwiftUI

struct HandMenuView: View {
    @State private var sliderValue: Double = 0
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Hand Menu UI")
                .font(.title)
                .bold()
            
            Slider(value: $sliderValue, in: 0...100, step: 1)
                .padding()
            
            Text("Value: \(Int(sliderValue))")
                .font(.headline)
            
            Button("Reset") {
                sliderValue = 0
            }
        }
        .padding()
    }
}

#Preview() {
    HandMenuView()
}
