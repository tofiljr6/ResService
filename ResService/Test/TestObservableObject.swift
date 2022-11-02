//
//  TestObservableObject.swift
//  ResService
//
//  Created by Mateusz Tofil on 19/10/2022.
//

import Foundation

class TestObservalbeObject : ObservableObject {
    @Published var testnumber :  Int
    
    init() {
        #if PREVIEW
        self.testnumber = -123
        #else
        self.testnumber = 12334144123412
        #endif
    }
    
}
