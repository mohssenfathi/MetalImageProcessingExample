//
//  Psychedelic.metal
//  MetalExample-macOS
//
//  Created by Mohssen Fathi on 10/19/16.
//  Copyright © 2016 mohssenfathi. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct PsychedelicUniforms {
    float time;
    float speed;
};

constant float4  kRGBToYPrime = float4 (0.299, 0.587, 0.114, 0.0);
constant float4  kRGBToI      = float4 (0.595716, -0.274453, -0.321263, 0.0);
constant float4  kRGBToQ      = float4 (0.211456, -0.522591, 0.31135, 0.0);

constant float4  kYIQToR   = float4 (1.0, 0.9563, 0.6210, 0.0);
constant float4  kYIQToG   = float4 (1.0, -0.2721, -0.6474, 0.0);
constant float4  kYIQToB   = float4 (1.0, -1.1070, 1.7046, 0.0);

kernel void psychedelic(texture2d<float, access::read>  inTexture  [[ texture(0) ]],
                        texture2d<float, access::write> outTexture [[ texture(1) ]],
                        constant PsychedelicUniforms &uniforms     [[ buffer(0)  ]],
                        uint2 gid                                  [[thread_position_in_grid]])
{
    
    float4 color = inTexture.read(gid);

    float YPrime = dot(color, kRGBToYPrime);
    float I      = dot(color, kRGBToI);
    float Q      = dot(color, kRGBToQ);
    
    float hue    = atan2(Q, I);
    float chroma = sqrt (I * I + Q * Q);
    
    float h = fmod(uniforms.time, 360.0) * (6.0 * uniforms.speed);
    hue -= h;
    
    Q = chroma * sin (hue);
    I = chroma * cos (hue);
    
    float4 yIQ = float4(YPrime, I, Q, 0.0);
    color.r = dot (yIQ, kYIQToR);
    color.g = dot (yIQ, kYIQToG);
    color.b = dot (yIQ, kYIQToB);
    
    outTexture.write(color, gid);
}
