//
//  ViewController.swift
//  FirstARSample
//
//  Created by Gabriel Rodrigues on 20/09/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        //Creating SCNScene, responsible for handling 3D Objects
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        //Creating Sphere Material
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "earth")
        //Creating Sphere Geometry
        let sphere = SCNSphere(radius: 0.1)
        sphere.materials = [sphereMaterial]
        //Creating Sphere Node
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3(0.0, 0.0, -0.5)
        //Adding sphere node to the scene
        scene.rootNode.addChildNode(sphereNode)
        scene.rootNode.addChildNode(sphereNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
