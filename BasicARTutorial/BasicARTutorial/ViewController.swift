//
//  ViewController.swift
//  BasicARTutorial
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
        
        createScene()
    }
    
    func createScene(){
        let scene = SCNScene()
        sceneView.scene = scene
        
        let world = SCNSphere(radius: 0.2)
        let worldMaterial = SCNMaterial()
        worldMaterial.diffuse.contents = UIImage(named: "earth-1")
        world.materials = [worldMaterial]
        let worldNode = SCNNode(geometry: world)
        worldNode.position = SCNVector3(0.0, 0.1, -0.8)
        
        scene.rootNode.addChildNode(worldNode)
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
