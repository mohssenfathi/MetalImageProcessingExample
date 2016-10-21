//
//  Saturation.swift
//  Pods
//
//  Created by Mohammad Fathi on 3/10/16.
//
//

struct PolkaDotUniforms {
    var dotRadius: Float = 0.5
}

public
class PolkaDot: Filter {
    
    var uniforms = PolkaDotUniforms()
    
    public var dotRadius: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }

    public init() {
        super.init(functionName: "polkaDot")
        update()
    }
    
    override func update() {
        super.update()
        
        uniforms.dotRadius = dotRadius / 10.0
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<PolkaDotUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
}
