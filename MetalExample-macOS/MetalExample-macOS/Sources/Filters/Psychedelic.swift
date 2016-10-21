//
//  Psychedelic.swift
//  MetalExample-macOS
//
//  Created by Mohssen Fathi on 10/19/16.
//  Copyright © 2016 mohssenfathi. All rights reserved.
//

import Foundation

struct PsychedelicUniforms {
    var time: Float = 0.0
    var speed: Float = 0.5
}

class Psychedelic: Filter {

    var uniforms = PsychedelicUniforms()
    var speed: Float = 0.5
    
    override var continuousUpdate: Bool {
        return true
    }
    
    init() {
        super.init(functionName: "psychedelic")
    }
    
    override func update() {
        super.update()
        
        uniforms.time += 1.0/60.0
        uniforms.speed = speed
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<PsychedelicUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
    
}
