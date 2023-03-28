//
//  CQRenderPrimitives.metal
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//#include "header.h"
//#include "CQShaderTypes.h"

typedef struct {
    vector_float2 position;
    vector_float4 color;
} CQRPVertex;

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};

vertex RasterizerData vertexShader_RP(uint vertexID [[vertex_id]],
                                   constant CQRPVertex *vertices [[buffer(0)]],
                                   constant vector_uint2 *viewportSizePointer [[buffer(1)]]) {
    
    // 像素空间坐标
    float2 pixelSpacePosition = vertices[vertexID].position.xy;
    
    // 转换为vector_float2
    vector_float2 viewportSize = vector_float2 (*viewportSizePointer);
    
    RasterizerData out;
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);
    
    out.color = vertices[vertexID].color;
    
    return  out;
}

fragment float4 fragmentShader_RP(RasterizerData in [[stage_in]]) {
    return  in.color;
}
