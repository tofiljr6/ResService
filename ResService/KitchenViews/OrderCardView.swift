//
//  OrderCardView.swift
//  ResService
//
//  Created by Mateusz Tofil on 22/10/2022.
//

import SwiftUI

struct OrderCardView: View {
    let date : String
    let orderID : Int
    let dishes : [Dish2]
    
    init(date: String, orderID: Int, dishes: [Dish2]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, hh:mm a"
        let dateFromString = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let newDate = dateFormatter.string(from: dateFromString!)
        
        self.date = newDate
        self.orderID = orderID
        self.dishes = dishes
    }
    
    var body: some View {
        VStack {
            HStack{
                Text("Order #\(orderID)")
                Spacer()
                Text("\(date)")
            }.font(.title)
            Divider()
            
            ForEach(dishes, id: \.self) { dish in
                HStack {
                    Text(dish.dishName).padding(.leading)
                    Spacer()
                    Text("x\(dish.dishAmount)").padding(.trailing)
                }.font(.title2)
            }
        }.padding().background(.green)
    }
}

struct OrderCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderCardView(date: Date.now.formatted(),
                          orderID: 1,
                          dishes: [Dish2(dishName: "classic", dishAmount: 2)])
        }
    }
}
