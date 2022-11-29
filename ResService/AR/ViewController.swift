//
//  ViewController.swift
//  ResService
//
//  Created by Mateusz Tofil on 28/11/2022.
//

import UIKit
import ARKit
import RealityKit

//class ViewController : UIViewController {
//    @IBOutlet weak var sceneView : ARSCNView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        var anchor:TestDish.
//    }
//}

class ViewController : UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView : ARSCNView!
//    let configuration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
//        super.viewDidLoad()

//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
//        self.sceneView.session.run(configuration)

        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true

        let scene = SCNScene()

        
        
//        let testScene = SCNScene(named: "TestDish.rcproject")
//        guard let testNode = testScene?.rootNode.childNode(withName: "TestDish.rcproject", recursively: true) else {
//            fatalError("model is not found")
//        }

//        testNode.position = SCNVector3(0, 0, -1.0)

//        scene.rootNode.addChildNode(testNode)

        self.sceneView.scene = scene
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.sceneView.session.pause()
    }

}
