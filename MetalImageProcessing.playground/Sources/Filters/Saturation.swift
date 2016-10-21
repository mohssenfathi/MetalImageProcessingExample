import Foundation

struct SaturationUniforms {
    var saturation: Float = 0.5
}

class Saturation: Filter {
 
    var uniforms = SaturationUniforms()
    
    var saturation: Float = 0.5 {
        didSet {
            needsUpdate = true
        }
    }
    
    init() {
        super.init(functionName: "saturation")
    }
    
    override func update() {
        super.update()
        
        uniforms.saturation = saturation
        
        uniformsBuffer = context?.device.makeBuffer(bytes: &uniforms,
                                                    length: MemoryLayout<SaturationUniforms>.size,
                                                    options: .cpuCacheModeWriteCombined)
    }
}
