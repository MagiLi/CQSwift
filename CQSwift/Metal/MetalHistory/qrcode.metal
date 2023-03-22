//
//  qrcode.metal
//  CQSwift
//
//  Created by 李超群 on 2019/10/21.
//  Copyright © 2019 李超群. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn
{
    packed_float3  position;
    packed_float2  uv;
};

struct VertexOut
{
    float4  position [[position]];
    float2  uv;
};

struct Uniforms
{
    int colorCount;
};

/*
 Metal中Vertex Shader的入口方法需要以 vertex开头，本文的入口方法如下。
 它做的事情很简单，接受传递进来的顶点数据，包括位置和uv，然后原封不动的传递给Fragment Shader。
 我们在主程序中将顶点数据绑定到了缓冲区0，所以顶点数据参数后面使用[[ buffer(0) ]]标记。
 */
vertex VertexOut passThroughVertex(uint vid [[ vertex_id ]],
                                   const device VertexIn* vertexIn [[ buffer(0) ]])
{
    VertexOut outVertex;
    VertexIn inVertex = vertexIn[vid];
    outVertex.position = float4(inVertex.position, 1.0);
    outVertex.uv = inVertex.uv;
    return outVertex;
};

constexpr sampler s(coord::normalized, address::repeat, filter::linear);

/*
 Fragment Shader以fragment开头，接受了3个参数，二维码纹理diffuse，渐变色数组colors，渐变色个数uniform.colorCount。
 我们还申明了一个sampler，用来对纹理进行采样。
 */
fragment float4 passThroughFragment(VertexOut inFrag [[stage_in]],
                                   texture2d<float> diffuse [[ texture(0) ]],
                                    const device packed_float3* colors [[ buffer(0) ]],
                                    const device Uniforms& uniform [[ buffer(1) ]])
{
    int colorCount = uniform.colorCount;
    float colorEffectRange = 1.0 / (colorCount - 1.0);
    float3 gradientColor = float3(0.0);
    int colorZoneIndex = inFrag.uv.y / colorEffectRange;
    
    //计算当前像素的取色，首先计算出当前像素点在渐变色的哪一段
    colorZoneIndex = colorZoneIndex >= colorCount - 1 ? colorCount - 2 : colorZoneIndex;
    
    //根据像素在这一段的位置，使用两端的颜色计算最终的像素颜色
    float effectFactor = (inFrag.uv.y - colorZoneIndex * colorEffectRange) / colorEffectRange;
    gradientColor = colors[colorZoneIndex] * (1.0 - effectFactor) + colors[colorZoneIndex + 1] * effectFactor;
    // 取出二维码的颜色，如果二维码是偏白色的就直接忽略这个像素，这样就会显示主程序里配置的清除色clearColor
    float4 qrcodeColor = diffuse.sample(s, inFrag.uv);
    //反之，直接返回计算出来的渐变色。我使用r > 0.5来判断是不是白色像素。
    //白色的部分被替换为clearColor，黑色部分变成对应的渐变色。
    if (qrcodeColor.r > 0.5) {
        discard_fragment();
    } else {
        return float4(gradientColor, 1.0);
    }
};
