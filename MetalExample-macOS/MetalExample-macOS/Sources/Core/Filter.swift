
import Metal

open
class Filter: MetalObject {
    
    public init(functionName: String) {
        super.init()
        
        self.functionName = functionName
        reload()
    }
    
    var continuousUpdate: Bool {
        return false
    }
    
    override func reload() {
        super.reload()
        
        guard let context = context else { return }
        
        guard let function: MTLFunction = context.library.makeFunction(name: functionName) else {
            print("No function named \(functionName)")
            return
        }
        
        do {
            pipeline = try context.device.makeComputePipelineState(function: function)
        }
        catch {
            print(error)
        }
        
    }
    
    override func process() {

        
        guard let context = context, let inputTexture = input?.texture else {
            return
        }

        
        /**
            Update the previous texture in the chain before we update our texture
         */
        input?.processIfNeeded()
        
        
    
        /** 
            Here we create out command buffer that will be submitted into the queue.
            This contains the encoded commands that will be executed by the GPU
         */
        let commandBuffer = context.commandQueue.makeCommandBuffer()

    
        
        /**
            The command encoder is the object we use to append commands to the command buffer
         */
        let commandEncoder = commandBuffer.makeComputeCommandEncoder()
        
        
        
        /**
            Here we tell the command encoder to add this information to the command buffer
         
            - set the current state of the compute pipeline
         
            - give it the uniform data (all the filter specific properties / values)
         
            - give it our input texture, this is the one we get from the our input property,
              the shader will then read data from this texture
         
            - set our output texture, the shader will read from 'texture', perform some calculations, 
              then write the modified data to this 'outputTexture'
         */
        commandEncoder.setComputePipelineState(pipeline)
        commandEncoder.setBuffer(uniformsBuffer, offset: 0, at: 0)
        commandEncoder.setTexture(inputTexture, at: 0)
        commandEncoder.setTexture(texture, at: 1)
        
        
        /**
            We then tell the encoder how many parallel processing to break up this computation into
        */
        let threadgroupCounts = MTLSizeMake(16, 16, 1)
        let threadgroups = MTLSizeMake(inputTexture.width / threadgroupCounts.width, inputTexture.height / threadgroupCounts.height, 1)
        commandEncoder.dispatchThreadgroups(threadgroups, threadsPerThreadgroup: threadgroupCounts)

        
        /**
            Finally, we are done encoding
         */
        commandEncoder.endEncoding()
        
        commandBuffer.addCompletedHandler { (commandBuffer) in
            if self.continuousUpdate { return }
            
            if let filter = (self.input as? Filter) {
                if filter.continuousUpdate { return }
            }
            
            self.needsUpdate = false
        }
        
        
        /**
            No processing will be done until we tell the command buffer to commit. At this point it will be added to 
            the next available slot in the commandQueue.
            Alternatively, we can call 'enqueue' to reserve a spot. Then commit later.
         */
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
    }

}
