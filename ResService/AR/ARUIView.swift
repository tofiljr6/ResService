//
//  ARUIView.swift
//  ResService
//
//  Created by Mateusz Tofil on 29/11/2022.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ARUIView: View {
    @State private var isPlacmentEnabled = false
    @State private var selectedModel : Model?
    @State private var modelConfirmedForPlacement : Model?
    
    private var models: [Model] = {
       // dynamically get out model filenames
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path) else { return [] }
        print(files)
        var availableModels: [Model] = []
        for file in files where file.hasSuffix("usdz") {
            let modelName = file.replacingOccurrences(of: ".usdz", with: "")
            
            let model = Model(modelName: modelName)
            
            availableModels.append(model)
        }
        print(availableModels)

        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement).ignoresSafeArea()
            if self.isPlacmentEnabled {
                PlacementButtonView(isPlacmentEnabled: self.$isPlacmentEnabled, selectedModel: self.$selectedModel, modelConfirmedForPlacemnet: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacmentEnabled: self.$isPlacmentEnabled, selectedModel: self.$selectedModel, models: self.models)
            }
        }
    }
}

struct ARViewContainer : UIViewRepresentable {
    @Binding var modelConfirmedForPlacement : Model?
    
    func makeUIView(context: Context) -> some ARView {
        let arView = CustomARView(frame: .zero)// ARView(frame: .zero)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            if let modelEntity = model.modelEntity {
                print("DEBUG: adding model to scene - \(model.modelName)")
                
                let anchorrEntity = AnchorEntity(plane: .any)
                anchorrEntity.addChild(modelEntity.clone(recursive: true))
                
                uiView.scene.addAnchor(anchorrEntity)
            } else {
                print("DEBUG: unable to load modelEntity for - \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
}


class CustomARView : ARView {
    let focusSquare = FESquare()
    
    required init(frame frameRect : CGRect) {
        super.init(frame: frameRect)
        
        focusSquare.viewDelegate = self
        focusSquare.delegate = self
        focusSquare.setAutoUpdate(to: true)
        
        self.setupARView()
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
}

extension CustomARView : FEDelegate {
    func toTrackingState() {
        print("tracking")
    }
    
    func toInitializingState() {
        print("init")
    }
}


struct PlacementButtonView : View {
    @Binding var isPlacmentEnabled : Bool
    @Binding var selectedModel : Model?
    @Binding var modelConfirmedForPlacemnet : Model?
    
    var body: some View {
        HStack {
            // cancel
            Button {
                print("DEBUG: cancel model placment")
                self.reserPlacmentParameters()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.red.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }

            // confrim
            Button {
                print("DEBUG: confirm model placment")
                self.modelConfirmedForPlacemnet = self.selectedModel
                self.reserPlacmentParameters()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.green.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
        }
    }
    
    func reserPlacmentParameters() {
        self.isPlacmentEnabled = false
        self.selectedModel = nil
    }
}


struct ModelPickerView: View {
    @Binding var isPlacmentEnabled : Bool
    @Binding var selectedModel : Model?
    var models : [Model]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) { index in
                    Button {
                        print("DEBUG: model name: \(self.models[index].modelName)")
                        self.isPlacmentEnabled = true
                        
                        self.selectedModel = self.models[index]
                    } label: {
//                        Image(self.models[index].image)
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(5)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }.padding(20)
        .foregroundColor(.green.opacity(0.5))
    }
}


struct ARUIView_Previews: PreviewProvider {
    static var previews: some View {
        ARUIView()
    }
}
 
