//
//  CQCalculations.metal
//  CQSwift
//
//  Created by llbt2019 on 2023/3/22.
//  Copyright © 2023 李超群. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


kernel void array_add(device const float* bufferA,
                                    device const float* bufferB,
                                    device float* bufferR,
                                    uint index [[thread_position_in_grid]]) {
    
    
    bufferR[index] = bufferA[index] + bufferB[index];
}
