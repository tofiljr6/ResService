//
//  OrderCardView.swift
//  ResService
//
//  Created by Mateusz Tofil on 22/10/2022.
//

import SwiftUI

struct OrderCardView: View {
    let orderInfo: Order
    let dishes : [Dish]
    private let dataString : String
    var color: Color
    
    init(orderInfo: Order, dishes: [Dish], color : Color) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateFromString = dateFormatter.date(from: orderInfo.data)
        dateFormatter.dateFormat = "HH:mm"
        let newDate = dateFormatter.string(from: dateFromString!)
        
        self.dataString = newDate
        self.dishes = dishes
        self.orderInfo = orderInfo
        self.color = color
    }
    
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("Order #\(self.orderInfo.orderNumber)")
                    Spacer()
                    Text("\(self.dataString)")
                }.font(.title)
                HStack {
                    Text("Table: \(self.orderInfo.table)").foregroundColor(.white)
                    Spacer()
                }
            }
            Divider()
            
            ForEach(dishes, id: \.self) { dish in
                HStack {
                    Text(dish.dishName).padding(.leading)
                    Spacer()
                    Text("x\(dish.dishAmount)").padding(.trailing)
                }.font(.title2)
            }
        }.padding()
            .background(self.color)
            .cornerRadius(10)
            .frame(maxWidth: 400)
    }
}

struct OrderCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderCardView(orderInfo: Order(data: Date.now.formatted(), table: "3", orderNumber: 2),
                          dishes: [Dish(dishName: "classic", dishAmount: 2)], color: .green)
        }
    }
}
