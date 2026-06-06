//
//  ProgressPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/5/23.
//

import SwiftUI

struct ProgressPage: View {
    var percentage: Double
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(orange, lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(pink, lineWidth: 20)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: percentage)
        }
    }
}

#Preview {
    ProgressPage(percentage: (Double)(1) / 2)
}
