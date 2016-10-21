//
//  SobelEdgeDetection.swift
//  Pods
//
//  Created by Mohssen Fathi on 4/8/16.
//
//

struct SobelEdgeDetectionUniforms {
    var edgeStrength: Float = 0.5;
}

public
class SobelEdgeDetection: Filter {
    
    var uniforms = SobelEdgeDetectionUniforms()
    
    public var edgeStrength: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }
    
    public init() {
        super.init(functionName: "sobelEdgeDetection")
    }
    
    override func update() {

        uniforms.edgeStrength = edgeStrength * 3.0 + 0.2
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<SobelEdgeDetectionUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
    
}

