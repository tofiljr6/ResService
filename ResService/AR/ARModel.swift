//
//  ARModel.swift
//  ResService
//
//  Created by Mateusz Tofil on 29/11/2022.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName : String
    var image : UIImage
    var modelEntity : ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
    
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename).sink(receiveCompletion: { loadCompletion in
            // handle out error
            print("DEBUG: Unable to load modelEnityt for modelName \(self.modelName)")
        }, receiveValue: { modelEntity in
            // get our modelEntity
            self.modelEntity = modelEntity
            print("DEBUG: Successfully loaded modelEnity for modelName \(self.modelName)")
        })
    }
}
