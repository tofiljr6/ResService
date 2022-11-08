//
//  ConsumerConfirmOrderView.swift
//  ResService
//
//  Created by Mateusz Tofil on 08/11/2022.
//

import SwiftUI

struct ConsumerConfirmOrderView: View {
//    @Environment(\.presentationMode) var presentationMode
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        VStack {
            Button("Confirm") {
                // sprawdzenie lokalizacji
                
                // cofanie
                // self.presentationMode.wrappedValue.dismiss()
                self.shouldPopToRootView = false
            }
        }.navigationTitle("Confirmation")
    }
}

struct ConsumerConfirmOrderView_Previews: PreviewProvider {
    @State static var shouldPopToRootView : Bool = false
    
    static var previews: some View {
        NavigationView {
            ConsumerConfirmOrderView(shouldPopToRootView: $shouldPopToRootView)
                .navigationTitle("Confirmation")
        }
    }
}
