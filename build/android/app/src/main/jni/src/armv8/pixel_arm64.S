#include "def_arm64.S"
#if defined(__arm64__)

#if !COMPILE_10BIT

/******************************************************************************************************
*  void uavs3e_recon_w4_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w4_arm64
    ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    mov w9, #1
    lsl w9, w9, w8
    sub w9, w9, #1
    mov w10, #0

    cmp x7, #0
    beq cbf_zero_w4

recon_w4_loopx:
    //load *resi
    //ld4 {v0.d,v1.d,v2.d,v3.d}[0], [x0], #32
    ld1 {v0.d}[0], [x0], #8
    ld1 {v1.d}[0], [x0], #8
    ld1 {v2.d}[0], [x0], #8
    ld1 {v3.d}[0], [x0], #8
    //load *pred
    ld1 {v4.8b}, [x1], x2
    ld1 {v5.8b}, [x1], x2
    ld1 {v6.8b}, [x1], x2
    ld1 {v7.8b}, [x1], x2

    uxtl v4.8h, v4.8b
    uxtl v5.8h, v5.8b
    uxtl v6.8h, v6.8b
    uxtl v7.8h, v7.8b

    sqadd v0.8h, v0.8h, v4.8h
    sqadd v1.8h, v1.8h, v5.8h
    sqadd v2.8h, v2.8h, v6.8h
    sqadd v3.8h, v3.8h, v7.8h

    //clip
    dup v4.4h, w9   //max_val
    dup v5.4h, w10  //0
    smin v0.4h, v0.4h, v4.4h
    smax v0.4h, v0.4h, v5.4h
    smin v1.4h, v1.4h, v4.4h
    smax v1.4h, v1.4h, v5.4h
    smin v2.4h, v2.4h, v4.4h
    smax v2.4h, v2.4h, v5.4h
    smin v3.4h, v3.4h, v4.4h
    smax v3.4h, v3.4h, v5.4h

    xtn v0.8b, v0.8h
    xtn v1.8b, v1.8h
    xtn v2.8b, v2.8h
    xtn v3.8b, v3.8h

    //store to blk
    st1 {v0.s}[0], [x5], x6
    st1 {v1.s}[0], [x5], x6
    st1 {v2.s}[0], [x5], x6
    st1 {v3.s}[0], [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w4_loopx
    b recon_w4_end

cbf_zero_w4:
    //load pred
    ld1 {v4.s}[0], [x1], x2
    ld1 {v5.s}[0], [x1], x2
    ld1 {v6.s}[0], [x1], x2
    ld1 {v7.s}[0], [x1], x2

    st1 {v4.s}[0], [x5], x6
    st1 {v5.s}[0], [x5], x6
    st1 {v6.s}[0], [x5], x6
    st1 {v7.s}[0], [x5], x6
    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w4

recon_w4_end:

    ret


/******************************************************************************************************
*  void uavs3e_recon_w8_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7
******************************************************************************************************/
function uavs3e_recon_w8_arm64

    //max_val = (1 << bit_depth) - 1;
    mov w9, #1
    lsl w9, w9, #8
    sub w9, w9, #1
    mov w10, #0

    cmp x7, #0
    beq cbf_zero_w8

recon_w8_loopx:
    //load *resi
    //ld4 {v0.d,v1.d,v2.d,v3.d}[0], [x0], #32
    ld1 {v0.8h}, [x0], #16
    ld1 {v1.8h}, [x0], #16
    ld1 {v2.8h}, [x0], #16
    ld1 {v3.8h}, [x0], #16
    //load *pred
    ld1 {v4.8b}, [x1], x2
    ld1 {v5.8b}, [x1], x2
    ld1 {v6.8b}, [x1], x2
    ld1 {v7.8b}, [x1], x2

    uxtl v4.8h, v4.8b
    uxtl v5.8h, v5.8b
    uxtl v6.8h, v6.8b
    uxtl v7.8h, v7.8b

    sqadd v0.8h, v0.8h, v4.8h
    sqadd v1.8h, v1.8h, v5.8h
    sqadd v2.8h, v2.8h, v6.8h
    sqadd v3.8h, v3.8h, v7.8h

    //clip
    dup v4.8h, w9   //max_val
    dup v5.8h, w10  //0
    smin v0.8h, v0.8h, v4.8h
    smax v0.8h, v0.8h, v5.8h
    smin v1.8h, v1.8h, v4.8h
    smax v1.8h, v1.8h, v5.8h
    smin v2.8h, v2.8h, v4.8h
    smax v2.8h, v2.8h, v5.8h
    smin v3.8h, v3.8h, v4.8h
    smax v3.8h, v3.8h, v5.8h

    xtn v0.8b, v0.8h
    xtn v1.8b, v1.8h
    xtn v2.8b, v2.8h
    xtn v3.8b, v3.8h

    //store to blk
    st1 {v0.d}[0], [x5], x6
    st1 {v1.d}[0], [x5], x6
    st1 {v2.d}[0], [x5], x6
    st1 {v3.d}[0], [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w8_loopx
    b recon_w8_end

cbf_zero_w8:
    //
    ld1 {v4.8b}, [x1], x2
    ld1 {v5.8b}, [x1], x2
    ld1 {v6.8b}, [x1], x2
    ld1 {v7.8b}, [x1], x2
    st1 {v4.d}[0], [x5], x6
    st1 {v5.d}[0], [x5], x6
    st1 {v6.d}[0], [x5], x6
    st1 {v7.d}[0], [x5], x6
    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w8

recon_w8_end:

    ret

#else
// void uavs3e_pel_avrg_4_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height)
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_4_arm64

    lsl x1, x1, #1

    add x10, x1, x1     // i_dst*2
    lsl x12, x1, #2     // i_dst*4
    add x11, x10, x1    // i_dst*3
avg_pel_w4_y:
    ld1 {v0.2d, v1.2d}, [x2], #32
    ld1 {v2.2d, v3.2d}, [x3], #32
    urhadd v0.8h, v0.8h, v2.8h
    urhadd v1.8h, v1.8h, v3.8h

    add  x13, x0, x1
    add  x14, x0, x10
    add  x15, x0, x11
    st1  {v0.d}[0], [x0]
    st1  {v0.d}[1], [x13]
    st1  {v1.d}[0], [x14]
    st1  {v1.d}[1], [x15]

    subs w4, w4, #4
    add x0, x0, x12     // dst += i_dst*4
    bgt avg_pel_w4_y

    ret


// void uavs3e_pel_avrg_8_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height);
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_8_arm64
    lsl x1, x1, #1

avg_pel_w8_y:
    ld1 {v0.2d, v1.2d, v2.2d, v3.2d}, [x2], #64
    ld1 {v4.2d, v5.2d, v6.2d, v7.2d}, [x3], #64

    urhadd v0.8h, v0.8h, v4.8h
    urhadd v1.8h, v1.8h, v5.8h
    urhadd v2.8h, v2.8h, v6.8h
    urhadd v3.8h, v3.8h, v7.8h

    subs w4, w4, #4
    st1  {v0.2d}, [x0], x1
    st1  {v1.2d}, [x0], x1
    st1  {v2.2d}, [x0], x1
    st1  {v3.2d}, [x0], x1

    bgt avg_pel_w8_y

    ret

// void uavs3e_pel_avrg_16_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height);
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_16_arm64
    lsl x1, x1, #1
avg_pel_w16_y:
    ld1 {v0.2d, v1.2d, v2.2d, v3.2d}, [x2], #64
    ld1 {v4.2d, v5.2d, v6.2d, v7.2d}, [x2], #64

    ld1 {v20.2d, v21.2d, v22.2d, v23.2d}, [x3], #64
    ld1 {v24.2d, v25.2d, v26.2d, v27.2d}, [x3], #64

    urhadd v0.8h, v0.8h, v20.8h
    urhadd v1.8h, v1.8h, v21.8h
    urhadd v2.8h, v2.8h, v22.8h
    urhadd v3.8h, v3.8h, v23.8h
    urhadd v4.8h, v4.8h, v24.8h
    urhadd v5.8h, v5.8h, v25.8h
    urhadd v6.8h, v6.8h, v26.8h
    urhadd v7.8h, v7.8h, v27.8h

    subs w4, w4, #4
    st1  {v0.2d, v1.2d}, [x0], x1
    st1  {v2.2d, v3.2d}, [x0], x1
    st1  {v4.2d, v5.2d}, [x0], x1
    st1  {v6.2d, v7.2d}, [x0], x1

    bgt avg_pel_w16_y

    ret

// void uavs3e_pel_avrg_32_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height);
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_32_arm64
    lsl x1, x1, #1
avg_pel_w32_y:
    ld1 {v0.2d, v1.2d, v2.2d, v3.2d}, [x2], #64
    ld1 {v4.2d, v5.2d, v6.2d, v7.2d}, [x2], #64

    ld1 {v20.2d, v21.2d, v22.2d, v23.2d}, [x3], #64
    ld1 {v24.2d, v25.2d, v26.2d, v27.2d}, [x3], #64

    urhadd v0.8h, v0.8h, v20.8h
    urhadd v1.8h, v1.8h, v21.8h
    urhadd v2.8h, v2.8h, v22.8h
    urhadd v3.8h, v3.8h, v23.8h
    urhadd v4.8h, v4.8h, v24.8h
    urhadd v5.8h, v5.8h, v25.8h
    urhadd v6.8h, v6.8h, v26.8h
    urhadd v7.8h, v7.8h, v27.8h

    subs w4, w4, #2
    st1  {v0.2d, v1.2d, v2.2d, v3.2d}, [x0], x1
    st1  {v4.2d, v5.2d, v6.2d, v7.2d}, [x0], x1
    bgt avg_pel_w32_y

    ret

// void uavs3e_pel_avrg_64_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height);
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_64_arm64
    lsl x1, x1, #1
    sub x1, x1, #64
avg_pel_w64_y:
    ld1 {v0.2d, v1.2d, v2.2d, v3.2d}, [x2], #64
    ld1 {v4.2d, v5.2d, v6.2d, v7.2d}, [x2], #64

    ld1 {v20.2d, v21.2d, v22.2d, v23.2d}, [x3], #64
    ld1 {v24.2d, v25.2d, v26.2d, v27.2d}, [x3], #64

    urhadd v0.8h, v0.8h, v20.8h
    urhadd v1.8h, v1.8h, v21.8h
    urhadd v2.8h, v2.8h, v22.8h
    urhadd v3.8h, v3.8h, v23.8h
    urhadd v4.8h, v4.8h, v24.8h
    urhadd v5.8h, v5.8h, v25.8h
    urhadd v6.8h, v6.8h, v26.8h
    urhadd v7.8h, v7.8h, v27.8h

    subs w4, w4, #1
    st1  {v0.2d, v1.2d, v2.2d, v3.2d}, [x0], #64
    st1  {v4.2d, v5.2d, v6.2d, v7.2d}, [x0], x1
    bgt avg_pel_w64_y

    ret


// void uavs3e_pel_avrg_128_arm64(pel *dst, int i_dst, pel *src1, pel *src2, int height);
// dst->x0, i_dst->x1, src1->x2, src2->x3, height->x4
function uavs3e_pel_avrg_128_arm64
    lsl x1, x1, #1
    sub x1, x1, #192
avg_pel_w128_y:
    ld1 {v0.2d, v1.2d, v2.2d, v3.2d}, [x2], #64
    ld1 {v4.2d, v5.2d, v6.2d, v7.2d}, [x2], #64

    ld1 {v20.2d, v21.2d, v22.2d, v23.2d}, [x3], #64
    ld1 {v24.2d, v25.2d, v26.2d, v27.2d}, [x3], #64

    urhadd v0.8h, v0.8h, v20.8h
    urhadd v1.8h, v1.8h, v21.8h
    urhadd v2.8h, v2.8h, v22.8h
    urhadd v3.8h, v3.8h, v23.8h
    urhadd v4.8h, v4.8h, v24.8h
    urhadd v5.8h, v5.8h, v25.8h
    urhadd v6.8h, v6.8h, v26.8h
    urhadd v7.8h, v7.8h, v27.8h

    ld1 {v16.2d, v17.2d, v18.2d, v19.2d}, [x2], #64
    ld1 {v28.2d, v29.2d, v30.2d, v31.2d}, [x2], #64

    ld1 {v20.2d, v21.2d, v22.2d, v23.2d}, [x3], #64
    ld1 {v24.2d, v25.2d, v26.2d, v27.2d}, [x3], #64

    subs w4, w4, #1
    st1  {v0.2d, v1.2d, v2.2d, v3.2d}, [x0], #64
    st1  {v4.2d, v5.2d, v6.2d, v7.2d}, [x0], #64

    urhadd v16.8h, v16.8h, v20.8h
    urhadd v17.8h, v17.8h, v21.8h
    urhadd v18.8h, v18.8h, v22.8h
    urhadd v19.8h, v19.8h, v23.8h
    urhadd v28.8h, v28.8h, v24.8h
    urhadd v29.8h, v29.8h, v25.8h
    urhadd v30.8h, v30.8h, v26.8h
    urhadd v31.8h, v31.8h, v27.8h

    st1  {v16.2d, v17.2d, v18.2d, v19.2d}, [x0], #64
    st1  {v28.2d, v29.2d, v30.2d, v31.2d}, [x0], x1
    bgt avg_pel_w128_y

    ret
#endif

#endif