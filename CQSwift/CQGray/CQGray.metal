//
//  CQGray.metal
//  CQSwift
//
//  Created by llbt2019 on 2022/12/5.
//  Copyright © 2022 李超群. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//precision highp float; // 精度
//varying lowp vec2 varyTextCoord;//纹理坐标
//uniform sampler2D colorMap;//纹理数据

typedef struct {
    vector_float4  position;
    vector_float4  color;
} VertexInput;

typedef struct {
    //处理空间的顶点信息
    float4 clipSpacePosition [[position]];
    float4 color;
} VertexOut;

vertex VertexOut vertexShader_gray(uint vertexID [[vertex_id]],
                              constant VertexInput *input [[buffer(0)]]) {
    //1.执行坐标系转换，将生成的顶点剪辑空间写入到返回值中。
    //2.将顶点颜色值传递给返回值。
    VertexOut out;
    out.clipSpacePosition = input[vertexID].position;
    out.color = input[vertexID].color;
    return out;
}

fragment float4 fragmentShader_gray(VertexOut in [[stage_in]]) {
    return in.color;
}
