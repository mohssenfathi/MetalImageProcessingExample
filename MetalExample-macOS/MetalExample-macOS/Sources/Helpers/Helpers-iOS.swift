import Metal
import MetalKit
//
//extension UIImage {
//    
//    func texture(device: MTLDevice) -> MTLTexture? {
//        
//        let textureLoader = MTKTextureLoader(device: device)
//        
//        guard let cgImage = self.cgImage else {
//            print("Error loading CGImage")
//            return nil
//        }
//        
//        return try? textureLoader.newTexture(with: cgImage, options: nil)
//    }
//    
//}
//
//extension MTLTexture {
//    
//    func bytes() -> UnsafeMutableRawPointer? {
//        
//        guard pixelFormat == .rgba8Unorm else { return nil }
//        
//        let imageByteCount: Int = width * height * 4
//        guard let imageBytes = UnsafeMutableRawPointer(malloc(imageByteCount)) else { return nil }
//        let bytesPerRow = width * 4
//        
//        let region: MTLRegion = MTLRegionMake2D(0, 0, width, height)
//        getBytes(imageBytes, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
//        
//        return imageBytes
//    }
//    
//    func image() -> UIImage? {
//        
//        guard let imageBytes = bytes() else { return nil }
//        
//        let bytesPerRow = width * 4
//        let imageByteCount: Int = width * height * 4
//        
//        let provider = CGDataProvider(dataInfo: nil, data: imageBytes, size: imageByteCount) { (rawPointer, pointer, i) in
//            
//        }
//        
//        let bitsPerComponent = 8
//        let bitsPerPixel = 32
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue).union(.byteOrder32Big)
//        let renderingIntent = CGColorRenderingIntent.defaultIntent
//        let imageRef = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo, provider: provider!, decode: nil, shouldInterpolate: false, intent: renderingIntent)
//        
//        let image = UIImage(cgImage: imageRef!, scale: 0.0, orientation: .up)
//        
//        //        free(imageBytes)
//        
//        return image;
//    }
//    
//    func copy(device: MTLDevice) -> MTLTexture {
//        
//        let data = bytes()
//        
//        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat, width: width, height: height, mipmapped: false)
//        
//        let copy = device.makeTexture(descriptor: descriptor)
//        copy.replace(region: MTLRegionMake2D(0, 0, width, height), mipmapLevel: 0, withBytes: data!, bytesPerRow: MemoryLayout<Float>.size * width)
//        
//        return copy
//    }
//    
//}
