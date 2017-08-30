//
//  ViewController.swift
//  FirstARSample
//
//  Created by Gabriel Rodrigues on 29/08/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

struct CameraCoordinates {
    var x = Float()
    var y = Float()
    var z = Float()
}

class ViewController: UIViewController {

    @IBOutlet weak var ARsceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        ARsceneView.session.run(configuration)
        
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> CameraCoordinates {
        
        let cameraTransform = sceneView.session.currentFrame!.camera.transform
        let cameraCoordinatesMatrix = MDLTransform(matrix: cameraTransform)
        
        var cameraCoordinates = CameraCoordinates()
        cameraCoordinates.x = cameraCoordinatesMatrix.translation.x
        cameraCoordinates.y = cameraCoordinatesMatrix.translation.y
        cameraCoordinates.z = cameraCoordinatesMatrix.translation.z
        
        return cameraCoordinates
    }
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    @IBAction func addCube(_ sender: Any) {
        
        //Adding related to device original position
        //let zCoord = randomFloat(min: -2, max: 2)
        //cubeNode.position = SCNVector3(0,0, zCoord)
        
        //Ading related to camera position
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1,
                                                height: 0.1,
                                                length: 0.1,
                                                chamferRadius: 0))
        let _cameraCoordinates = getCameraCoordinates(sceneView: ARsceneView)
        
        cubeNode.position = SCNVector3(_cameraCoordinates.x,
                                       _cameraCoordinates.y,
                                       _cameraCoordinates.z)
        
        ARsceneView.scene.rootNode.addChildNode(cubeNode)
        
    }
    
    @IBAction func addCup(_ sender: Any) {
    }


}

