import Metal

public protocol MetalInput {

    var output: MetalOutput? { get set }
    var texture: MTLTexture? { get set }
    var context: MetalContext? { get }
    
    func addOutput(_ output: MetalOutput)
    func processIfNeeded()
}

public protocol MetalOutput {
    
    var input: MetalInput? { get set }
    
}

open class MetalObject {
    
    var functionName: String!
    var pipeline: MTLComputePipelineState!
    var uniformsBuffer: MTLBuffer?
    var needsUpdate = true
    
    public var output: MetalOutput?
    
    public var texture: MTLTexture?
    
    public var input: MetalInput? {
        didSet {
        
            /** 
                Our input has changed, so we want to make a new output texture with the same properties as our input's texture
             */

            if let inputTexture = input?.texture {
                let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: inputTexture.pixelFormat,
                                                                                 width: inputTexture.width,
                                                                                 height: inputTexture.height,
                                                                                 mipmapped: false)
                
                texture = context?.device?.makeTexture(descriptor: textureDescriptor)
            }
            
            reload()

        }
    }
    
    
    
    // MARK: - Subclassing
    
    func update() {

    }
    
    func process() {

    }
    
    func reload() {

    }
    
}

extension MetalObject: MetalOutput { }

extension MetalObject: MetalInput {
    
   
    public func processIfNeeded() {
        if needsUpdate {
            update()
            process()
        }
    }
    
    public var context: MetalContext? {
        return input?.context
    }
    
    public func addOutput(_ output: MetalOutput) {
        self.output = output
        self.output?.input = self
    }
    
}


// Default Implementation
extension MetalInput {
    public func processIfNeeded() { }
}
