#include "def_arm64.S"
#if defined(__arm64__)

#if !COMPILE_10BIT

#else

//void uavs3e_if_cpy_w4_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height)
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5
function uavs3e_if_cpy_w4_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
if_cpy_w4_loop_y:
    ld1 {v0.4h}, [x0], x1
    ld1 {v1.4h}, [x0], x1
    ld1 {v2.4h}, [x0], x1
    ld1 {v3.4h}, [x0], x1
    st1 {v0.4h}, [x2], x3
    st1 {v1.4h}, [x2], x3
    subs w5, w5, #4
    st1 {v2.4h}, [x2], x3
    st1 {v3.4h}, [x2], x3
    bgt if_cpy_w4_loop_y

    ret

//void uavs3e_if_cpy_w8_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height)
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5
function uavs3e_if_cpy_w8_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
if_cpy_w8_loop_y:
    ld1 {v0.8h}, [x0], x1
    ld1 {v1.8h}, [x0], x1
    ld1 {v2.8h}, [x0], x1
    ld1 {v3.8h}, [x0], x1

    subs w5, w5, #4
    st1 {v0.8h}, [x2], x3
    st1 {v1.8h}, [x2], x3
    st1 {v2.8h}, [x2], x3
    st1 {v3.8h}, [x2], x3
    bgt if_cpy_w8_loop_y

    ret

//void uavs3e_if_cpy_w16_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height)
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5
function uavs3e_if_cpy_w16_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1
if_cpy_w16_loop_y:
    ld1 {v0.2d, v1.2d}, [x0], x1
    ld1 {v2.2d, v3.2d}, [x0], x1
    ld1 {v4.2d, v5.2d}, [x0], x1
    ld1 {v6.2d, v7.2d}, [x0], x1

    subs w5, w5, #4
    st1 {v0.2d, v1.2d}, [x2], x3
    st1 {v2.2d, v3.2d}, [x2], x3
    st1 {v4.2d, v5.2d}, [x2], x3
    st1 {v6.2d, v7.2d}, [x2], x3
    bgt if_cpy_w16_loop_y

    ret

//void uavs3e_if_hor_luma_w4_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, s8 const *coeff, int max_val);
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff->x6, max_val->x7
function uavs3e_if_hor_luma_w4_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1

    ld1 {v18.d}[0], [x6]
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b
    dup v0.4h, v7.h[0]
    dup v1.4h, v7.h[1]
    dup v2.4h, v7.h[2]
    dup v3.4h, v7.h[3]
    dup v4.4h, v7.h[4]
    dup v5.4h, v7.h[5]
    dup v6.4h, v7.h[6]
    dup v7.4h, v7.h[7]

    sub x0, x0, #6                      // x-3
    sub x1, x1, #16
    dup v31.8h, w7                      // max_val
if_hor_luma_w4_loop_y:
    ld1 {v20.4h, v21.4h}, [x0], #16     // src[x-3]
    ld1 {v16.4h}, [x0], x1
    ld1 {v22.4h, v23.4h}, [x0], #16
    ld1 {v19.4h}, [x0], x1

    ext v24.8b, v20.8b, v21.8b, #2      // src[x-2]
    ext v25.8b, v20.8b, v21.8b, #4      // src[x-1]
    ext v26.8b, v20.8b, v21.8b, #6      // src[x]
    umull v17.4s, v24.4h, v1.4h
    // v21 : src[x+1]
    umlsl v17.4s, v20.4h, v0.4h
    ext v28.8b, v21.8b, v16.8b, #2      // src[x+2]
    umlsl v17.4s, v25.4h, v2.4h
    ext v29.8b, v21.8b, v16.8b, #4      // src[x+3]
    umlal v17.4s, v26.4h, v3.4h
    ext v30.8b, v21.8b, v16.8b, #6      // src[x+4]
    umlal v17.4s, v21.4h, v4.4h
    ext v24.8b, v22.8b, v23.8b, #2
    umlsl v17.4s, v28.4h, v5.4h
    ext v25.8b, v22.8b, v23.8b, #4
    umull v18.4s, v24.4h, v1.4h
    umlal v17.4s, v29.4h, v6.4h
    umlsl v18.4s, v22.4h, v0.4h
    ext v26.8b, v22.8b, v23.8b, #6
    umlsl v18.4s, v25.4h, v2.4h
    umlsl v17.4s, v30.4h, v7.4h
    // v23 : src[x+1+i_src]
    umlal v18.4s, v26.4h, v3.4h
    ext v28.8b, v23.8b, v19.8b, #2
    umlal v18.4s, v23.4h, v4.4h
    ext v29.8b, v23.8b, v19.8b, #4
    umlsl v18.4s, v28.4h, v5.4h
    ext v30.8b, v23.8b, v19.8b, #6
    umlal v18.4s, v29.4h, v6.4h
    sqrshrun v17.4h, v17.4s, #6
    umlsl v18.4s, v30.4h, v7.4h

    //(sum + 32) >> 6
    sqrshrun v18.4h, v18.4s, #6

    umin v17.4h, v17.4h, v31.4h
    umin v18.4h, v18.4h, v31.4h

    subs w5, w5, #2
    st1 {v17.4h}, [x2], x3
    st1 {v18.4h}, [x2], x3
    bgt if_hor_luma_w4_loop_y

    ret

//void uavs3e_if_hor_luma_w8_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, s8 const *coeff, int max_val);
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff->x6, max_val->x7
function uavs3e_if_hor_luma_w8_arm64
    lsl x1, x1, #1
    lsl x3, x3, #1

    ld1 {v18.d}[0], [x6]
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b

    dup v0.8h, v7.h[0]
    dup v1.8h, v7.h[1]
    dup v2.8h, v7.h[2]
    dup v3.8h, v7.h[3]
    dup v4.8h, v7.h[4]
    dup v5.8h, v7.h[5]
    dup v6.8h, v7.h[6]
    dup v7.8h, v7.h[7]

    sub x0, x0, #6                      // x-3
    dup v31.8h, w7                      // max_val
if_hor_luma_w8_loop_y:
    ld1 {v20.8h, v21.8h}, [x0], x1      // src[x-3]
    ld1 {v22.8h, v23.8h}, [x0], x1

    ext v24.16b, v20.16b, v21.16b, #2
    ext v25.16b, v20.16b, v21.16b, #4
    ext v26.16b, v20.16b, v21.16b, #6
    ext v27.16b, v20.16b, v21.16b, #8
    ext v28.16b, v20.16b, v21.16b, #10
    ext v29.16b, v20.16b, v21.16b, #12
    ext v30.16b, v20.16b, v21.16b, #14

    umull  v17.4s, v24.4h, v1.4h
    umull2 v18.4s, v24.8h, v1.8h
    umlsl  v17.4s, v20.4h, v0.4h
    umlsl2 v18.4s, v20.8h, v0.8h
    umlsl  v17.4s, v25.4h, v2.4h
    umlsl2 v18.4s, v25.8h, v2.8h
    umlal  v17.4s, v26.4h, v3.4h
    umlal2 v18.4s, v26.8h, v3.8h
    umlal  v17.4s, v27.4h, v4.4h
    umlal2 v18.4s, v27.8h, v4.8h
    umlsl  v17.4s, v28.4h, v5.4h
    umlsl2 v18.4s, v28.8h, v5.8h
    umlal  v17.4s, v29.4h, v6.4h
    umlal2 v18.4s, v29.8h, v6.8h
    umlsl  v17.4s, v30.4h, v7.4h
    umlsl2 v18.4s, v30.8h, v7.8h

    ext v24.16b, v22.16b, v23.16b, #2
    ext v25.16b, v22.16b, v23.16b, #4
    ext v26.16b, v22.16b, v23.16b, #6
    ext v27.16b, v22.16b, v23.16b, #8
    ext v28.16b, v22.16b, v23.16b, #10
    ext v29.16b, v22.16b, v23.16b, #12
    ext v30.16b, v22.16b, v23.16b, #14

    //(sum + 32) >> 6
    sqrshrun  v16.4h, v17.4s, #6
    sqrshrun2 v16.8h, v18.4s, #6

    umull  v18.4s, v24.4h, v1.4h
    umull2 v19.4s, v24.8h, v1.8h
    umlsl  v18.4s, v22.4h, v0.4h
    umlsl2 v19.4s, v22.8h, v0.8h
    umlsl  v18.4s, v25.4h, v2.4h
    umlsl2 v19.4s, v25.8h, v2.8h
    umlal  v18.4s, v26.4h, v3.4h
    umlal2 v19.4s, v26.8h, v3.8h
    umlal  v18.4s, v27.4h, v4.4h
    umlal2 v19.4s, v27.8h, v4.8h
    umlsl  v18.4s, v28.4h, v5.4h
    umlsl2 v19.4s, v28.8h, v5.8h
    umlal  v18.4s, v29.4h, v6.4h
    umlal2 v19.4s, v29.8h, v6.8h
    umlsl  v18.4s, v30.4h, v7.4h
    umlsl2 v19.4s, v30.8h, v7.8h

    sqrshrun  v18.4h, v18.4s, #6
    sqrshrun2 v18.8h, v19.4s, #6

    umin v16.8h, v16.8h, v31.8h
    umin v18.8h, v18.8h, v31.8h

    subs w5, w5, #2
    st1 {v16.8h}, [x2], x3
    st1 {v18.8h}, [x2], x3
    bgt if_hor_luma_w8_loop_y

    ret


//void uavs3e_if_ver_luma_w4_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, s8 const *coeff, int max_val);
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff->x6, max_val->x7
function uavs3e_if_ver_luma_w4_arm64
    sub sp, sp, #16
    st1 {v8.2d}, [sp]

    lsl x1, x1, #1
    lsl x3, x3, #1

    // load coeffs
    ld1 {v18.d}[0], [x6]
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b
    dup v0.8h, v7.h[0]
    dup v1.8h, v7.h[1]
    dup v2.8h, v7.h[2]
    dup v3.8h, v7.h[3]
    dup v4.8h, v7.h[4]
    dup v5.8h, v7.h[5]
    dup v6.8h, v7.h[6]
    dup v7.8h, v7.h[7]

    sub x0, x0, x1, lsl #1
    sub x0, x0, x1                      // src - 3*i_src
    dup v8.8h, w7
if_ver_luma_w4_loop_y:
    ld1 {v16.4h}, [x0], x1             // x-3*i_src
    ld1 {v17.4h}, [x0], x1             // x-2*i_src
    ld1 {v18.4h}, [x0], x1             // x-i_src
    ld1 {v19.4h}, [x0], x1             // x
    mov x10, x0
    ld1 {v20.4h}, [x0], x1             // x+i_src
    ld1 {v21.4h}, [x0], x1             // x+2*i_src
    ld1 {v22.4h}, [x0], x1             // x+3*i_src
    ld1 {v23.4h}, [x0], x1             // x+4*i_src
    ld1 {v24.4h}, [x0], x1
    ld1 {v30.4h}, [x0], x1
    ld1 {v31.4h}, [x0]

    umull v25.4s, v17.4h, v1.4h
    umull v26.4s, v18.4h, v1.4h
    umlsl v25.4s, v16.4h, v0.4h
    umlsl v26.4s, v17.4h, v0.4h
    umlsl v25.4s, v18.4h, v2.4h
    umlsl v26.4s, v19.4h, v2.4h
    umlal v25.4s, v19.4h, v3.4h
    umlal v26.4s, v20.4h, v3.4h
    umlal v25.4s, v20.4h, v4.4h
    umlal v26.4s, v21.4h, v4.4h
    umlsl v25.4s, v21.4h, v5.4h
    umlsl v26.4s, v22.4h, v5.4h
    umlal v25.4s, v22.4h, v6.4h
    umlal v26.4s, v23.4h, v6.4h
    umlsl v25.4s, v23.4h, v7.4h
    umlsl v26.4s, v24.4h, v7.4h

    umull v27.4s, v19.4h, v1.4h
    umull v28.4s, v20.4h, v1.4h
    umlsl v27.4s, v18.4h, v0.4h
    umlsl v28.4s, v19.4h, v0.4h
    umlsl v27.4s, v20.4h, v2.4h
    umlsl v28.4s, v21.4h, v2.4h
    umlal v27.4s, v21.4h, v3.4h
    umlal v28.4s, v22.4h, v3.4h
    umlal v27.4s, v22.4h, v4.4h
    umlal v28.4s, v23.4h, v4.4h
    umlsl v27.4s, v23.4h, v5.4h
    umlsl v28.4s, v24.4h, v5.4h
    umlal v27.4s, v24.4h, v6.4h
    umlal v28.4s, v30.4h, v6.4h
    umlsl v27.4s, v30.4h, v7.4h
    umlsl v28.4s, v31.4h, v7.4h

    //(sum + 32) >> 6
    sqrshrun  v25.4h, v25.4s, #6
    sqrshrun2 v25.8h, v26.4s, #6
    sqrshrun  v26.4h, v27.4s, #6
    sqrshrun2 v26.8h, v28.4s, #6

    umin v25.8h, v25.8h, v8.8h
    umin v26.8h, v26.8h, v8.8h

    subs w5, w5, #4
    mov x0, x10
    st1 {v25.d}[0], [x2], x3
    st1 {v25.d}[1], [x2], x3
    st1 {v26.d}[0], [x2], x3
    st1 {v26.d}[1], [x2], x3
    bgt if_ver_luma_w4_loop_y

    ld1 {v8.2d}, [sp], #16

    ret

//void uavs3e_if_ver_luma_w8_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, s8 const *coeff, int max_val);
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff->x6, max_val->x7
function uavs3e_if_ver_luma_w8_arm64
    sub sp, sp, #16
    st1 {v8.2d}, [sp]

    lsl x1, x1, #1
    lsl x3, x3, #1

    // load coeffs
    ld1 {v18.d}[0], [x6]
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b
    dup v0.8h, v7.h[0]
    dup v1.8h, v7.h[1]
    dup v2.8h, v7.h[2]
    dup v3.8h, v7.h[3]
    dup v4.8h, v7.h[4]
    dup v5.8h, v7.h[5]
    dup v6.8h, v7.h[6]
    dup v7.8h, v7.h[7]

    sub x0, x0, x1, lsl #1
    sub x0, x0, x1                      // src - 3*i_src

    dup v8.8h, w7
if_ver_luma_w8_loop_y:
    ld1 {v16.8h}, [x0], x1            // x-3*i_src
    ld1 {v17.8h}, [x0], x1            // x-2*i_src
    ld1 {v18.8h}, [x0], x1            // x-i_src
    ld1 {v19.8h}, [x0], x1            // x
    mov x10, x0
    ld1 {v20.8h}, [x0], x1            // x+i_src
    ld1 {v21.8h}, [x0], x1            // x+2*i_src
    ld1 {v22.8h}, [x0], x1            // x+3*i_src
    ld1 {v23.8h}, [x0], x1            // x+4*i_src
    ld1 {v24.8h}, [x0], x1
    ld1 {v25.8h}, [x0], x1
    ld1 {v26.8h}, [x0]

    umull  v28.4s, v17.4h, v1.4h
    umull2 v29.4s, v17.8h, v1.8h
    umull  v30.4s, v18.4h, v1.4h
    umull2 v31.4s, v18.8h, v1.8h
    umlsl  v28.4s, v16.4h, v0.4h
    umlsl2 v29.4s, v16.8h, v0.8h
    umlsl  v30.4s, v17.4h, v0.4h
    umlsl2 v31.4s, v17.8h, v0.8h
    umlsl  v28.4s, v18.4h, v2.4h
    umlsl2 v29.4s, v18.8h, v2.8h
    umlsl  v30.4s, v19.4h, v2.4h
    umlsl2 v31.4s, v19.8h, v2.8h
    umlal  v28.4s, v19.4h, v3.4h
    umlal2 v29.4s, v19.8h, v3.8h
    umlal  v30.4s, v20.4h, v3.4h
    umlal2 v31.4s, v20.8h, v3.8h
    umlal  v28.4s, v20.4h, v4.4h
    umlal2 v29.4s, v20.8h, v4.8h
    umlal  v30.4s, v21.4h, v4.4h
    umlal2 v31.4s, v21.8h, v4.8h
    umlsl  v28.4s, v21.4h, v5.4h
    umlsl2 v29.4s, v21.8h, v5.8h
    umlsl  v30.4s, v22.4h, v5.4h
    umlsl2 v31.4s, v22.8h, v5.8h
    umlal  v28.4s, v22.4h, v6.4h
    umlal2 v29.4s, v22.8h, v6.8h
    umlal  v30.4s, v23.4h, v6.4h
    umlal2 v31.4s, v23.8h, v6.8h
    umlsl  v28.4s, v23.4h, v7.4h
    umlsl2 v29.4s, v23.8h, v7.8h
    umlsl  v30.4s, v24.4h, v7.4h
    umlsl2 v31.4s, v24.8h, v7.8h

    sqrshrun  v28.4h, v28.4s, #6
    sqrshrun2 v28.8h, v29.4s, #6
    sqrshrun  v29.4h, v30.4s, #6
    sqrshrun2 v29.8h, v31.4s, #6

    umin v28.8h, v28.8h, v8.8h
    umin v29.8h, v29.8h, v8.8h

    st1 {v28.8h}, [x2], x3
    st1 {v29.8h}, [x2], x3

    umull  v16.4s, v19.4h, v1.4h
    umull2 v17.4s, v19.8h, v1.8h
    umull  v28.4s, v20.4h, v1.4h
    umull2 v29.4s, v20.8h, v1.8h
    umlsl  v16.4s, v18.4h, v0.4h
    umlsl2 v17.4s, v18.8h, v0.8h
    umlsl  v28.4s, v19.4h, v0.4h
    umlsl2 v29.4s, v19.8h, v0.8h
    umlsl  v16.4s, v20.4h, v2.4h
    umlsl2 v17.4s, v20.8h, v2.8h
    umlsl  v28.4s, v21.4h, v2.4h
    umlsl2 v29.4s, v21.8h, v2.8h
    umlal  v16.4s, v21.4h, v3.4h
    umlal2 v17.4s, v21.8h, v3.8h
    umlal  v28.4s, v22.4h, v3.4h
    umlal2 v29.4s, v22.8h, v3.8h
    umlal  v16.4s, v22.4h, v4.4h
    umlal2 v17.4s, v22.8h, v4.8h
    umlal  v28.4s, v23.4h, v4.4h
    umlal2 v29.4s, v23.8h, v4.8h
    umlsl  v16.4s, v23.4h, v5.4h
    umlsl2 v17.4s, v23.8h, v5.8h
    umlsl  v28.4s, v24.4h, v5.4h
    umlsl2 v29.4s, v24.8h, v5.8h
    umlal  v16.4s, v24.4h, v6.4h
    umlal2 v17.4s, v24.8h, v6.8h
    umlal  v28.4s, v25.4h, v6.4h
    umlal2 v29.4s, v25.8h, v6.8h
    umlsl  v16.4s, v25.4h, v7.4h
    umlsl2 v17.4s, v25.8h, v7.8h
    umlsl  v28.4s, v26.4h, v7.4h
    umlsl2 v29.4s, v26.8h, v7.8h

    sqrshrun  v16.4h, v16.4s, #6
    sqrshrun2 v16.8h, v17.4s, #6
    sqrshrun  v17.4h, v28.4s, #6
    sqrshrun2 v17.8h, v29.4s, #6

    mov x0, x10                     // src += 4*i_src

    umin v16.8h, v16.8h, v8.8h
    umin v17.8h, v17.8h, v8.8h

    subs w5, w5, #4
    st1 {v16.8h}, [x2], x3
    st1 {v17.8h}, [x2], x3
    bgt if_ver_luma_w8_loop_y

    ld1 {v8.2d}, [sp], #16

    ret

//void uavs3e_if_hor_ver_luma_w4_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, const s8 *coeff_h, const s8 *coeff_v, int max_val)
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff_h->x6, coeff_v->x7, max_val->x8
function uavs3e_if_hor_ver_luma_w4_arm64

    ldr w8, [sp]                        // w8 = max_val

    lsl x1, x1, #1
    lsl x3, x3, #1

    // x17-->tmp
    ldr x15, =320                       // (32 + 8) * 4 * sizeof(short)
    sub x0, x0, x1, lsl #1              // src += -3 * i_src;
    sub x17, sp, x15
    sub x0, x0, x1
    mov sp,  x17

    ld1 {v18.d}[0], [x6]
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b
    dup v0.8h, v7.h[0]
    dup v1.8h, v7.h[1]
    dup v2.8h, v7.h[2]
    dup v3.8h, v7.h[3]
    dup v4.8h, v7.h[4]
    dup v5.8h, v7.h[5]
    dup v6.8h, v7.h[6]
    dup v7.8h, v7.h[7]

    sub x0, x0, #6                      // src -= 3
    sub x1, x1, #16

    cmp w8, #255
    bne if_hor_ver_luma_w4_hor_10bit

//--------------------------------
// HOR
//--------------------------------
if_hor_ver_luma_w4_hor:

    ld1 {v22.8b, v23.8b}, [x0], #16     // src[x-3]
    ld1 {v16.4h}, [x0], x1
    ext v24.8b, v22.8b, v23.8b, #2      // src[x-2]
    ext v25.8b, v22.8b, v23.8b, #4      // src[x-1]
    ext v26.8b, v22.8b, v23.8b, #6      // src[x]
    // v23 : src[x+1]
    ext v28.8b, v23.8b, v16.8b, #2
    ext v29.8b, v23.8b, v16.8b, #4
    ext v30.8b, v23.8b, v16.8b, #6

    mul v17.4h, v24.4h, v1.4h
    mls v17.4h, v22.4h, v0.4h
    mls v17.4h, v25.4h, v2.4h
    mla v17.4h, v26.4h, v3.4h
    mla v17.4h, v23.4h, v4.4h
    mls v17.4h, v28.4h, v5.4h
    mla v17.4h, v29.4h, v6.4h
    mls v17.4h, v30.4h, v7.4h

    st1 {v17.4h}, [x17], #8

    add w9, w5, #6                      // loop height+6 times
if_hor_ver_luma_w4_hor_loop_y:
    ld1 {v20.8h}, [x0], #16             // src[x-3]
    ld1 {v16.4h}, [x0], x1
    ld1 {v21.8h}, [x0], #16
    ld1 {v17.4h}, [x0], x1
    zip1 v22.8h, v20.8h, v21.8h
    zip2 v23.8h, v20.8h, v21.8h
    zip1 v20.8h, v16.8h, v17.8h

    ext v24.16b, v22.16b, v23.16b, #4   // src[x-2]
    ext v25.16b, v22.16b, v23.16b, #8   // src[x-1]
    ext v26.16b, v22.16b, v23.16b, #12  // src[x]
    // v23: src[x+1]
    ext v28.16b, v23.16b, v20.16b, #4
    ext v29.16b, v23.16b, v20.16b, #8
    ext v30.16b, v23.16b, v20.16b, #12

    mul v17.8h, v24.8h, v1.8h
    mls v17.8h, v22.8h, v0.8h
    mls v17.8h, v25.8h, v2.8h
    mla v17.8h, v26.8h, v3.8h
    mla v17.8h, v23.8h, v4.8h
    mls v17.8h, v28.8h, v5.8h
    mla v17.8h, v29.8h, v6.8h
    mls v17.8h, v30.8h, v7.8h

    uzp1 v24.8h, v17.8h, v17.8h
    uzp2 v25.8h, v17.8h, v17.8h

    subs w9, w9, #2
    st1 {v24.4h, v25.4h}, [x17], #16
    bgt if_hor_ver_luma_w4_hor_loop_y

    mov x17, sp

//--------------------------------
// VER
//--------------------------------

    // load coeffs
    ld1 {v0.d}[0], [x7]                 // load coeff
    sxtl v0.8h, v0.8b                   // 8bit to 16bit
    dup v31.8h, w8
if_hor_ver_luma_w4_ver_loop_y:
    mov x10, x17
    ld1 {v16.4h, v17.4h, v18.4h, v19.4h}, [x10], #32
    smull v27.4s, v16.4h, v0.h[0]
    smull v28.4s, v17.4h, v0.h[0]
    smull v29.4s, v18.4h, v0.h[0]
    smull v30.4s, v19.4h, v0.h[0]
    mov x17, x10
    ld1 {v20.4h, v21.4h, v22.4h, v23.4h}, [x10], #32
    smlal v27.4s, v17.4h, v0.h[1]
    smlal v28.4s, v18.4h, v0.h[1]
    smlal v29.4s, v19.4h, v0.h[1]
    smlal v30.4s, v20.4h, v0.h[1]

    smlal v27.4s, v18.4h, v0.h[2]
    smlal v28.4s, v19.4h, v0.h[2]
    smlal v29.4s, v20.4h, v0.h[2]
    smlal v30.4s, v21.4h, v0.h[2]

    smlal v27.4s, v19.4h, v0.h[3]
    smlal v28.4s, v20.4h, v0.h[3]
    smlal v29.4s, v21.4h, v0.h[3]
    smlal v30.4s, v22.4h, v0.h[3]

    smlal v27.4s, v20.4h, v0.h[4]
    smlal v28.4s, v21.4h, v0.h[4]
    smlal v29.4s, v22.4h, v0.h[4]
    smlal v30.4s, v23.4h, v0.h[4]

    ld1 {v24.4h, v25.4h}, [x10], #16
    smlal v27.4s, v21.4h, v0.h[5]
    smlal v28.4s, v22.4h, v0.h[5]
    smlal v29.4s, v23.4h, v0.h[5]
    smlal v30.4s, v24.4h, v0.h[5]

    smlal v27.4s, v22.4h, v0.h[6]
    smlal v28.4s, v23.4h, v0.h[6]
    smlal v29.4s, v24.4h, v0.h[6]
    smlal v30.4s, v25.4h, v0.h[6]

    ld1 {v26.d}[0], [x10]
    smlal v27.4s, v23.4h, v0.h[7]
    smlal v28.4s, v24.4h, v0.h[7]
    smlal v29.4s, v25.4h, v0.h[7]
    smlal v30.4s, v26.4h, v0.h[7]

    sqrshrun  v27.4h, v27.4s, #12
    sqrshrun2 v27.8h, v28.4s, #12
    sqrshrun  v28.4h, v29.4s, #12
    sqrshrun2 v28.8h, v30.4s, #12

    umin v27.8h, v27.8h, v31.8h
    umin v28.8h, v28.8h, v31.8h

    subs w5, w5, #4
    st1 {v27.d}[0], [x2], x3
    st1 {v27.d}[1], [x2], x3
    st1 {v28.d}[0], [x2], x3
    st1 {v28.d}[1], [x2], x3
    bgt if_hor_ver_luma_w4_ver_loop_y
    b   if_hor_ver_luma_w4_end

if_hor_ver_luma_w4_hor_10bit:
    ld1 {v22.8b, v23.8b}, [x0], #16     // src[x-3]
    ld1 {v16.4h}, [x0], x1
    ext v24.8b, v22.8b, v23.8b, #2      // src[x-2]
    ext v25.8b, v22.8b, v23.8b, #4      // src[x-1]
    ext v26.8b, v22.8b, v23.8b, #6      // src[x]
    // v23 : src[x+1]
    ext v28.8b, v23.8b, v16.8b, #2
    ext v29.8b, v23.8b, v16.8b, #4
    ext v30.8b, v23.8b, v16.8b, #6

    umull v17.4s, v24.4h, v1.4h
    umlsl v17.4s, v22.4h, v0.4h
    umlsl v17.4s, v25.4h, v2.4h
    umlal v17.4s, v26.4h, v3.4h
    umlal v17.4s, v23.4h, v4.4h
    umlsl v17.4s, v28.4h, v5.4h
    umlal v17.4s, v29.4h, v6.4h
    umlsl v17.4s, v30.4h, v7.4h

    rshrn v17.4h, v17.4s, #2
    st1 {v17.4h}, [x17], #8

    add w9, w5, #6                      // loop height+6 times
if_hor_ver_luma_w4_hor_10bit_loop_y:
    ld1 {v20.8h}, [x0], #16             // src[x-3]
    ld1 {v16.4h}, [x0], x1
    ld1 {v21.8h}, [x0], #16
    ld1 {v17.4h}, [x0], x1
    zip1 v22.8h, v20.8h, v21.8h
    zip2 v23.8h, v20.8h, v21.8h
    zip1 v20.8h, v16.8h, v17.8h

    ext v24.16b, v22.16b, v23.16b, #4   // src[x-2]
    ext v25.16b, v22.16b, v23.16b, #8   // src[x-1]
    ext v26.16b, v22.16b, v23.16b, #12  // src[x]
    // v23: src[x+1]
    ext v28.16b, v23.16b, v20.16b, #4
    ext v29.16b, v23.16b, v20.16b, #8
    ext v30.16b, v23.16b, v20.16b, #12

    umull  v17.4s, v24.4h, v1.4h
    umull2 v18.4s, v24.8h, v1.8h
    umlsl  v17.4s, v22.4h, v0.4h
    umlsl2 v18.4s, v22.8h, v0.8h
    umlsl  v17.4s, v25.4h, v2.4h
    umlsl2 v18.4s, v25.8h, v2.8h
    umlal  v17.4s, v26.4h, v3.4h
    umlal2 v18.4s, v26.8h, v3.8h
    umlal  v17.4s, v23.4h, v4.4h
    umlal2 v18.4s, v23.8h, v4.8h
    umlsl  v17.4s, v28.4h, v5.4h
    umlsl2 v18.4s, v28.8h, v5.8h
    umlal  v17.4s, v29.4h, v6.4h
    umlal2 v18.4s, v29.8h, v6.8h
    umlsl  v17.4s, v30.4h, v7.4h
    umlsl2 v18.4s, v30.8h, v7.8h

    rshrn  v17.4h, v17.4s, #2
    rshrn2 v17.8h, v18.4s, #2

    uzp1 v24.8h, v17.8h, v17.8h
    uzp2 v25.8h, v17.8h, v17.8h

    subs w9, w9, #2
    st1 {v24.4h, v25.4h}, [x17], #16
    bgt if_hor_ver_luma_w4_hor_10bit_loop_y

    mov x17, sp

//--------------------------------
// VER
//--------------------------------

    // load coeffs
    ld1 {v0.d}[0], [x7]                 // load coeff
    sxtl v0.8h, v0.8b                   // 8bit to 16bit
    dup v31.8h, w8
if_hor_ver_luma_w4_ver_10bit_loop_y:
    mov x10, x17
    ld1 {v16.4h, v17.4h, v18.4h, v19.4h}, [x10], #32
    smull v27.4s, v16.4h, v0.h[0]
    smull v28.4s, v17.4h, v0.h[0]
    smull v29.4s, v18.4h, v0.h[0]
    smull v30.4s, v19.4h, v0.h[0]
    mov x17, x10
    ld1 {v20.4h, v21.4h, v22.4h, v23.4h}, [x10], #32
    smlal v27.4s, v17.4h, v0.h[1]
    smlal v28.4s, v18.4h, v0.h[1]
    smlal v29.4s, v19.4h, v0.h[1]
    smlal v30.4s, v20.4h, v0.h[1]

    smlal v27.4s, v18.4h, v0.h[2]
    smlal v28.4s, v19.4h, v0.h[2]
    smlal v29.4s, v20.4h, v0.h[2]
    smlal v30.4s, v21.4h, v0.h[2]

    smlal v27.4s, v19.4h, v0.h[3]
    smlal v28.4s, v20.4h, v0.h[3]
    smlal v29.4s, v21.4h, v0.h[3]
    smlal v30.4s, v22.4h, v0.h[3]

    smlal v27.4s, v20.4h, v0.h[4]
    smlal v28.4s, v21.4h, v0.h[4]
    smlal v29.4s, v22.4h, v0.h[4]
    smlal v30.4s, v23.4h, v0.h[4]

    ld1 {v24.4h, v25.4h}, [x10], #16
    smlal v27.4s, v21.4h, v0.h[5]
    smlal v28.4s, v22.4h, v0.h[5]
    smlal v29.4s, v23.4h, v0.h[5]
    smlal v30.4s, v24.4h, v0.h[5]

    smlal v27.4s, v22.4h, v0.h[6]
    smlal v28.4s, v23.4h, v0.h[6]
    smlal v29.4s, v24.4h, v0.h[6]
    smlal v30.4s, v25.4h, v0.h[6]

    ld1 {v26.d}[0], [x10]
    smlal v27.4s, v23.4h, v0.h[7]
    smlal v28.4s, v24.4h, v0.h[7]
    smlal v29.4s, v25.4h, v0.h[7]
    smlal v30.4s, v26.4h, v0.h[7]

    sqrshrun  v27.4h, v27.4s, #10
    sqrshrun2 v27.8h, v28.4s, #10
    sqrshrun  v28.4h, v29.4s, #10
    sqrshrun2 v28.8h, v30.4s, #10

    umin v27.8h, v27.8h, v31.8h
    umin v28.8h, v28.8h, v31.8h

    subs w5, w5, #4
    st1 {v27.d}[0], [x2], x3
    st1 {v27.d}[1], [x2], x3
    st1 {v28.d}[0], [x2], x3
    st1 {v28.d}[1], [x2], x3
    bgt if_hor_ver_luma_w4_ver_10bit_loop_y

if_hor_ver_luma_w4_end:
    add sp, sp, x15                     // (32 + 8) * 4 * sizeof(short)

    ret

//void uavs3e_if_hor_ver_luma_w8_arm64(const pel *src, int i_src, pel *dst, int i_dst, int width, int height, const s8 *coeff_h, const s8 *coeff_v, int max_val)
//src->x0, i_src->x1, dst->x2, i_dst->x3, width->x4, height->x5, coeff_h->x6, coeff_v->x7, max_val = 255
function uavs3e_if_hor_ver_luma_w8_arm64

    ldr w8, [sp]                            // w8 = max_val

    sub sp, sp, #80
    sub x9, sp, #16
    st1 {v12.2d, v13.2d, v14.2d, v15.2d}, [sp]
    st1 {v11.2d}, [x9]

    lsl x1, x1, #1
    lsl x3, x3, #1

    // x17-->tmp
    mov x15, #72                            // (64 + 8) * 8 * sizeof(short)
    lsl x15, x15, #4
    sub x17, sp, x15
    mov sp,  x17

    sub x0, x0, x1, lsl #1                  // src += -3 * i_src;
    sub x0, x0, x1

    ld1 {v18.d}[0], [x6]
    dup  v11.8h, w8
    abs  v7.8b, v18.8b
    uxtl v7.8h, v7.8b
    dup v0.8h, v7.h[0]
    dup v1.8h, v7.h[1]
    dup v2.8h, v7.h[2]
    dup v3.8h, v7.h[3]
    dup v4.8h, v7.h[4]
    dup v5.8h, v7.h[5]
    dup v6.8h, v7.h[6]
    dup v7.8h, v7.h[7]

    sub x0, x0, #6                          // src -= 3
    cmp w8, #255
    bgt if_hor_ver_luma_w8_10bit

//--------------------------------
// HOR
//--------------------------------
    ld1 {v22.8h, v23.8h}, [x0], x1
    ext v24.16b, v22.16b, v23.16b, #2
    ext v25.16b, v22.16b, v23.16b, #4
    ext v26.16b, v22.16b, v23.16b, #6
    ext v27.16b, v22.16b, v23.16b, #8
    ext v28.16b, v22.16b, v23.16b, #10
    ext v29.16b, v22.16b, v23.16b, #12
    ext v30.16b, v22.16b, v23.16b, #14

    mul v17.8h, v24.8h, v1.8h
    mls v17.8h, v22.8h, v0.8h
    mls v17.8h, v25.8h, v2.8h
    mla v17.8h, v26.8h, v3.8h
    mla v17.8h, v27.8h, v4.8h
    mls v17.8h, v28.8h, v5.8h
    mla v17.8h, v29.8h, v6.8h
    mls v17.8h, v30.8h, v7.8h

    st1 {v17.8h}, [x17], #16

    add w8, w5, #6
if_hor_ver_luma_w8_hor_loop_y:
    ld1 {v20.8h, v21.8h}, [x0], x1           // src[x-3]
    ld1 {v30.8h, v31.8h}, [x0], x1

    ext v22.16b, v20.16b, v21.16b, #2
    ext v23.16b, v20.16b, v21.16b, #4
    ext v24.16b, v20.16b, v21.16b, #6
    ext v25.16b, v20.16b, v21.16b, #8
    ext v26.16b, v20.16b, v21.16b, #10
    ext v27.16b, v20.16b, v21.16b, #12
    ext v28.16b, v20.16b, v21.16b, #14

    ext v12.16b, v30.16b, v31.16b, #2
    ext v13.16b, v30.16b, v31.16b, #4
    ext v14.16b, v30.16b, v31.16b, #6
    ext v15.16b, v30.16b, v31.16b, #8
    ext v21.16b, v30.16b, v31.16b, #10
    ext v29.16b, v30.16b, v31.16b, #12
    ext v31.16b, v30.16b, v31.16b, #14

    mul v16.8h, v22.8h, v1.8h
    mul v17.8h, v12.8h, v1.8h
    mls v16.8h, v20.8h, v0.8h
    mls v17.8h, v30.8h, v0.8h
    mls v16.8h, v23.8h, v2.8h
    mls v17.8h, v13.8h, v2.8h
    mla v16.8h, v24.8h, v3.8h
    mla v17.8h, v14.8h, v3.8h
    mla v16.8h, v25.8h, v4.8h
    mla v17.8h, v15.8h, v4.8h
    mls v16.8h, v26.8h, v5.8h
    mls v17.8h, v21.8h, v5.8h
    mla v16.8h, v27.8h, v6.8h
    mla v17.8h, v29.8h, v6.8h
    mls v16.8h, v28.8h, v7.8h
    mls v17.8h, v31.8h, v7.8h

    subs w8, w8, #2
    st1 {v16.8h, v17.8h}, [x17], #32
    bgt if_hor_ver_luma_w8_hor_loop_y

    mov x17, sp

//--------------------------------
// VER
//--------------------------------

    // load coeffs
    ld1 {v0.d}[0], [x7]                 // load coeff
    sxtl v0.8h, v0.8b                   // 8bit to 16bit

if_hor_ver_luma_w8_ver_loop_y:
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x17], #64
    mov x10, x17
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x17], #64
    ld1 {v24.8h, v25.8h}, [x17], #32
    ld1 {v31.8h}, [x17]

    smull  v26.4s, v16.4h, v0.h[0]
    smull2 v27.4s, v16.8h, v0.h[0]
    smull  v28.4s, v17.4h, v0.h[0]
    smull2 v29.4s, v17.8h, v0.h[0]

    smlal  v26.4s, v17.4h, v0.h[1]
    smlal2 v27.4s, v17.8h, v0.h[1]
    smlal  v28.4s, v18.4h, v0.h[1]
    smlal2 v29.4s, v18.8h, v0.h[1]

    smlal  v26.4s, v18.4h, v0.h[2]
    smlal2 v27.4s, v18.8h, v0.h[2]
    smlal  v28.4s, v19.4h, v0.h[2]
    smlal2 v29.4s, v19.8h, v0.h[2]

    smlal  v26.4s, v19.4h, v0.h[3]
    smlal2 v27.4s, v19.8h, v0.h[3]
    smlal  v28.4s, v20.4h, v0.h[3]
    smlal2 v29.4s, v20.8h, v0.h[3]

    smlal  v26.4s, v20.4h, v0.h[4]
    smlal2 v27.4s, v20.8h, v0.h[4]
    smlal  v28.4s, v21.4h, v0.h[4]
    smlal2 v29.4s, v21.8h, v0.h[4]

    smlal  v26.4s, v21.4h, v0.h[5]
    smlal2 v27.4s, v21.8h, v0.h[5]
    smlal  v28.4s, v22.4h, v0.h[5]
    smlal2 v29.4s, v22.8h, v0.h[5]

    smlal  v26.4s, v22.4h, v0.h[6]
    smlal2 v27.4s, v22.8h, v0.h[6]
    smlal  v28.4s, v23.4h, v0.h[6]
    smlal2 v29.4s, v23.8h, v0.h[6]
    smlal  v26.4s, v23.4h, v0.h[7]
    smlal2 v27.4s, v23.8h, v0.h[7]
    smlal  v28.4s, v24.4h, v0.h[7]
    smlal2 v29.4s, v24.8h, v0.h[7]

    smull  v4.4s, v18.4h, v0.h[0]
    smull2 v5.4s, v18.8h, v0.h[0]
    smull  v6.4s, v19.4h, v0.h[0]
    smull2 v7.4s, v19.8h, v0.h[0]
    smlal  v4.4s, v19.4h, v0.h[1]
    smlal2 v5.4s, v19.8h, v0.h[1]
    smlal  v6.4s, v20.4h, v0.h[1]
    smlal2 v7.4s, v20.8h, v0.h[1]
    smlal  v4.4s, v20.4h, v0.h[2]
    smlal2 v5.4s, v20.8h, v0.h[2]
    smlal  v6.4s, v21.4h, v0.h[2]
    smlal2 v7.4s, v21.8h, v0.h[2]
    smlal  v4.4s, v21.4h, v0.h[3]
    smlal2 v5.4s, v21.8h, v0.h[3]
    smlal  v6.4s, v22.4h, v0.h[3]
    smlal2 v7.4s, v22.8h, v0.h[3]
    smlal  v4.4s, v22.4h, v0.h[4]
    smlal2 v5.4s, v22.8h, v0.h[4]
    smlal  v6.4s, v23.4h, v0.h[4]
    smlal2 v7.4s, v23.8h, v0.h[4]
    smlal  v4.4s, v23.4h, v0.h[5]
    smlal2 v5.4s, v23.8h, v0.h[5]
    smlal  v6.4s, v24.4h, v0.h[5]
    smlal2 v7.4s, v24.8h, v0.h[5]
    smlal  v4.4s, v24.4h, v0.h[6]
    smlal2 v5.4s, v24.8h, v0.h[6]
    smlal  v6.4s, v25.4h, v0.h[6]
    smlal2 v7.4s, v25.8h, v0.h[6]
    smlal  v4.4s, v25.4h, v0.h[7]
    smlal2 v5.4s, v25.8h, v0.h[7]
    smlal  v6.4s, v31.4h, v0.h[7]
    smlal2 v7.4s, v31.8h, v0.h[7]

    sqrshrun  v26.4h, v26.4s, #12
    sqrshrun2 v26.8h, v27.4s, #12
    sqrshrun  v27.4h, v28.4s, #12
    sqrshrun2 v27.8h, v29.4s, #12
    sqrshrun  v28.4h, v4.4s, #12
    sqrshrun2 v28.8h, v5.4s, #12
    sqrshrun  v29.4h, v6.4s, #12
    sqrshrun2 v29.8h, v7.4s, #12

    umin v26.8h, v26.8h, v11.8h
    umin v27.8h, v27.8h, v11.8h
    umin v28.8h, v28.8h, v11.8h
    umin v29.8h, v29.8h, v11.8h

    subs w5, w5, #4
    mov  x17, x10
    st1 {v26.8h}, [x2], x3
    st1 {v27.8h}, [x2], x3
    st1 {v28.8h}, [x2], x3
    st1 {v29.8h}, [x2], x3
    bgt if_hor_ver_luma_w8_ver_loop_y
    b   if_hor_ver_luma_w8_end

if_hor_ver_luma_w8_10bit:
//--------------------------------
// HOR
//--------------------------------
    ld1 {v22.8h, v23.8h}, [x0], x1
    ext v24.16b, v22.16b, v23.16b, #2
    ext v25.16b, v22.16b, v23.16b, #4
    ext v26.16b, v22.16b, v23.16b, #6
    ext v27.16b, v22.16b, v23.16b, #8
    ext v28.16b, v22.16b, v23.16b, #10
    ext v29.16b, v22.16b, v23.16b, #12
    ext v30.16b, v22.16b, v23.16b, #14

    umull  v17.4s, v24.4h, v1.4h
    umull2 v18.4s, v24.8h, v1.8h
    umlsl  v17.4s, v22.4h, v0.4h
    umlsl2 v18.4s, v22.8h, v0.8h
    umlsl  v17.4s, v25.4h, v2.4h
    umlsl2 v18.4s, v25.8h, v2.8h
    umlal  v17.4s, v26.4h, v3.4h
    umlal2 v18.4s, v26.8h, v3.8h
    umlal  v17.4s, v27.4h, v4.4h
    umlal2 v18.4s, v27.8h, v4.8h
    umlsl  v17.4s, v28.4h, v5.4h
    umlsl2 v18.4s, v28.8h, v5.8h
    umlal  v17.4s, v29.4h, v6.4h
    umlal2 v18.4s, v29.8h, v6.8h
    umlsl  v17.4s, v30.4h, v7.4h
    umlsl2 v18.4s, v30.8h, v7.8h

    rshrn  v17.4h, v17.4s, #2
    rshrn2 v17.8h, v18.4s, #2

    st1 {v17.8h}, [x17], #16

    add w8, w5, #6
if_hor_ver_luma_w8_hor_10bit_loop_y:
    ld1 {v20.16b, v21.16b}, [x0], x1           // src[x-3]
    ld1 {v30.16b, v31.16b}, [x0], x1

    ext v22.16b, v20.16b, v21.16b, #2
    ext v23.16b, v20.16b, v21.16b, #4
    ext v24.16b, v20.16b, v21.16b, #6
    ext v25.16b, v20.16b, v21.16b, #8
    ext v26.16b, v20.16b, v21.16b, #10
    ext v27.16b, v20.16b, v21.16b, #12
    ext v28.16b, v20.16b, v21.16b, #14

    ext v12.16b, v30.16b, v31.16b, #2
    ext v13.16b, v30.16b, v31.16b, #4
    ext v14.16b, v30.16b, v31.16b, #6
    ext v15.16b, v30.16b, v31.16b, #8
    ext v21.16b, v30.16b, v31.16b, #10
    ext v29.16b, v30.16b, v31.16b, #12
    ext v31.16b, v30.16b, v31.16b, #14

    umull  v16.4s, v22.4h, v1.4h
    umull2 v17.4s, v22.8h, v1.8h
    umull  v18.4s, v12.4h, v1.4h
    umull2 v19.4s, v12.8h, v1.8h
    umlsl  v16.4s, v20.4h, v0.4h
    umlsl2 v17.4s, v20.8h, v0.8h
    umlsl  v18.4s, v30.4h, v0.4h
    umlsl2 v19.4s, v30.8h, v0.8h
    umlsl  v16.4s, v23.4h, v2.4h
    umlsl2 v17.4s, v23.8h, v2.8h
    umlsl  v18.4s, v13.4h, v2.4h
    umlsl2 v19.4s, v13.8h, v2.8h
    umlal  v16.4s, v24.4h, v3.4h
    umlal2 v17.4s, v24.8h, v3.8h
    umlal  v18.4s, v14.4h, v3.4h
    umlal2 v19.4s, v14.8h, v3.8h
    umlal  v16.4s, v25.4h, v4.4h
    umlal2 v17.4s, v25.8h, v4.8h
    umlal  v18.4s, v15.4h, v4.4h
    umlal2 v19.4s, v15.8h, v4.8h
    umlsl  v16.4s, v26.4h, v5.4h
    umlsl2 v17.4s, v26.8h, v5.8h
    umlsl  v18.4s, v21.4h, v5.4h
    umlsl2 v19.4s, v21.8h, v5.8h
    umlal  v16.4s, v27.4h, v6.4h
    umlal2 v17.4s, v27.8h, v6.8h
    umlal  v18.4s, v29.4h, v6.4h
    umlal2 v19.4s, v29.8h, v6.8h
    umlsl  v16.4s, v28.4h, v7.4h
    umlsl2 v17.4s, v28.8h, v7.8h
    umlsl  v18.4s, v31.4h, v7.4h
    umlsl2 v19.4s, v31.8h, v7.8h

    rshrn  v16.4h, v16.4s, #2
    rshrn2 v16.8h, v17.4s, #2
    rshrn  v17.4h, v18.4s, #2
    rshrn2 v17.8h, v19.4s, #2

    subs w8, w8, #2
    st1 {v16.8h, v17.8h}, [x17], #32
    bgt if_hor_ver_luma_w8_hor_10bit_loop_y

    mov x17, sp

//--------------------------------
// VER
//--------------------------------

    // load coeffs
    ld1 {v0.d}[0], [x7]                 // load coeff
    sxtl v0.8h, v0.8b                   // 8bit to 16bit

if_hor_ver_luma_w8_ver_10bit_loop_y:
    ld1 {v16.8h, v17.8h, v18.8h, v19.8h}, [x17], #64
    mov x10, x17
    ld1 {v20.8h, v21.8h, v22.8h, v23.8h}, [x17], #64
    ld1 {v24.8h, v25.8h}, [x17], #32
    ld1 {v31.8h}, [x17]

    smull  v26.4s, v16.4h, v0.h[0]
    smull2 v27.4s, v16.8h, v0.h[0]
    smull  v28.4s, v17.4h, v0.h[0]
    smull2 v29.4s, v17.8h, v0.h[0]

    smlal  v26.4s, v17.4h, v0.h[1]
    smlal2 v27.4s, v17.8h, v0.h[1]
    smlal  v28.4s, v18.4h, v0.h[1]
    smlal2 v29.4s, v18.8h, v0.h[1]

    smlal  v26.4s, v18.4h, v0.h[2]
    smlal2 v27.4s, v18.8h, v0.h[2]
    smlal  v28.4s, v19.4h, v0.h[2]
    smlal2 v29.4s, v19.8h, v0.h[2]

    smlal  v26.4s, v19.4h, v0.h[3]
    smlal2 v27.4s, v19.8h, v0.h[3]
    smlal  v28.4s, v20.4h, v0.h[3]
    smlal2 v29.4s, v20.8h, v0.h[3]

    smlal  v26.4s, v20.4h, v0.h[4]
    smlal2 v27.4s, v20.8h, v0.h[4]
    smlal  v28.4s, v21.4h, v0.h[4]
    smlal2 v29.4s, v21.8h, v0.h[4]

    smlal  v26.4s, v21.4h, v0.h[5]
    smlal2 v27.4s, v21.8h, v0.h[5]
    smlal  v28.4s, v22.4h, v0.h[5]
    smlal2 v29.4s, v22.8h, v0.h[5]

    smlal  v26.4s, v22.4h, v0.h[6]
    smlal2 v27.4s, v22.8h, v0.h[6]
    smlal  v28.4s, v23.4h, v0.h[6]
    smlal2 v29.4s, v23.8h, v0.h[6]
    smlal  v26.4s, v23.4h, v0.h[7]
    smlal2 v27.4s, v23.8h, v0.h[7]
    smlal  v28.4s, v24.4h, v0.h[7]
    smlal2 v29.4s, v24.8h, v0.h[7]

    smull  v4.4s, v18.4h, v0.h[0]
    smull2 v5.4s, v18.8h, v0.h[0]
    smull  v6.4s, v19.4h, v0.h[0]
    smull2 v7.4s, v19.8h, v0.h[0]
    smlal  v4.4s, v19.4h, v0.h[1]
    smlal2 v5.4s, v19.8h, v0.h[1]
    smlal  v6.4s, v20.4h, v0.h[1]
    smlal2 v7.4s, v20.8h, v0.h[1]
    smlal  v4.4s, v20.4h, v0.h[2]
    smlal2 v5.4s, v20.8h, v0.h[2]
    smlal  v6.4s, v21.4h, v0.h[2]
    smlal2 v7.4s, v21.8h, v0.h[2]
    smlal  v4.4s, v21.4h, v0.h[3]
    smlal2 v5.4s, v21.8h, v0.h[3]
    smlal  v6.4s, v22.4h, v0.h[3]
    smlal2 v7.4s, v22.8h, v0.h[3]
    smlal  v4.4s, v22.4h, v0.h[4]
    smlal2 v5.4s, v22.8h, v0.h[4]
    smlal  v6.4s, v23.4h, v0.h[4]
    smlal2 v7.4s, v23.8h, v0.h[4]
    smlal  v4.4s, v23.4h, v0.h[5]
    smlal2 v5.4s, v23.8h, v0.h[5]
    smlal  v6.4s, v24.4h, v0.h[5]
    smlal2 v7.4s, v24.8h, v0.h[5]
    smlal  v4.4s, v24.4h, v0.h[6]
    smlal2 v5.4s, v24.8h, v0.h[6]
    smlal  v6.4s, v25.4h, v0.h[6]
    smlal2 v7.4s, v25.8h, v0.h[6]
    smlal  v4.4s, v25.4h, v0.h[7]
    smlal2 v5.4s, v25.8h, v0.h[7]
    smlal  v6.4s, v31.4h, v0.h[7]
    smlal2 v7.4s, v31.8h, v0.h[7]

    sqrshrun  v26.4h, v26.4s, #10
    sqrshrun2 v26.8h, v27.4s, #10
    sqrshrun  v27.4h, v28.4s, #10
    sqrshrun2 v27.8h, v29.4s, #10
    sqrshrun  v28.4h, v4.4s, #10
    sqrshrun2 v28.8h, v5.4s, #10
    sqrshrun  v29.4h, v6.4s, #10
    sqrshrun2 v29.8h, v7.4s, #10

    umin v26.8h, v26.8h, v11.8h
    umin v27.8h, v27.8h, v11.8h
    umin v28.8h, v28.8h, v11.8h
    umin v29.8h, v29.8h, v11.8h

    subs w5, w5, #4
    mov x17, x10
    st1 {v26.8h}, [x2], x3
    st1 {v27.8h}, [x2], x3
    st1 {v28.8h}, [x2], x3
    st1 {v29.8h}, [x2], x3
    bgt if_hor_ver_luma_w8_ver_10bit_loop_y

if_hor_ver_luma_w8_end:
    add sp, sp, x15

    ld1 {v12.2d, v13.2d, v14.2d, v15.2d}, [sp], #64
    ld1 {v11.2d}, [sp], #16

    ret

#endif

#endif