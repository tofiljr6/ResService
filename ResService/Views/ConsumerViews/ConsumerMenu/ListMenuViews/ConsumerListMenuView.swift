//
//  ConsumerLIstMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 10/12/2022.
//

import SwiftUI

struct ConsumerListMenuView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedTab) {
                Text("Tile").tag(0)
                Text("List").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            switch(selectedTab) {
                case 0: Text("S")
                default: Text("Ss")
//                case 1: SecondTabView()
//                case 2: ThirdTabView()
            }
        }
    }
}

struct ConsumerListMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerListMenuView()
    }
}
