import Cocoa
import MetalKit

public
extension NSImage {
    
    public func texture(device: MTLDevice) -> MTLTexture? {
        
        let textureLoader = MTKTextureLoader(device: device)
        
        var imageRect = CGRect(origin: .zero, size: size)
        guard let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return nil
        }
        
        let options = [ MTKTextureLoaderOptionSRGB : NSNumber(value: false) ]
        
        return try? textureLoader.newTexture(with: cgImage, options: options)
    }

}

public
extension MTLTexture {
    
    func bytes() -> UnsafeMutableRawPointer? {
        
        //guard pixelFormat == .bgra8Unorm_srgb else { return nil }
        
        let imageByteCount: Int = width * height * 4
        guard let imageBytes = UnsafeMutableRawPointer(malloc(imageByteCount)) else { return nil }
        let bytesPerRow = width * 4
        
        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
        getBytes(imageBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        return imageBytes
    }
    
    public func image() -> NSImage? {

        guard let imageBytes = bytes() else { return nil }
        
        let bytesPerRow = width * 4
        let imageByteCount: Int = width * height * 4

        let provider = CGDataProvider(dataInfo: nil, data: imageBytes, size: imageByteCount) { (rawPointer, pointer, i) in

        }

        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue).union(.byteOrder32Little)
        let renderingIntent = CGColorRenderingIntent.defaultIntent
        let imageRef = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: false, intent: renderingIntent)

        let image = NSImage(cgImage: imageRef!, size: NSSize(width: width, height: height))
        print(image.size)
            
        return image;
    }
    
    func copy(device: MTLDevice) -> MTLTexture {
        
        let data = bytes()
        
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat, width: width, height: height, mipmapped: false)
        
        let copy = device.makeTexture(descriptor: descriptor)
        copy.replace(region: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0, withBytes: data!, bytesPerRow: MemoryLayout<Float>.size * width)
        
        return copy
    }
    
}


//    MARK: - Operator Overloading

precedencegroup ChainPrecedence {
    associativity: left
}

infix operator --> : ChainPrecedence

@discardableResult
public func --> (left: MetalInput , right: MetalOutput) -> MetalOutput {
    left.addOutput(right)
    return right
}

@discardableResult
public func --> (left: MetalInput , right: MetalObject) -> MetalObject {
    left.addOutput(right)
    return right
}

@discardableResult
public func --> (left: MetalObject, right: MetalObject) -> MetalObject {
    left.addOutput(right)
    return right
}

@discardableResult
public func --> (left: MetalObject, right: MetalOutput) {
    left.addOutput(right)
}

@discardableResult
public func + (left: MetalInput, right: MetalOutput) {
    left.addOutput(right)
}

@discardableResult
public func > (left: MetalInput, right: MetalOutput) {
    left.addOutput(right)
}
