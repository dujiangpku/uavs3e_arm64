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

    //if (cbf == 0)
    cmp x7, #0
    beq cbf_zero_w4

recon_w4_loopx:
    //load *resi
    //ld4 {v0.4h,v1.4h,v2.4h,v3.4h}, [x0], #32
    ld1 {v0.4h}, [x0], #8     //read 64bit (4 * s16), resi++
    ld1 {v1.4h}, [x0], #8
    ld1 {v2.4h}, [x0], #8
    ld1 {v3.4h}, [x0], #8

    //load *pred
    //ld1 {v4.4b}, [x1], x2     //read 4 byte
    ld1 {v4.s}[0], [x1], x2     //read 32bit (4 * pel), pred += i_pred
    ld1 {v5.s}[0], [x1], x2
    ld1 {v6.s}[0], [x1], x2
    ld1 {v7.s}[0], [x1], x2

    //integer extend
    uxtl v4.8h, v4.8b
    uxtl v5.8h, v5.8b
    uxtl v6.8h, v6.8b
    uxtl v7.8h, v7.8b

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

    //integer narrow
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
    b recon_w4_end              //jump

cbf_zero_w4:
    //load pred
    ld1 {v4.s}[0], [x1], x2     // load 32bit (4 pel)
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
*  resi->x0, pred->x1, i_pred->x2, width->x3, height->x4, rec->x5, i_rec->x6, int cbf->x7, int bit_depth->
******************************************************************************************************/
function uavs3e_recon_w8_arm64
    //ldr w8, [sp]

    //max_val = (1 << bit_depth) - 1;
    mov w9, #1
    lsl w9, w9, #8
    sub w9, w9, #1
    mov w10, #0

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

#endif

#endif