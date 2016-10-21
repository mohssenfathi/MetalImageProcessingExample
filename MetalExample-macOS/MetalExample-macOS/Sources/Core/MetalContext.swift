import Metal

public
class MetalContext: NSObject {
    
    var device: MTLDevice!
    var library: MTLLibrary!
    var commandQueue: MTLCommandQueue!
    
    override init() {
        super.init()
        
        setup()
    }
    
    func setup() {
        
        //  1. Create the MTLDevice
        
        device = MTLCreateSystemDefaultDevice()
        
        
        //  2. Check to make sure our device supports Metal
        
        guard device != nil else {
            fatalError("No devices found")
        }
        
        #if os(tvOS)
            guard device.supportsFeatureSet(.tvOS_GPUFamily1_v1) else {
                fatalError("Device does not support Metal")
            }
        #elseif os(iOS)
            guard device.supportsFeatureSet(.iOS_GPUFamily1_v1) else {
                fatalError("Device does not support Metal")
            }
        #elseif os(OSX)
            guard device.supportsFeatureSet(.osx_GPUFamily1_v1) else {
                fatalError("Device does not support Metal")
            }
        #endif
        
        
        
        //  3. Create a library to hold all of the Metal functions
        
        library = device.newDefaultLibrary()
        guard library != nil else {
            fatalError("Could not create Metal Library")
        }
        

        //  4. Create our queue for submitting command buffers to the MTLDevice

        self.commandQueue = self.device.makeCommandQueue()
        
    }
    
}
