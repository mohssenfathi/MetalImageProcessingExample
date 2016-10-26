import Cocoa
import Metal

open
class Picture: NSObject, MetalInput {
    
    public init(image: NSImage) {
        texture = image.texture(device: context!.device)
    }
    
    public func addOutput(_ output: MetalOutput) {
        self.output = output
        self.output?.input = self
    }
    
    public var context: MetalContext? = MetalContext()
    public var output: MetalOutput?
    public var texture: MTLTexture?
}
