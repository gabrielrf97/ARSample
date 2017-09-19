/*
 Copyright (C) 2017 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Main view controller for the Interactive Content sample app.  This file manages the interactions between the view and ARKit.
 */

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	@IBOutlet weak var toast: UIVisualEffectView!
	var chameleon = Chameleon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
		
        // Set the scene to the view
        sceneView.scene = chameleon
		
		// The chameleon uses an environment map, so disable built-in lighting
		sceneView.automaticallyUpdatesLighting = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
		
		// Notify the user to move in order to find a plane
		showToast()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
	// MARK: - Gesture Recognizers
	
	@IBAction func didTap(_ recognizer: UITapGestureRecognizer) {
		let location = recognizer.location(in: sceneView)
		
		// When tapped on the object, call the object's method to react on it
		let sceneHitTestResult = sceneView.hitTest(location, options: nil)
		if !sceneHitTestResult.isEmpty {
			// We only have one content, so we know which node was hit.
			// If the scene contains multiple objects, you would need to check here if the right node was hit
			chameleon.reactToTap(in: sceneView)
			return
		}
		
		// When tapped on a plane, reposition the content
		let arHitTestResult = sceneView.hitTest(location, types: .existingPlane) // Should we use extent here?
		if !arHitTestResult.isEmpty {
			let hit = arHitTestResult.first!
			chameleon.setTransform(hit.worldTransform)
		}
	}
	
	@IBAction func didPan(_ recognizer: UIPanGestureRecognizer) {
		let location = recognizer.location(in: sceneView)
		
		// Drag the object on an infinite plane
		let arHitTestResult = sceneView.hitTest(location, types: .existingPlane)
		if !arHitTestResult.isEmpty {
			let hit = arHitTestResult.first!
			chameleon.setTransform(hit.worldTransform)
			
			if recognizer.state == .ended {
				chameleon.reactToPositionChange(in: sceneView)
			}
		}
	}

    // MARK: - ARSCNViewDelegate
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		if chameleon.isVisible() { return }
		
		// Unhide the content and position it on the detected plane
		if anchor is ARPlaneAnchor {
			chameleon.setTransform(anchor.transform)
			chameleon.show()
			chameleon.reactToInitialPlacement(in: sceneView)
			
			DispatchQueue.main.async {
				self.hideToast()
			}
		}
	}
	
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		chameleon.reactToRendering(in: sceneView)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didApplyConstraintsAtTime time: TimeInterval) {
		chameleon.reactToDidApplyConstraints(in: sceneView)
	}
}

extension ViewController {
	
	func showToast() {
		toast.layer.masksToBounds = true
		toast.layer.cornerRadius = 7.5
		toast.alpha = 0
		
		UIView.animate(withDuration: 0.25, delay: 1.5, animations: {
			self.toast.alpha = 1
			self.toast.frame = self.toast.frame.insetBy(dx: -5, dy: -5)
		})
		
	}
	
	func hideToast() {
		UIView.animate(withDuration: 0.25, animations: {
			self.toast.alpha = 0
			self.toast.frame = self.toast.frame.insetBy(dx: 5, dy: 5)
		})
	}
}
