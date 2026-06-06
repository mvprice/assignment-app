//
//  HomeSettingsPage.swift
//  PriceMadisonFinalProject
//
//  Created by Madison Price on 12/5/23.
//

import SwiftUI

struct HomeSettingsPage: View {
    @State var isShowing = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(height: 24)
                        .foregroundStyle(pink)
                        .padding()
                }
            }
        }
//        .padding(.horizontal, 24)
    }
}

#Preview {
    HomeSettingsPage()
}
