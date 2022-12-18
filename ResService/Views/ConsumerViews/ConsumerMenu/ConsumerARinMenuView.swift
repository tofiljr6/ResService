//
//  ConsumerARinMenuView.swift
//  ResService
//
//  Created by Mateusz Tofil on 12/12/2022.
//

import SwiftUI

struct ConsumerARinMenuView: View {
    var body: some View {
        
        VStack(alignment: .leading) {
//            HStack {
//                Text("Visulaziation")
//                    .font(.title2)
//                    .padding(.leading, 15)
//                    .padding(.top, 15)
//                Spacer()
//                Image(systemName: "camera.viewfinder")
//                    .font(.title2)
//                    .foregroundColor(.yellow)
//                    .padding(.trailing, 15)
//                    .padding(.top, 15)
//            }
            NavigationLink {
                ARUIView()
            } label: {
                ZStack {
                    Image("bg")
                        .resizable()
                        .cornerRadius(5)
                        .frame(height: 250)
                        .scaledToFit()
                        .padding()
                    Text("Visulaziation")
                        .font(.title)
                        .foregroundColor(.black)
                    Text("Click here to see more than the reality")
                        .foregroundColor(.black)
                        .offset(y: 25)
                }
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
        
}

struct ConsumerARinMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumerARinMenuView()
    }
}
