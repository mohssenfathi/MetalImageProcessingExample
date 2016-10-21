import Cocoa
import Metal

open
class Picture: NSObject, MetalInput {
    
    public init(image: NSImage) {
        
        internalTexture = image.texture(device: internalContext.device)
        
    }
    
    public func addOutput(_ output: MetalOutput) {
        self.output = output
        self.output?.input = self
    }
    
    var internalContext = MetalContext()
    public var context: MetalContext? {
        get {
            return internalContext
        }
    }
    
    private var internalOutput: MetalOutput?
    public var output: MetalOutput? {
        get {
            return internalOutput
        }
        set {
            internalOutput = newValue
        }
    }
    
    private var internalTexture: MTLTexture?
    public var texture: MTLTexture? {
        get {
            return internalTexture
        }
        set {
            internalTexture = newValue
        }
    }
}
