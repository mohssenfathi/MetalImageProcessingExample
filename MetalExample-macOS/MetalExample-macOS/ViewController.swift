//
//  ViewController.swift
//  MetalExample-macOS
//
//  Created by Mohssen Fathi on 10/13/16.
//  Copyright © 2016 mohssenfathi. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var metalView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Picture(image: #imageLiteral(resourceName: "frog")) --> Psychedelic() --> metalView
        
        
    }

}

