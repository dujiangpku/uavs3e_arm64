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
/******************************************************************************************************
*  void uavs3e_recon_w4_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w4_arm64
    ldr w8, [sp]        //10

    //max_val = (1 << bit_depth) - 1;
    mov w9, #1
    lsl w9, w9, w8      //10
    sub w9, w9, #1      //max_val
    mov w10, #0

    lsl x2, x2, #1
    lsl x6, x6, #1

    //if (cbf == 0)
    cmp x7, #0
    beq cbf_zero_w4

recon_w4_loopx:
    //load *resi
    //ld4 {v0.4h,v1.4h,v2.4h,v3.4h}, [x0], #32
    ld1 {v0.4h}, [x0], #8
    ld1 {v1.4h}, [x0], #8
    ld1 {v2.4h}, [x0], #8
    ld1 {v3.4h}, [x0], #8

    //load *pred
    //ld1 {v4.4b}, [x1], x2

    ld1 {v4.4h}, [x1], x2
    ld1 {v5.4h}, [x1], x2
    ld1 {v6.4h}, [x1], x2
    ld1 {v7.4h}, [x1], x2

    //加
    sqadd v0.4h, v0.4h, v4.4h
    sqadd v1.4h, v1.4h, v5.4h
    sqadd v2.4h, v2.4h, v6.4h
    sqadd v3.4h, v3.4h, v7.4h

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

    //store to blk
    st1 {v0.4h}, [x5], x6
    st1 {v1.4h}, [x5], x6
    st1 {v2.4h}, [x5], x6
    st1 {v3.4h}, [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w4_loopx
    b recon_w4_end

cbf_zero_w4:
    //load pred
    ld1 {v4.4h}, [x1], x2
    ld1 {v5.4h}, [x1], x2
    ld1 {v6.4h}, [x1], x2
    ld1 {v7.4h}, [x1], x2

    st1 {v4.d}[0], [x5], x6
    st1 {v5.d}[0], [x5], x6
    st1 {v6.d}[0], [x5], x6
    st1 {v7.d}[0], [x5], x6
    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w4

recon_w4_end:

    ret

/******************************************************************************************************
*  void uavs3e_recon_w8_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w8_arm64
    //ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    mov w9, #1
    lsl w9, w9, #10
    sub w9, w9, #1
    mov w10, #0

    lsl x2, x2, #1
    lsl x6, x6, #1

    cmp x7, #0
    beq cbf_zero_w8

recon_w8_loopx:
    //load *resi
    //ld4 {v0.8h,v1.8h,v2.8h,v3.8h}[0], [x0], #64
    ld1 {v0.8h}, [x0], #16
    ld1 {v1.8h}, [x0], #16
    ld1 {v2.8h}, [x0], #16
    ld1 {v3.8h}, [x0], #16

    //load *pred
    ld1 {v4.8h}, [x1], x2
    ld1 {v5.8h}, [x1], x2
    ld1 {v6.8h}, [x1], x2
    ld1 {v7.8h}, [x1], x2

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

    //store to blk
    st1 {v0.8h}, [x5], x6
    st1 {v1.8h}, [x5], x6
    st1 {v2.8h}, [x5], x6
    st1 {v3.8h}, [x5], x6


    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w8_loopx
    b recon_w8_end

cbf_zero_w8:

    ld1 {v4.8h}, [x1], x2
    ld1 {v5.8h}, [x1], x2
    ld1 {v6.8h}, [x1], x2
    ld1 {v7.8h}, [x1], x2

    st1 {v4.2d}, [x5], x6
    st1 {v5.2d}, [x5], x6
    st1 {v6.2d}, [x5], x6
    st1 {v7.2d}, [x5], x6
    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w8

recon_w8_end:

    ret

/******************************************************************************************************
*  void uavs3e_recon_w16_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w16_arm64
    //ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    //bit_depth = 10
    mov w9, #1
    lsl w9, w9, #10
    sub w9, w9, #1
    mov w10, #0

    lsl x2, x2, #1
    lsl x6, x6, #1

    cmp x7, #0
    beq cbf_zero_w16

recon_w16_loopx:

    ld1 {v0.8h,v1.8h}, [x0], #32
    ld1 {v2.8h,v3.8h}, [x0], #32
    ld1 {v4.8h,v5.8h}, [x0], #32
    ld1 {v6.8h,v7.8h}, [x0], #32

    //load *pred
    ld1 {v16.8h, v17.8h}, [x1], x2
    ld1 {v18.8h, v19.8h}, [x1], x2
    ld1 {v20.8h, v21.8h}, [x1], x2
    ld1 {v22.8h, v23.8h}, [x1], x2

    sqadd v0.8h, v0.8h, v16.8h
    sqadd v1.8h, v1.8h, v17.8h
    sqadd v2.8h, v2.8h, v18.8h
    sqadd v3.8h, v3.8h, v19.8h
    sqadd v4.8h, v4.8h, v20.8h
    sqadd v5.8h, v5.8h, v21.8h
    sqadd v6.8h, v6.8h, v22.8h
    sqadd v7.8h, v7.8h, v23.8h

    //clip
    dup v16.8h, w9   //max_val
    dup v17.8h, w10  //0
    smin v0.8h, v0.8h, v16.8h
    smax v0.8h, v0.8h, v17.8h
    smin v1.8h, v1.8h, v16.8h
    smax v1.8h, v1.8h, v17.8h
    smin v2.8h, v2.8h, v16.8h
    smax v2.8h, v2.8h, v17.8h
    smin v3.8h, v3.8h, v16.8h
    smax v3.8h, v3.8h, v17.8h
    smin v4.8h, v4.8h, v16.8h
    smax v4.8h, v4.8h, v17.8h
    smin v5.8h, v5.8h, v16.8h
    smax v5.8h, v5.8h, v17.8h
    smin v6.8h, v6.8h, v16.8h
    smax v6.8h, v6.8h, v17.8h
    smin v7.8h, v7.8h, v16.8h
    smax v7.8h, v7.8h, v17.8h

    //store to blk
    st1 {v0.2d,v1.2d}, [x5], x6
    st1 {v2.2d,v3.2d}, [x5], x6
    st1 {v4.2d,v5.2d}, [x5], x6
    st1 {v6.2d,v7.2d}, [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w16_loopx
    b recon_w16_end

cbf_zero_w16:

    ld1 {v0.8h,v1.8h}, [x1], x2
    ld1 {v2.8h,v3.8h}, [x1], x2
    ld1 {v4.8h,v5.8h}, [x1], x2
    ld1 {v6.8h,v7.8h}, [x1], x2


    st1 {v0.8h,v1.8h}, [x5], x6
    st1 {v2.8h,v3.8h}, [x5], x6
    st1 {v4.8h,v5.8h}, [x5], x6
    st1 {v6.8h,v7.8h}, [x5], x6
    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w16

recon_w16_end:

    ret

/******************************************************************************************************
*  void uavs3e_recon_w32_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w32_arm64

    //ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    //bit_depth = 10

    sub sp, sp, #64
    st1 {v8.8h, v9.8h, v10.8h, v11.8h}, [sp]
    sub sp, sp, #64
    st1 {v12.8h, v13.8h, v14.8h, v15.8h}, [sp]

    mov w9, #1
    lsl w9, w9, #10
    sub w9, w9, #1
    mov w10, #0

    lsl x2, x2, #1
    lsl x6, x6, #1

    cmp x7, #0
    beq cbf_zero_w32

recon_w32_loopx:

    //load *resi
    //ld4 {v0.8h,v1.8h,v2.8h,v3.8h}[0], [x0], #64

    ld1 {v0.8h,v1.8h,v2.8h,v3.8h},      [x0], #64
    ld1 {v4.8h,v5.8h,v6.8h,v7.8h},      [x0], #64
    ld1 {v8.8h,v9.8h,v10.8h,v11.8h},    [x0], #64
    ld1 {v12.8h,v13.8h,v14.8h,v15.8h},  [x0], #64

    //load *pred
    ld1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x1], x2
    ld1 {v20.8h,v21.8h,v22.8h,v23.8h}, [x1], x2
    ld1 {v24.8h,v25.8h,v26.8h,v27.8h}, [x1], x2
    ld1 {v28.8h,v29.8h,v30.8h,v31.8h}, [x1], x2


    sqadd v0.8h, v0.8h, v16.8h
    sqadd v1.8h, v1.8h, v17.8h
    sqadd v2.8h, v2.8h, v18.8h
    sqadd v3.8h, v3.8h, v19.8h
    sqadd v4.8h, v4.8h, v20.8h
    sqadd v5.8h, v5.8h, v21.8h
    sqadd v6.8h, v6.8h, v22.8h
    sqadd v7.8h, v7.8h, v23.8h
    sqadd v8.8h, v8.8h, v24.8h
    sqadd v9.8h, v9.8h, v25.8h
    sqadd v10.8h, v10.8h, v26.8h
    sqadd v11.8h, v11.8h, v27.8h
    sqadd v12.8h, v12.8h, v28.8h
    sqadd v13.8h, v13.8h, v29.8h
    sqadd v14.8h, v14.8h, v30.8h
    sqadd v15.8h, v15.8h, v31.8h

    //clip
    dup v16.8h, w9   //max_val
    dup v17.8h, w10  //0
    smin v0.8h, v0.8h, v16.8h
    smax v0.8h, v0.8h, v17.8h
    smin v1.8h, v1.8h, v16.8h
    smax v1.8h, v1.8h, v17.8h
    smin v2.8h, v2.8h, v16.8h
    smax v2.8h, v2.8h, v17.8h
    smin v3.8h, v3.8h, v16.8h
    smax v3.8h, v3.8h, v17.8h
    smin v4.8h, v4.8h, v16.8h
    smax v4.8h, v4.8h, v17.8h
    smin v5.8h, v5.8h, v16.8h
    smax v5.8h, v5.8h, v17.8h
    smin v6.8h, v6.8h, v16.8h
    smax v6.8h, v6.8h, v17.8h
    smin v7.8h, v7.8h, v16.8h
    smax v7.8h, v7.8h, v17.8h
    smin v8.8h, v8.8h, v16.8h
    smax v8.8h, v8.8h, v17.8h
    smin v9.8h, v9.8h, v16.8h
    smax v9.8h, v9.8h, v17.8h
    smin v10.8h, v10.8h, v16.8h
    smax v10.8h, v10.8h, v17.8h
    smin v11.8h, v11.8h, v16.8h
    smax v11.8h, v11.8h, v17.8h
    smin v12.8h, v12.8h, v16.8h
    smax v12.8h, v12.8h, v17.8h
    smin v13.8h, v13.8h, v16.8h
    smax v13.8h, v13.8h, v17.8h
    smin v14.8h, v14.8h, v16.8h
    smax v14.8h, v14.8h, v17.8h
    smin v15.8h, v15.8h, v16.8h
    smax v15.8h, v15.8h, v17.8h

    //store to blk
    st1 {v0.2d,v1.2d,v2.2d,v3.2d},      [x5], x6
    st1 {v4.2d,v5.2d,v6.2d,v7.2d},      [x5], x6
    st1 {v8.2d,v9.2d,v10.2d,v11.2d},    [x5], x6
    st1 {v12.2d,v13.2d,v14.2d,v15.2d},  [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt recon_w32_loopx
    b recon_w32_end

cbf_zero_w32:

    ld1 {v4.8h,v5.8h,v6.8h,v7.8h}, [x1], x2
    ld1 {v8.8h,v9.8h,v10.8h,v11.8h}, [x1], x2
    ld1 {v12.8h,v13.8h,v14.8h,v15.8h}, [x1], x2
    ld1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x1], x2

    st1 {v4.8h,v5.8h,v6.8h,v7.8h}, [x5], x6
    st1 {v8.8h,v9.8h,v10.8h,v11.8h}, [x5], x6
    st1 {v12.8h,v13.8h,v14.8h,v15.8h}, [x5], x6
    st1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x5], x6

    sub x4, x4, #4
    cmp x4, #0
    bgt cbf_zero_w32

recon_w32_end:

    ld1 {v12.8h, v13.8h, v14.8h, v15.8h}, [sp], #64
    ld1 {v8.8h, v9.8h, v10.8h, v11.8h}, [sp], #64

    ret

/******************************************************************************************************
*  void uavs3e_recon_w64_arm64(s16 *resi, pel *pred, int i_pred, int width, int height, pel *rec, int i_rec, int cbf, int bit_depth)
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w64_arm64

    sub sp, sp, #64
    st1 {v8.8h, v9.8h, v10.8h, v11.8h}, [sp]
    sub sp, sp, #64
    st1 {v12.8h, v13.8h, v14.8h, v15.8h}, [sp]

    //ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    //bit_depth = 10
    mov w9, #1
    lsl w9, w9, #10
    sub w9, w9, #1
    mov w10, #0

    //lsl x2, x2, #1
    //lsl x6, x6, #1

    cmp x7, #0
    beq cbf_zero_w64

recon_w64_loopx:

    //load *resi
    //ld4 {v0.8h,v1.8h,v2.8h,v3.8h}[0], [x0], #64
    ld1 {v0.8h,v1.8h,v2.8h,v3.8h},      [x0], #64
    ld1 {v4.8h,v5.8h,v6.8h,v7.8h},      [x0], #64
    ld1 {v8.8h,v9.8h,v10.8h,v11.8h},    [x0], #64
    ld1 {v12.8h,v13.8h,v14.8h,v15.8h},  [x0], #64

    //load *pred
    ld1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x1], x2
    ld1 {v20.8h,v21.8h,v22.8h,v23.8h}, [x1], x2
    ld1 {v24.8h,v25.8h,v26.8h,v27.8h}, [x1], x2
    ld1 {v28.8h,v29.8h,v30.8h,v31.8h}, [x1], x2


    sqadd v0.8h, v0.8h, v16.8h
    sqadd v1.8h, v1.8h, v17.8h
    sqadd v2.8h, v2.8h, v18.8h
    sqadd v3.8h, v3.8h, v19.8h
    sqadd v4.8h, v4.8h, v20.8h
    sqadd v5.8h, v5.8h, v21.8h
    sqadd v6.8h, v6.8h, v22.8h
    sqadd v7.8h, v7.8h, v23.8h
    sqadd v8.8h, v8.8h, v24.8h
    sqadd v9.8h, v9.8h, v25.8h
    sqadd v10.8h, v10.8h, v26.8h
    sqadd v11.8h, v11.8h, v27.8h
    sqadd v12.8h, v12.8h, v28.8h
    sqadd v13.8h, v13.8h, v29.8h
    sqadd v14.8h, v14.8h, v30.8h
    sqadd v15.8h, v15.8h, v31.8h

    //clip
    dup v16.8h, w9   //max_val
    dup v17.8h, w10  //0
    smin v0.8h, v0.8h, v16.8h
    smax v0.8h, v0.8h, v17.8h
    smin v1.8h, v1.8h, v16.8h
    smax v1.8h, v1.8h, v17.8h
    smin v2.8h, v2.8h, v16.8h
    smax v2.8h, v2.8h, v17.8h
    smin v3.8h, v3.8h, v16.8h
    smax v3.8h, v3.8h, v17.8h
    smin v4.8h, v4.8h, v16.8h
    smax v4.8h, v4.8h, v17.8h
    smin v5.8h, v5.8h, v16.8h
    smax v5.8h, v5.8h, v17.8h
    smin v6.8h, v6.8h, v16.8h
    smax v6.8h, v6.8h, v17.8h
    smin v7.8h, v7.8h, v16.8h
    smax v7.8h, v7.8h, v17.8h
    smin v8.8h, v8.8h, v16.8h
    smax v8.8h, v8.8h, v17.8h
    smin v9.8h, v9.8h, v16.8h
    smax v9.8h, v9.8h, v17.8h
    smin v10.8h, v10.8h, v16.8h
    smax v10.8h, v10.8h, v17.8h
    smin v11.8h, v11.8h, v16.8h
    smax v11.8h, v11.8h, v17.8h
    smin v12.8h, v12.8h, v16.8h
    smax v12.8h, v12.8h, v17.8h
    smin v13.8h, v13.8h, v16.8h
    smax v13.8h, v13.8h, v17.8h
    smin v14.8h, v14.8h, v16.8h
    smax v14.8h, v14.8h, v17.8h
    smin v15.8h, v15.8h, v16.8h
    smax v15.8h, v15.8h, v17.8h

    //store to blk
    st1 {v0.2d,v1.2d,v2.2d,v3.2d},      [x5], x6
    st1 {v4.2d,v5.2d,v6.2d,v7.2d},      [x5], x6
    st1 {v8.2d,v9.2d,v10.2d,v11.2d},    [x5], x6
    st1 {v12.2d,v13.2d,v14.2d,v15.2d},  [x5], x6

    sub x4, x4, #2
    cmp x4, #0
    bgt recon_w64_loopx
    b recon_w64_end


cbf_zero_w64:

    ld1 {v4.8h,v5.8h,v6.8h,v7.8h}, [x1], x2
    ld1 {v8.8h,v9.8h,v10.8h,v11.8h}, [x1], x2
    ld1 {v12.8h,v13.8h,v14.8h,v15.8h}, [x1], x2
    ld1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x1], x2

    st1 {v4.8h,v5.8h,v6.8h,v7.8h}, [x5], x6
    st1 {v8.8h,v9.8h,v10.8h,v11.8h}, [x5], x6
    st1 {v12.8h,v13.8h,v14.8h,v15.8h}, [x5], x6
    st1 {v16.8h,v17.8h,v18.8h,v19.8h}, [x5], x6

    sub x4, x4, #2
    cmp x4, #0
    bgt cbf_zero_w64

recon_w64_end:

    ld1 {v12.8h, v13.8h, v14.8h, v15.8h}, [sp], #64
    ld1 {v8.8h, v9.8h, v10.8h, v11.8h}, [sp], #64

    ret
#endif

#endif