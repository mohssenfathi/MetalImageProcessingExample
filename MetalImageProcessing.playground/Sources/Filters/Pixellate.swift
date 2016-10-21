//
//  Pixellate.swift
//  Pods
//
//  Created by Mohssen Fathi on 4/1/16.
//
//

struct PixellateUniforms {
    var dotRadius: Float = 0.5;
    var fractionalWidthOfPixel: Float = 0.02
}

public
class Pixellate: Filter {

    var uniforms = PixellateUniforms()
    
    public var dotRadius: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }
    
    public init() {
        super.init(functionName: "pixellate")
    }
    
    override func update() {
        
        uniforms.dotRadius = dotRadius
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<PixellateUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
    
}
