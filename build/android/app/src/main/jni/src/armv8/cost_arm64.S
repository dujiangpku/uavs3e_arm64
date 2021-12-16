/**************************************************************************************
 * Copyright (c) 2018-2020 ["Peking University Shenzhen Graduate School",
 *   "Peng Cheng Laboratory", and "Guangdong Bohua UHD Innovation Corporation"]
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *    This product includes the software uAVS3d developed by
 *    Peking University Shenzhen Graduate School, Peng Cheng Laboratory
 *    and Guangdong Bohua UHD Innovation Corporation.
 * 4. Neither the name of the organizations (Peking University Shenzhen Graduate School,
 *    Peng Cheng Laboratory and Guangdong Bohua UHD Innovation Corporation) nor the
 *    names of its contributors may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * For more information, contact us at rgwang@pkusz.edu.cn.
 **************************************************************************************/

#include "def_arm64.S"

#if defined(__arm64__)
#if !COMPILE_10BIT

#else
//void uavs3e_get_sad_4_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_4_arm64
    lsl w1, w1, #1
    lsl w3, w3, #1

    movi v16.16b, #0
get_sad_4_y:
    //load org
    ld1 {v0.d}[0], [x0], x1
    ld1 {v0.d}[1], [x0], x1
    ld1 {v1.d}[0], [x0], x1
    ld1 {v1.d}[1], [x0], x1
    //load pred
    ld1 {v2.d}[0], [x2], x3
    ld1 {v2.d}[1], [x2], x3
    ld1 {v3.d}[0], [x2], x3
    ld1 {v3.d}[1], [x2], x3
    uabd v0.8h, v0.8h, v2.8h
    uabd v1.8h, v1.8h, v3.8h

    uaddl v2.4s, v0.4h, v1.4h
    uaddl2 v3.4s, v0.8h, v1.8h
    add v0.4s, v2.4s, v3.4s
    add v16.4s, v0.4s, v16.4s
    subs w4, w4, #4
    bgt get_sad_4_y

    addp v16.4s, v16.4s, v16.4s
    addp v16.4s, v16.4s, v16.4s
    mov x0, #0
    umov w0, v16.s[0]

    ret

//void uavs3e_get_sad_8_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_8_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v16.16b, #0

get_sad_8_y:
    //load org
    ld1 {v0.8h}, [x0], x1
    ld1 {v1.8h}, [x0], x1
    ld1 {v2.8h}, [x0], x1
    ld1 {v3.8h}, [x0], x1
    //load pred
    ld1 {v4.8h}, [x2], x3
    ld1 {v5.8h}, [x2], x3
    ld1 {v6.8h}, [x2], x3
    ld1 {v7.8h}, [x2], x3
    uabd v0.8h, v0.8h, v4.8h
    uabd v1.8h, v1.8h, v5.8h
    uabd v2.8h, v2.8h, v6.8h
    uabd v3.8h, v3.8h, v7.8h
    uaddl v17.4s, v0.4h, v1.4h
    uaddl2 v18.4s, v0.8h, v1.8h
    uaddl v19.4s, v2.4h, v3.4h
    uaddl2 v20.4s, v2.8h, v3.8h
    add v17.4s, v17.4s, v18.4s
    add v19.4s, v19.4s, v20.4s
    add v17.4s, v17.4s, v19.4s
    add v16.4s, v16.4s, v17.4s
    subs w4, w4, #4
    bgt get_sad_8_y

    addp v16.4s, v16.4s, v16.4s
    addp v16.4s, v16.4s, v16.4s

    mov x0, #0
    umov w0, v16.s[0]

ret

//void uavs3e_get_sad_16_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_16_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v26.16b, #0

get_sad_16_y:
    ld1 {v0.8h, v1.8h}, [x0], x1
    ld1 {v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h}, [x0], x1
    ld1 {v6.8h, v7.8h}, [x0], x1
    //load pred
    ld1 {v16.8h, v17.8h}, [x2], x3
    ld1 {v18.8h, v19.8h}, [x2], x3
    ld1 {v20.8h, v21.8h}, [x2], x3
    ld1 {v22.8h, v23.8h}, [x2], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s
    subs w4, w4, #4
    bgt get_sad_16_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s

    mov x0, #0
    umov w0, v26.s[0]

    ret

//void uavs3e_get_sad_32_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_32_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v26.16b, #0

get_sad_32_y:
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x0], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x2], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x2], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s
    subs w4, w4, #2
    bgt get_sad_32_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s

    mov x0, #0
    umov w0, v26.s[0]

    ret

//void uavs3e_get_sad_64_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_64_arm64
    lsl x1, x1, #1      //i_org
    lsl x3, x3, #1
    lsl x7, x1, #1      //2 * i_org
    lsl x8, x3, #1
    movi v26.16b, #0

get_sad_64_y:
    mov x5, x0
    mov x6, x2

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x5, x0, #64
    add x6, x2, #64

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x0, x0, x7
    add x2, x2, x8

    subs w4, w4, #2
    bgt get_sad_64_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s

    mov x0, #0
    umov w0, v26.s[0]

    ret

//void uavs3e_get_sad_128_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_sad_128_arm64
    lsl x1, x1, #1      //i_org
    lsl x3, x3, #1      //i_pred
    lsl x7, x1, #1      //2 * i_org
    lsl x8, x3, #1      //i_pred
    movi v26.16b, #0

get_sad_128_y:
    mov x5, x0
    mov x6, x2

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x5, x0, #64
    add x6, x2, #64

    //load p_org + 64
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x5, x0, #128
    add x6, x2, #128

    //load p_org + 128
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x5, x0, #192
    add x6, x2, #192

    //load p_org + 196
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x5], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x5], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x6], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x6], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    uaddl v24.4s, v0.4h, v1.4h
    uaddl2 v25.4s, v0.8h, v1.8h
    add v0.4s, v24.4s, v25.4s
    uaddl v24.4s, v2.4h, v3.4h
    uaddl2 v25.4s, v2.8h, v3.8h
    add v1.4s, v24.4s, v25.4s
    uaddl v24.4s, v4.4h, v5.4h
    uaddl2 v25.4s, v4.8h, v5.8h
    add v2.4s, v24.4s, v25.4s
    uaddl v24.4s, v6.4h, v7.4h
    uaddl2 v25.4s, v6.8h, v7.8h
    add v3.4s, v24.4s, v25.4s

    add v0.4s, v0.4s, v1.4s
    add v2.4s, v2.4s, v3.4s
    add v0.4s, v0.4s, v2.4s
    add v26.4s, v26.4s, v0.4s

    add x0, x0, x7
    add x2, x2, x8

    subs w4, w4, #2
    bgt get_sad_128_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s

    mov x0, #0
    umov w0, v26.s[0]

    ret

//void uavs3e_get_ssd_4_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_4_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v16.16b, #0

get_ssd_4_y:
    //load p_org
    ld1 {v0.4h}, [x0], x1
    ld1 {v1.4h}, [x0], x1
    ld1 {v2.4h}, [x0], x1
    ld1 {v3.4h}, [x0], x1
    //load pred
    ld1 {v4.4h}, [x2], x3
    ld1 {v5.4h}, [x2], x3
    ld1 {v6.4h}, [x2], x3
    ld1 {v7.4h}, [x2], x3

    uabd v0.4h, v0.4h, v4.4h
    uabd v1.4h, v1.4h, v5.4h
    uabd v2.4h, v2.4h, v6.4h
    uabd v3.4h, v3.4h, v7.4h

    umlal v16.4s, v0.4h, v0.4h
    umlal v16.4s, v1.4h, v1.4h
    umlal v16.4s, v2.4h, v2.4h
    umlal v16.4s, v3.4h, v3.4h

    subs w4, w4, #4
    bgt get_ssd_4_y

    uaddlp v16.2d, v16.4s
    addp v16.2d, v16.2d, v16.2d
    mov x0, v16.d[0]

ret

//void uavs3e_get_ssd_8_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_8_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v16.16b, #0

get_ssd_8_y:
    //load p_org
    ld1 {v0.8h}, [x0], x1
    ld1 {v1.8h}, [x0], x1
    ld1 {v2.8h}, [x0], x1
    ld1 {v3.8h}, [x0], x1
    //load pred
    ld1 {v4.8h}, [x2], x3
    ld1 {v5.8h}, [x2], x3
    ld1 {v6.8h}, [x2], x3
    ld1 {v7.8h}, [x2], x3

    uabd v0.8h, v0.8h, v4.8h
    uabd v1.8h, v1.8h, v5.8h
    uabd v2.8h, v2.8h, v6.8h
    uabd v3.8h, v3.8h, v7.8h

    umlal v16.4s, v0.4h, v0.4h
    umlal2 v16.4s, v0.8h, v0.8h
    umlal v16.4s, v1.4h, v1.4h
    umlal2 v16.4s, v1.8h, v1.8h
    umlal v16.4s, v2.4h, v2.4h
    umlal2 v16.4s, v2.8h, v2.8h
    umlal v16.4s, v3.4h, v3.4h
    umlal2 v16.4s, v3.8h, v3.8h

    subs w4, w4, #4
    bgt get_ssd_8_y

    uaddlp v16.2d, v16.4s
    addp v16.2d, v16.2d, v16.2d
    mov x0, v16.d[0]

ret

//void uavs3e_get_ssd_16_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_16_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v24.16b, #0

get_ssd_16_y:
    //load p_org
    ld1 {v0.8h, v1.8h}, [x0], x1
    ld1 {v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h}, [x0], x1
    ld1 {v6.8h, v7.8h}, [x0], x1
    //load pred
    ld1 {v16.8h, v17.8h}, [x2], x3
    ld1 {v18.8h, v19.8h}, [x2], x3
    ld1 {v20.8h, v21.8h}, [x2], x3
    ld1 {v22.8h, v23.8h}, [x2], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    subs w4, w4, #4
    bgt get_ssd_16_y

    uaddlp v24.2d, v24.4s
    addp v24.2d, v24.2d, v24.2d
    mov x0, v24.d[0]

ret

//void uavs3e_get_ssd_32_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_32_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
    movi v24.16b, #0

get_ssd_32_y:
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x0], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x2], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x2], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    subs w4, w4, #2
    bgt get_ssd_32_y

    uaddlp v24.2d, v24.4s
    addp v24.2d, v24.2d, v24.2d
    mov x0, v24.d[0]

ret

//void uavs3e_get_ssd_64_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_64_arm64
    lsl x1, x1, #1      //i_org
    lsl x3, x3, #1      //i_pred
    lsl x5, x1, #1      //2 * i_org
    lsl x6, x3, #1      //2 * i_pred
    movi v24.16b, #0


get_ssd_64_y:
    mov x7, x0
    mov x8, x2

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    add x7, x0, #64
    add x8, x2, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    add x0, x0, x5
    add x2, x2, x6

    subs w4, w4, #2
    bgt get_ssd_64_y

    uaddlp v24.2d, v24.4s
    addp v24.2d, v24.2d, v24.2d
    mov x0, v24.d[0]

ret

//void uavs3e_get_ssd_128_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4
function uavs3e_get_ssd_128_arm64
    lsl x1, x1, #1      //i_org
    lsl x3, x3, #1      //i_pred
    lsl x5, x1, #1      //2 * i_org
    lsl x6, x3, #1      //2 * i_pred
    movi v24.16b, #0
    movi v25.16b, #0


get_ssd_128_y:
    mov x7, x0
    mov x8, x2

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    add x7, x0, #64
    add x8, x2, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v24.4s, v0.4h, v0.4h
    umlal2 v24.4s, v0.8h, v0.8h
    umlal v24.4s, v1.4h, v1.4h
    umlal2 v24.4s, v1.8h, v1.8h
    umlal v24.4s, v2.4h, v2.4h
    umlal2 v24.4s, v2.8h, v2.8h
    umlal v24.4s, v3.4h, v3.4h
    umlal2 v24.4s, v3.8h, v3.8h
    umlal v24.4s, v4.4h, v4.4h
    umlal2 v24.4s, v4.8h, v4.8h
    umlal v24.4s, v5.4h, v5.4h
    umlal2 v24.4s, v5.8h, v5.8h
    umlal v24.4s, v6.4h, v6.4h
    umlal2 v24.4s, v6.8h, v6.8h
    umlal v24.4s, v7.4h, v7.4h
    umlal2 v24.4s, v7.8h, v7.8h

    add x7, x0, #128
    add x8, x2, #128

    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v25.4s, v0.4h, v0.4h
    umlal2 v25.4s, v0.8h, v0.8h
    umlal v25.4s, v1.4h, v1.4h
    umlal2 v25.4s, v1.8h, v1.8h
    umlal v25.4s, v2.4h, v2.4h
    umlal2 v25.4s, v2.8h, v2.8h
    umlal v25.4s, v3.4h, v3.4h
    umlal2 v25.4s, v3.8h, v3.8h
    umlal v25.4s, v4.4h, v4.4h
    umlal2 v25.4s, v4.8h, v4.8h
    umlal v25.4s, v5.4h, v5.4h
    umlal2 v25.4s, v5.8h, v5.8h
    umlal v25.4s, v6.4h, v6.4h
    umlal2 v25.4s, v6.8h, v6.8h
    umlal v25.4s, v7.4h, v7.4h
    umlal2 v25.4s, v7.8h, v7.8h

    add x7, x0, #192
    add x8, x2, #192
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x7], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x7], x1
    //load pred
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x8], x3
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x8], x3

    uabd v0.8h, v0.8h, v16.8h
    uabd v1.8h, v1.8h, v17.8h
    uabd v2.8h, v2.8h, v18.8h
    uabd v3.8h, v3.8h, v19.8h
    uabd v4.8h, v4.8h, v20.8h
    uabd v5.8h, v5.8h, v21.8h
    uabd v6.8h, v6.8h, v22.8h
    uabd v7.8h, v7.8h, v23.8h

    umlal v25.4s, v0.4h, v0.4h
    umlal2 v25.4s, v0.8h, v0.8h
    umlal v25.4s, v1.4h, v1.4h
    umlal2 v25.4s, v1.8h, v1.8h
    umlal v25.4s, v2.4h, v2.4h
    umlal2 v25.4s, v2.8h, v2.8h
    umlal v25.4s, v3.4h, v3.4h
    umlal2 v25.4s, v3.8h, v3.8h
    umlal v25.4s, v4.4h, v4.4h
    umlal2 v25.4s, v4.8h, v4.8h
    umlal v25.4s, v5.4h, v5.4h
    umlal2 v25.4s, v5.8h, v5.8h
    umlal v25.4s, v6.4h, v6.4h
    umlal2 v25.4s, v6.8h, v6.8h
    umlal v25.4s, v7.4h, v7.4h
    umlal2 v25.4s, v7.8h, v7.8h

    add x0, x0, x5
    add x2, x2, x6

    subs w4, w4, #2
    bgt get_ssd_128_y

    uaddl v26.2d, v24.2s, v25.2s
    uaddl2 v27.2d, v24.4s, v25.4s
    add v24.2d, v26.2d, v27.2d
    addp v24.2d, v24.2d, v24.2d
    mov x0, v24.d[0]

ret

//void uavs3e_get_sad_x3_4_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_4_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    movi v16.16b, #0
    movi v17.16b, #0
    movi v18.16b, #0

get_sad_x3_4_y:
    //load p_org
    ld1 {v0.d}[0], [x0], x1
    ld1 {v0.d}[1], [x0], x1
    ld1 {v1.d}[0], [x0], x1
    ld1 {v1.d}[1], [x0], x1
    //load pred
    ld1 {v2.d}[0], [x2], x5
    ld1 {v2.d}[1], [x2], x5
    ld1 {v3.d}[0], [x2], x5
    ld1 {v3.d}[1], [x2], x5
    ld1 {v4.d}[0], [x3], x5
    ld1 {v4.d}[1], [x3], x5
    ld1 {v5.d}[0], [x3], x5
    ld1 {v5.d}[1], [x3], x5
    ld1 {v6.d}[0], [x4], x5
    ld1 {v6.d}[1], [x4], x5
    ld1 {v7.d}[0], [x4], x5
    ld1 {v7.d}[1], [x4], x5
    //abs
    uabd v2.8h, v0.8h, v2.8h
    uabd v3.8h, v1.8h, v3.8h
    uabd v4.8h, v0.8h, v4.8h
    uabd v5.8h, v1.8h, v5.8h
    uabd v6.8h, v0.8h, v6.8h
    uabd v7.8h, v1.8h, v7.8h

    uaddl v0.4s, v2.4h, v3.4h
    uaddl2 v1.4s, v2.8h, v3.8h
    add v16.4s, v16.4s, v0.4s
    add v16.4s, v16.4s, v1.4s
    uaddl v0.4s, v4.4h, v5.4h
    uaddl2 v1.4s, v4.8h, v5.8h
    add v17.4s, v17.4s, v0.4s
    add v17.4s, v17.4s, v1.4s
    uaddl v0.4s, v6.4h, v7.4h
    uaddl2 v1.4s, v6.8h, v7.8h
    add v18.4s, v18.4s, v0.4s
    add v18.4s, v18.4s, v1.4s
    subs w7, w7, #4
    bgt get_sad_x3_4_y

    addp v16.4s, v16.4s, v16.4s
    addp v16.4s, v16.4s, v16.4s
    addp v17.4s, v17.4s, v17.4s
    addp v17.4s, v17.4s, v17.4s
    addp v18.4s, v18.4s, v18.4s
    addp v18.4s, v18.4s, v18.4s

    st1 {v16.s}[0], [x6], #4
    st1 {v17.s}[0], [x6], #4
    st1 {v18.s}[0], [x6], #4

    ret

//void uavs3e_get_sad_x3_8_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, pred0->x2, pred1->x3, pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_8_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    movi v24.16b, #0
    movi v25.16b, #0
    movi v26.16b, #0

get_sad_x3_8_y:
    //load p_org
    ld1 {v0.8h}, [x0], x1
    ld1 {v1.8h}, [x0], x1
    ld1 {v2.8h}, [x0], x1
    ld1 {v3.8h}, [x0], x1
    //load pred
    ld1 {v4.8h}, [x2], x5
    ld1 {v5.8h}, [x2], x5
    ld1 {v6.8h}, [x2], x5
    ld1 {v7.8h}, [x2], x5
    ld1 {v16.8h}, [x3], x5
    ld1 {v17.8h}, [x3], x5
    ld1 {v18.8h}, [x3], x5
    ld1 {v19.8h}, [x3], x5
    ld1 {v20.8h}, [x4], x5
    ld1 {v21.8h}, [x4], x5
    ld1 {v22.8h}, [x4], x5
    ld1 {v23.8h}, [x4], x5
    //abs
    uabd v4.8h, v0.8h, v4.8h
    uabd v5.8h, v1.8h, v5.8h
    uabd v6.8h, v2.8h, v6.8h
    uabd v7.8h, v3.8h, v7.8h
    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v0.8h, v20.8h
    uabd v21.8h, v1.8h, v21.8h
    uabd v22.8h, v2.8h, v22.8h
    uabd v23.8h, v3.8h, v23.8h

    uaddl v0.4s, v4.4h, v5.4h
    uaddl2 v1.4s, v4.8h, v5.8h
    uaddl v2.4s, v6.4h, v7.4h
    uaddl2 v3.4s, v6.8h, v7.8h
    add v24.4s, v24.4s, v0.4s
    add v24.4s, v24.4s, v1.4s
    add v24.4s, v24.4s, v2.4s
    add v24.4s, v24.4s, v3.4s
    uaddl v0.4s, v16.4h, v17.4h
    uaddl2 v1.4s, v16.8h, v17.8h
    uaddl v2.4s, v18.4h, v19.4h
    uaddl2 v3.4s, v18.8h, v19.8h
    add v25.4s, v25.4s, v0.4s
    add v25.4s, v25.4s, v1.4s
    add v25.4s, v25.4s, v2.4s
    add v25.4s, v25.4s, v3.4s
    uaddl v0.4s, v20.4h, v21.4h
    uaddl2 v1.4s, v20.8h, v21.8h
    uaddl v2.4s, v22.4h, v23.4h
    uaddl2 v3.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v0.4s
    add v26.4s, v26.4s, v1.4s
    add v26.4s, v26.4s, v2.4s
    add v26.4s, v26.4s, v3.4s
    subs w7, w7, #4
    bgt get_sad_x3_8_y

    addp v24.4s, v24.4s, v24.4s
    addp v24.4s, v24.4s, v24.4s
    addp v25.4s, v25.4s, v25.4s
    addp v25.4s, v25.4s, v25.4s
    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s

    st1 {v24.s}[0], [x6], #4
    st1 {v25.s}[0], [x6], #4
    st1 {v26.s}[0], [x6], #4

ret

//void uavs3e_get_sad_x3_16_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, pred0->x2, pred1->x3, pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_16_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0

get_sad_x3_16_y:
    //load p_org
    ld1 {v0.8h, v1.8h}, [x0], x1
    ld1 {v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h}, [x0], x1
    ld1 {v6.8h, v7.8h}, [x0], x1

    //load pred0
    ld1 {v16.8h, v17.8h}, [x2], x5
    ld1 {v18.8h, v19.8h}, [x2], x5
    ld1 {v20.8h, v21.8h}, [x2], x5
    ld1 {v22.8h, v23.8h}, [x2], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h}, [x3], x5
    ld1 {v18.8h, v19.8h}, [x3], x5
    ld1 {v20.8h, v21.8h}, [x3], x5
    ld1 {v22.8h, v23.8h}, [x3], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h}, [x4], x5
    ld1 {v18.8h, v19.8h}, [x4], x5
    ld1 {v20.8h, v21.8h}, [x4], x5
    ld1 {v22.8h, v23.8h}, [x4], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    subs w7, w7, #4
    bgt get_sad_x3_16_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s

    st1 {v26.s}[0], [x6], #4
    st1 {v27.s}[0], [x6], #4
    st1 {v28.s}[0], [x6], #4
ret

//void uavs3e_get_sad_x3_32_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, pred0->x2, pred1->x3, pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_32_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0

get_sad_x3_32_y:
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x0], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x2], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x2], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x3], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x3], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x4], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x4], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    subs w7, w7, #2
    bgt get_sad_x3_32_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s

    st1 {v26.s}[0], [x6], #4
    st1 {v27.s}[0], [x6], #4
    st1 {v28.s}[0], [x6], #4

ret


//void uavs3e_get_sad_x3_64_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, pred0->x2, pred1->x3, pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_64_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    lsl x12, x1, #1     //2 * i_org
    lsl x13, x5, #1     //2 * i_pred
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0

get_sad_x3_64_y:
    mov x8, x0
    mov x9, x2
    mov x10, x3
    mov x11, x4
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x8, x0, #64
    add x9, x2, #64
    add x10, x3, #64
    add x11, x4, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x0, x0, x12
    add x2, x2, x13
    add x3, x3, x13
    add x4, x4, x13

    subs w7, w7, #2
    bgt get_sad_x3_64_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s

    st1 {v26.s}[0], [x6], #4
    st1 {v27.s}[0], [x6], #4
    st1 {v28.s}[0], [x6], #4

ret

//void uavs3e_get_sad_x3_128_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, pred0->x2, pred1->x3, pred2->x4, i_pred->x5, sad[3]->x6, height->x7
function uavs3e_get_sad_x3_128_arm64
    lsl x1, x1, #1
    lsl x5, x5, #1
    lsl x12, x1, #1     //2 * i_org
    lsl x13, x5, #1     //2 * i_pred
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0

get_sad_x3_128_y:
    mov x8, x0
    mov x9, x2
    mov x10, x3
    mov x11, x4
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x8, x0, #64
    add x9, x2, #64
    add x10, x3, #64
    add x11, x4, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x8, x0, #128
    add x9, x2, #128
    add x10, x3, #128
    add x11, x4, #128
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x8, x0, #192
    add x9, x2, #192
    add x10, x3, #192
    add x11, x4, #192
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x5
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x5

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    add x0, x0, x12
    add x2, x2, x13
    add x3, x3, x13
    add x4, x4, x13

    subs w7, w7, #2
    bgt get_sad_x3_128_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s

    st1 {v26.s}[0], [x6], #4
    st1 {v27.s}[0], [x6], #4
    st1 {v28.s}[0], [x6], #4

ret

//void uavs3e_get_sad_x4_4_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[4]->x7, height->[x8]
function uavs3e_get_sad_x4_4_arm64
    ldr x8, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    movi v18.16b, #0
    movi v19.16b, #0
    movi v20.16b, #0
    movi v21.16b, #0

get_sad_x4_4_y:
    //load p_org
    ld1 {v0.d}[0], [x0], x1
    ld1 {v0.d}[1], [x0], x1
    ld1 {v1.d}[0], [x0], x1
    ld1 {v1.d}[1], [x0], x1
    //load pred
    ld1 {v2.d}[0], [x2], x6
    ld1 {v2.d}[1], [x2], x6
    ld1 {v3.d}[0], [x2], x6
    ld1 {v3.d}[1], [x2], x6
    ld1 {v4.d}[0], [x3], x6
    ld1 {v4.d}[1], [x3], x6
    ld1 {v5.d}[0], [x3], x6
    ld1 {v5.d}[1], [x3], x6
    ld1 {v6.d}[0], [x4], x6
    ld1 {v6.d}[1], [x4], x6
    ld1 {v7.d}[0], [x4], x6
    ld1 {v7.d}[1], [x4], x6
    ld1 {v16.d}[0], [x5], x6
    ld1 {v16.d}[1], [x5], x6
    ld1 {v17.d}[0], [x5], x6
    ld1 {v17.d}[1], [x5], x6
    //abs
    uabd v2.8h, v0.8h, v2.8h
    uabd v3.8h, v1.8h, v3.8h
    uabd v4.8h, v0.8h, v4.8h
    uabd v5.8h, v1.8h, v5.8h
    uabd v6.8h, v0.8h, v6.8h
    uabd v7.8h, v1.8h, v7.8h
    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h

    uaddl v0.4s, v2.4h, v3.4h
    uaddl2 v1.4s, v2.8h, v3.8h
    add v18.4s, v18.4s, v0.4s
    add v18.4s, v18.4s, v1.4s
    uaddl v0.4s, v4.4h, v5.4h
    uaddl2 v1.4s, v4.8h, v5.8h
    add v19.4s, v19.4s, v0.4s
    add v19.4s, v19.4s, v1.4s
    uaddl v0.4s, v6.4h, v7.4h
    uaddl2 v1.4s, v6.8h, v7.8h
    add v20.4s, v20.4s, v0.4s
    add v20.4s, v20.4s, v1.4s
    uaddl v0.4s, v16.4h, v17.4h
    uaddl2 v1.4s, v16.8h, v17.8h
    add v21.4s, v21.4s, v0.4s
    add v21.4s, v21.4s, v1.4s
    subs w8, w8, #4
    bgt get_sad_x4_4_y

    addp v18.4s, v18.4s, v18.4s
    addp v18.4s, v18.4s, v18.4s
    addp v19.4s, v19.4s, v19.4s
    addp v19.4s, v19.4s, v19.4s
    addp v20.4s, v20.4s, v20.4s
    addp v20.4s, v20.4s, v20.4s
    addp v21.4s, v21.4s, v21.4s
    addp v21.4s, v21.4s, v21.4s

    st1 {v18.s}[0], [x7], #4
    st1 {v19.s}[0], [x7], #4
    st1 {v20.s}[0], [x7], #4
    st1 {v21.s}[0], [x7], #4

    ret

//void uavs3e_get_sad_x4_8_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[4]->x7, height->[x8]
function uavs3e_get_sad_x4_8_arm64
    ldr x8, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    movi v28.16b, #0
    movi v29.16b, #0
    movi v30.16b, #0
    movi v31.16b, #0

get_sad_x4_8_y:
    //load p_org
    ld1 {v0.8h}, [x0], x1
    ld1 {v1.8h}, [x0], x1
    ld1 {v2.8h}, [x0], x1
    ld1 {v3.8h}, [x0], x1
    //load pred
    ld1 {v4.8h}, [x2], x6
    ld1 {v5.8h}, [x2], x6
    ld1 {v6.8h}, [x2], x6
    ld1 {v7.8h}, [x2], x6
    ld1 {v16.8h}, [x3], x6
    ld1 {v17.8h}, [x3], x6
    ld1 {v18.8h}, [x3], x6
    ld1 {v19.8h}, [x3], x6
    ld1 {v20.8h}, [x4], x6
    ld1 {v21.8h}, [x4], x6
    ld1 {v22.8h}, [x4], x6
    ld1 {v23.8h}, [x4], x6
    ld1 {v24.8h}, [x5], x6
    ld1 {v25.8h}, [x5], x6
    ld1 {v26.8h}, [x5], x6
    ld1 {v27.8h}, [x5], x6

    //abs
    uabd v4.8h, v0.8h, v4.8h
    uabd v5.8h, v1.8h, v5.8h
    uabd v6.8h, v2.8h, v6.8h
    uabd v7.8h, v3.8h, v7.8h
    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v0.8h, v20.8h
    uabd v21.8h, v1.8h, v21.8h
    uabd v22.8h, v2.8h, v22.8h
    uabd v23.8h, v3.8h, v23.8h
    uabd v24.8h, v0.8h, v24.8h
    uabd v25.8h, v1.8h, v25.8h
    uabd v26.8h, v2.8h, v26.8h
    uabd v27.8h, v3.8h, v27.8h

    uaddl v0.4s, v4.4h, v5.4h
    uaddl2 v1.4s, v4.8h, v5.8h
    uaddl v2.4s, v6.4h, v7.4h
    uaddl2 v3.4s, v6.8h, v7.8h
    add v28.4s, v28.4s, v0.4s
    add v28.4s, v28.4s, v1.4s
    add v28.4s, v28.4s, v2.4s
    add v28.4s, v28.4s, v3.4s
    uaddl v0.4s, v16.4h, v17.4h
    uaddl2 v1.4s, v16.8h, v17.8h
    uaddl v2.4s, v18.4h, v19.4h
    uaddl2 v3.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v0.4s
    add v29.4s, v29.4s, v1.4s
    add v29.4s, v29.4s, v2.4s
    add v29.4s, v29.4s, v3.4s
    uaddl v0.4s, v20.4h, v21.4h
    uaddl2 v1.4s, v20.8h, v21.8h
    uaddl v2.4s, v22.4h, v23.4h
    uaddl2 v3.4s, v22.8h, v23.8h
    add v30.4s, v30.4s, v0.4s
    add v30.4s, v30.4s, v1.4s
    add v30.4s, v30.4s, v2.4s
    add v30.4s, v30.4s, v3.4s
    uaddl v0.4s, v24.4h, v25.4h
    uaddl2 v1.4s, v24.8h, v25.8h
    uaddl v2.4s, v26.4h, v27.4h
    uaddl2 v3.4s, v26.8h, v27.8h
    add v31.4s, v31.4s, v0.4s
    add v31.4s, v31.4s, v1.4s
    add v31.4s, v31.4s, v2.4s
    add v31.4s, v31.4s, v3.4s
    subs w8, w8, #4
    bgt get_sad_x4_8_y

    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s
    addp v29.4s, v29.4s, v29.4s
    addp v29.4s, v29.4s, v29.4s
    addp v30.4s, v30.4s, v30.4s
    addp v30.4s, v30.4s, v30.4s
    addp v31.4s, v31.4s, v31.4s
    addp v31.4s, v31.4s, v31.4s

    st1 {v28.s}[0], [x7], #4
    st1 {v29.s}[0], [x7], #4
    st1 {v30.s}[0], [x7], #4
    st1 {v31.s}[0], [x7], #4

ret

//void uavs3e_get_sad_x4_16_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[4]->x7, height->[x8]
function uavs3e_get_sad_x4_16_arm64
    ldr x8, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0

get_sad_x4_16_y:
    //load p_org
    ld1 {v0.8h, v1.8h}, [x0], x1
    ld1 {v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h}, [x0], x1
    ld1 {v6.8h, v7.8h}, [x0], x1

    //load pred0
    ld1 {v16.8h, v17.8h}, [x2], x6
    ld1 {v18.8h, v19.8h}, [x2], x6
    ld1 {v20.8h, v21.8h}, [x2], x6
    ld1 {v22.8h, v23.8h}, [x2], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h}, [x3], x6
    ld1 {v18.8h, v19.8h}, [x3], x6
    ld1 {v20.8h, v21.8h}, [x3], x6
    ld1 {v22.8h, v23.8h}, [x3], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h}, [x4], x6
    ld1 {v18.8h, v19.8h}, [x4], x6
    ld1 {v20.8h, v21.8h}, [x4], x6
    ld1 {v22.8h, v23.8h}, [x4], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h}, [x5], x6
    ld1 {v18.8h, v19.8h}, [x5], x6
    ld1 {v20.8h, v21.8h}, [x5], x6
    ld1 {v22.8h, v23.8h}, [x5], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    subs w8, w8, #4
    bgt get_sad_x4_16_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s
    addp v29.4s, v29.4s, v29.4s
    addp v29.4s, v29.4s, v29.4s

    st1 {v26.s}[0], [x7], #4
    st1 {v27.s}[0], [x7], #4
    st1 {v28.s}[0], [x7], #4
    st1 {v29.s}[0], [x7], #4
ret

//void uavs3e_get_sad_x4_32_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[3], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[3]->x7, height->[x8]
function uavs3e_get_sad_x4_32_arm64
    ldr x8, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0

get_sad_x4_32_y:
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x0], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x0], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x2], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x2], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x3], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x3], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x4], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x4], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x5], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x5], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    subs w8, w8, #2
    bgt get_sad_x4_32_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s
    addp v29.4s, v29.4s, v29.4s
    addp v29.4s, v29.4s, v29.4s

    st1 {v26.s}[0], [x7], #4
    st1 {v27.s}[0], [x7], #4
    st1 {v28.s}[0], [x7], #4
    st1 {v29.s}[0], [x7], #4

ret


//void uavs3e_get_sad_x4_64_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[4], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[4]->x7, height->[x8]
function uavs3e_get_sad_x4_64_arm64
    ldr x15, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    lsl x13, x1, #1     //2 * i_org
    lsl x14, x6, #1     //2 * i_pred
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0

get_sad_x4_64_y:
    mov x8, x0
    mov x9, x2
    mov x10, x3
    mov x11, x4
    mov x12, x5
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x8, x0, #64
    add x9, x2, #64
    add x10, x3, #64
    add x11, x4, #64
    add x12, x5, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x0, x0, x13
    add x2, x2, x14
    add x3, x3, x14
    add x4, x4, x14
    add x5, x5, x14

    subs w15, w15, #2
    bgt get_sad_x4_64_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s
    addp v29.4s, v29.4s, v29.4s
    addp v29.4s, v29.4s, v29.4s

    st1 {v26.s}[0], [x7], #4
    st1 {v27.s}[0], [x7], #4
    st1 {v28.s}[0], [x7], #4
    st1 {v29.s}[0], [x7], #4

ret

//void uavs3e_get_sad_x4_128_arm64(pel *p_org, int i_org, pel *pred0, pel *pred1, pel *pred2, pel, *pred3, int i_pred, u32 sad[4], int height)
//*p_org->x0, i_org->x1, *pred0->x2, *pred1->x3, *pred2->x4, *pred3->x5, i_pred->x6, sad[4]->x7, height->[x8]
function uavs3e_get_sad_x4_128_arm64
    ldr x15, [sp]
    lsl x1, x1, #1
    lsl x6, x6, #1
    lsl x13, x1, #1     //2 * i_org
    lsl x14, x6, #1     //2 * i_pred
    movi v26.16b, #0
    movi v27.16b, #0
    movi v28.16b, #0
    movi v29.16b, #0

get_sad_x4_128_y:
    mov x8, x0
    mov x9, x2
    mov x10, x3
    mov x11, x4
    mov x12, x5
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x8, x0, #64
    add x9, x2, #64
    add x10, x3, #64
    add x11, x4, #64
    add x12, x5, #64
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x8, x0, #128
    add x9, x2, #128
    add x10, x3, #128
    add x11, x4, #128
    add x12, x5, #128
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x8, x0, #192
    add x9, x2, #192
    add x10, x3, #192
    add x11, x4, #192
    add x12, x5, #192
    //load p_org
    ld1 {v0.8h, v1.8h, v2.8h, v3.8h}, [x8], x1
    ld1 {v4.8h, v5.8h, v6.8h, v7.8h}, [x8], x1
    //load pred0
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x9], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x9], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v26.4s, v26.4s, v24.4s
    add v26.4s, v26.4s, v25.4s

    //load pred1
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x10], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x10], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v27.4s, v27.4s, v24.4s
    add v27.4s, v27.4s, v25.4s

    //load pred2
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x11], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x11], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v28.4s, v28.4s, v24.4s
    add v28.4s, v28.4s, v25.4s

    //load pred3
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x12], x6
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x12], x6

    uabd v16.8h, v0.8h, v16.8h
    uabd v17.8h, v1.8h, v17.8h
    uabd v18.8h, v2.8h, v18.8h
    uabd v19.8h, v3.8h, v19.8h
    uabd v20.8h, v4.8h, v20.8h
    uabd v21.8h, v5.8h, v21.8h
    uabd v22.8h, v6.8h, v22.8h
    uabd v23.8h, v7.8h, v23.8h

    uaddl v24.4s, v16.4h, v17.4h
    uaddl2 v25.4s, v16.8h, v17.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v18.4h, v19.4h
    uaddl2 v25.4s, v18.8h, v19.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v20.4h, v21.4h
    uaddl2 v25.4s, v20.8h, v21.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s
    uaddl v24.4s, v22.4h, v23.4h
    uaddl2 v25.4s, v22.8h, v23.8h
    add v29.4s, v29.4s, v24.4s
    add v29.4s, v29.4s, v25.4s

    add x0, x0, x13
    add x2, x2, x14
    add x3, x3, x14
    add x4, x4, x14
    add x5, x5, x14

    subs w15, w15, #2
    bgt get_sad_x4_128_y

    addp v26.4s, v26.4s, v26.4s
    addp v26.4s, v26.4s, v26.4s
    addp v27.4s, v27.4s, v27.4s
    addp v27.4s, v27.4s, v27.4s
    addp v28.4s, v28.4s, v28.4s
    addp v28.4s, v28.4s, v28.4s
    addp v29.4s, v29.4s, v29.4s
    addp v29.4s, v29.4s, v29.4s

    st1 {v26.s}[0], [x7], #4
    st1 {v27.s}[0], [x7], #4
    st1 {v28.s}[0], [x7], #4
    st1 {v29.s}[0], [x7], #4

ret

//void uavs3e_had_4x4_arm64(pel *org, int s_org, pel *cur, int s_cur)
//*org->x1, s_org->x2, *cur->x3, s_cur->x4
function uavs3e_had_4x4_arm64

ret

#endif
#endif