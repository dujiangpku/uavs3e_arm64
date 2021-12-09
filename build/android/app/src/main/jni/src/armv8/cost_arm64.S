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
get_sad4_y:
    //load org
    ld1 {v0.d}[0], [x0], x1
    ld1 {v1.d}[0], [x0], x1
    ld1 {v2.d}[0], [x0], x1
    ld1 {v3.d}[0], [x0], x1
    //load pred
    ld1 {v4.d}[0], [x2], x3
    ld1 {v5.d}[0], [x2], x3
    ld1 {v6.d}[0], [x2], x3
    ld1 {v7.d}[0], [x2], x3
    uabd v0.4h, v0.4h, v4.4h
    uabd v1.4h, v1.4h, v5.4h
    uabd v2.4h, v2.4h, v6.4h
    uabd v3.4h, v3.4h, v7.4h
    uaddl v0.4s, v0.4h, v1.4h
    uaddl v2.4s, v2.4h, v3.4h
    add v0.4s, v0.4s, v2.4s
    add v16.4s, v0.4s, v16.4s
    subs w4, w4, #4
    bgt get_sad4_y

    addp v16.4s, v16.4s, v16.4s
    addp v16.4s, v16.4s, v16.4s
    mov x0, #0
    umov w0, v16.s[0]

    ret

//void uavs3e_get_sad_8_arm64(pel *p_org, int i_org, pel *pred, int i_pred, int height)
//*p_org->x0, i_org->x1, p_pred->x2, i_pred->x3, height->x4


#endif
#endif