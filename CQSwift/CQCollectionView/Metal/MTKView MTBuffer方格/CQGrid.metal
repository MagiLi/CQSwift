//
//  CQGrid.metal
//  CQSwift
//
//  Created by llbt2019 on 2020/8/25.
//  Copyright © 2020 李超群. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct {
    vector_float4  position;
    vector_float4  color;
} VertexInput;

struct VertexOut {
    float4 clipSpacePosition [[position]];
    float4 color;
};

vertex VertexOut vertexShaderGrid(uint vertexIndex [[vertex_id]],
                              constant VertexInput *vertexInput [[buffer(0)]],
                              constant vector_uint2 *viewportSizePointer [[buffer(1)]]) {
    //取出顶点坐标的xy，该案例中的位置是在像素维度中指定的。
    float2 pixelSpacePosition = vertexInput[vertexIndex].position.xy;
    //视口
    vector_float2 viewportSize = vector_float2 (*viewportSizePointer);
    //每个顶点着色器的输出位置在 剪辑空间中（也称为归一化设备坐标空间，NDC坐标空间）。
    //剪辑空间的（-1，-1）表示视口的左下角，剪辑空间的（1，1）表示视口的右上角。
    //为了从像素空间中的位置转换到剪辑空间的位置，我们将像素坐标除以视口大小的一半。
    float2 xy = pixelSpacePosition / (viewportSize / 2.0);
    
    VertexOut out;
    out.clipSpacePosition.xy = xy;
    out.color = vertexInput[vertexIndex].color;
    return out;
}

fragment float4 fragmentShaderGrid(VertexOut in [[stage_in]]) {
    return in.color;
}
