//
//  Invert.metal
//  MTLImage
//
//  Created by Mohssen Fathi on 3/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void invert(texture2d<float, access::read>  inTexture  [[ texture(0) ]],
                   texture2d<float, access::write> outTexture [[ texture(1) ]],
                   uint2 gid [[thread_position_in_grid]])
{
    
    float4 color = inTexture.read(gid);
    color = float4(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, 1.0);
    outTexture.write(color, gid);
}
