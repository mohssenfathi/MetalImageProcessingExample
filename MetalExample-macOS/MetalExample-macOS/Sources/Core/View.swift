import Foundation
import MetalKit

public
class View: MTKView, MetalOutput {
    
    public init(frame frameRect: CGRect) {
        super.init(frame: frameRect, device: nil)
        setup()
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {

        device = input?.context?.device
        delegate = self
        framebufferOnly = false
        autoResizeDrawable = false
        layerContentsPlacement = .scaleProportionallyToFit
        layer?.isOpaque = false
    }
    
    public var input: MetalInput? {
        didSet {
            device = input?.context?.device
            
            if let texture = input?.texture {
                drawableSize = CGSize(width: texture.width, height: texture.height)
            }
        }
    }
}


extension View: MTKViewDelegate {
    
    public func draw(in view: MTKView) {
        
        /**
            Ask our input to update its texture before we use it
         */
        input?.processIfNeeded()
        
        
        
        /**
            Get out common command queue for submitting buffers to the MTLDevice/GPU
         */
        guard let commandQueue = input?.context?.commandQueue else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        
        
        /**
            Here we get out input texture and out drawable (contains our output texture).
            We then just need to copy our input texture into the drawable's texture property/
         */
        guard let texture = input?.texture, let drawable = view.currentDrawable else {
            return
        }
        
        
        
        /**
            A Blit encoder is used to copy our final modified texture to the MTKView's drawable texture.
            Not the most efficient way of doing this, but pretty easy...
         */
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()
        
        blitEncoder.copy(from: texture, sourceSlice: 0, sourceLevel: 0,
                         sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                         sourceSize: MTLSize(width: texture.width, height: texture.height, depth: texture.depth),
                         to: drawable.texture, destinationSlice: 0, destinationLevel: 0,
                         destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
        
        blitEncoder.endEncoding()
        
        
        
        /**
            We are done encoding commands to out command buffer. We call commit to append it to the command queue
         */
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }

}
