//
//  KitchenView.swift
//  ResService
//
//  Created by Mateusz Tofil on 13/10/2022.
//

import SwiftUI

struct KitchenView: View {
//    @ObservedObject var observedTest : TestObservalbeObject
//    @ObservedObject var progress : OrdersInProgress
//    var body: some View {
//        VStack {
//            Text("siema \(self.observedTest.testnumber)")
//            Text("\(self.progress.test)")
//        }
//    }
//}
    @ObservedObject var progress : OrdersInProgress
    
    
    
    var columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            HStack {
                VStack{
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 2)], spacing: 2) {
                            ForEach(Array(progress.tabledishesDict.keys), id: \.self) { key in
                                Card(tableName: key, dishes: progress.tabledishesDict[key]!)
                                    .padding()
                            }
                        }
                    }
                }
            }
        } else { // if UIDevide.current.userInterfaceIdiom == .pad
            HStack {
                VStack{
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(Array(progress.tabledishesDict.keys), id: \.self) { key in
                            Card(tableName: key, dishes: progress.tabledishesDict[key]!)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct Card : View {
    var tableName : String
    var dishes : [Dish2]
    
    var body: some View {
        VStack {
            HStack {
                Text(tableName)
                    .font(.title)
                    .padding(.leading)
                Spacer()
            }
            ForEach(dishes, id: \.self) { dish in
                HStack {
                    Text(dish.dishName).padding(.leading)
                    Spacer()
                    Text("x \(dish.dishAmount)").padding(.trailing)
                }.foregroundColor(.white)
                    .onTapGesture(count: 2) {
                        print("Remove orders")
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            print("iPad")
                        } else {
                            print("iPhone")
                        }
                    }
            }
        }.padding().border(.blue).background(Color.secondary)
    }
    
}


struct KitchenView_Previews: PreviewProvider {
    static var previews: some View {
        // mocking orders in progress object, it does not exist another way
        // to represent @observedobject, because in the preview view, is not used
        // connection with firebase
        let progress = OrdersInProgress()
//        progress.tabledishesDict["table1"] = [Dish2(dishName: "Classic Curry Wurst", dishAmount: 2),
//                                              Dish2(dishName: "Kult Curry Wurst", dishAmount: 1),
//                                              Dish2(dishName: "Pommes", dishAmount: 3)]
//        progress.tabledishesDict["table2"] = [Dish2(dishName: "Wild Bradwurst", dishAmount: 1)]
        
        Group {
            KitchenView(progress: progress).previewDevice("iPhone SE (3rd generation)").previewDisplayName("iPhone SE 3rd")
            KitchenView(progress: progress).previewDevice("iPad Pro (12.9-inch) (4th generation)").previewDisplayName("iPad Pro 12.9")
        }
    }
    
    
}
