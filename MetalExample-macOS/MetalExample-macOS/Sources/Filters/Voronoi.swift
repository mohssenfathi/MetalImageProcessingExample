//
//  Voronai.swift
//  Pods
//
//  Created by Mohssen Fathi on 9/9/16.
//
//

struct VoronoiUniforms {
    var time: Float = 0.0
    var size: Float = 0.5
    var animate: Float = 0.0
}

public
class Voronoi: Filter {
    
    var uniforms = VoronoiUniforms()
    
    public var size: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }
    
    public var animate: Bool = true
    override var continuousUpdate: Bool {
        return animate
    }
    
    public init() {
        super.init(functionName: "voronoi")
    }
    
    
    override func update() {
        if self.input == nil { return }
        
        uniforms.time += 1.0/60.0
        uniforms.size = size
        uniforms.animate = animate ? 1.0 : 0.0
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<VoronoiUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
}
