//
//  ViewController.swift
//  camera-example
//
//  Created by Chris Maier on 4/21/20.
//  Copyright © 2020 Chris Maier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GiphyUISDK
import GiphyCoreSDK

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GIPHY", for: .normal)
        return button
    }()
    
    let themeSwitch: UISwitch = {
        let themeSwitch = UISwitch()
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        themeSwitch.isOn = false
        return themeSwitch
    }()
    
    let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl()
        view.insertSegment(withTitle: "three", at: 0, animated: false)
        view.insertSegment(withTitle: "four", at: 1, animated: false)
        view.selectedSegmentIndex = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        Giphy.configure(apiKey: "seS4IYKG394vOOwIx9ZreC55Tit5cMbe")
        
        
        view.addSubview(button)
        let padding: CGFloat = 20.0
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        button.addTarget(self, action: #selector(presentGiphy), for: .touchUpInside)
        
        view.addSubview(themeSwitch)
        themeSwitch.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        themeSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true
        themeSwitch.thumbTintColor = .gray
         
        view.addSubview(segmentedControl)
        segmentedControl.tintColor = .gray
        segmentedControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
    @objc func presentGiphy() {
        let giphy = GiphyViewController()
        giphy.theme = GPHTheme(type: themeSwitch.isOn ? .darkBlur : .lightBlur)
        giphy.mediaTypeConfig = [.stickers, .text]
        giphy.enableDynamicText = true 
        let threeColumns = segmentedControl.selectedSegmentIndex == 0
        giphy.stickerColumnCount = threeColumns ? .three : .four
        present(giphy, animated: true, completion: nil)
        giphy.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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


extension ViewController: GiphyDelegate {
    
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            let url = media.url(rendition: giphyViewController.renditionType, fileType: .webp) ?? ""
            GPHCache.shared.downloadAsset(url) { (image, error) in
                DispatchQueue.main.async {
                    let imageView = GiphyYYAnimatedImageView()
                    let width = CGFloat(media.images?.fixedWidth?.width ?? 0)
                    let height = CGFloat(media.images?.fixedWidth?.height ?? 0)
                    imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                    let geo = SCNPlane(width: 0.2, height: 0.2 * width / height)
                    geo.firstMaterial?.diffuse.contents = imageView
                    imageView.backgroundColor = .clear
                    let node = SCNNode(geometry: geo)
                    node.position = self?.sceneView.pointOfView?.position ?? SCNVector3Zero
                    node.eulerAngles = self?.sceneView.pointOfView?.eulerAngles ?? SCNVector3Zero
                    self?.sceneView.scene.rootNode.addChildNode(node)
                    imageView.image = image
                }
                
            }
        })
    }
    
    func didDismiss(controller: GiphyViewController?) {
    }
}


