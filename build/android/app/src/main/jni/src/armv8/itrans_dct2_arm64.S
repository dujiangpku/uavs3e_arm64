#include "def_arm64.S"

#if defined(__arm64__)

//*************************************************************************************************
//void uavs3d_itrans_dct2_h4_w4_arm64(s16 *src, s16 *dst, int bit_depth);
//x0->coeff blk, 16 bit
//x1->resi blk, 16 bit
//x2->bit_depth
//*************************************************************************************************
function uavs3e_itrans_dct2_h4_w4_arm64
    mov w8, #1
    lsl w8, w8, w2
    sub w4, w2, #20                 // -shift = bit_depth - 20
    sub w9, w8, #1                  // max_pel = (1<<bit_depth) - 1
    neg w8, w8                      // min_pel = -(1<<bit_depth)
    dup v31.4s, w4                  // for left shift

	//load parameters
	ld1	{v0.4h, v1.4h, v2.4h, v3.4h},	[x0]
    mov w5, #32
    mov w6, #42
    mov w7, #17
    mov v4.h[0], w5
	mov v4.h[2], w6
	mov v4.h[3], w7

	/*---first butterfly---*/
	//O[0]
	smull v16.4s, v1.4h, v4.h[2]
	smlal v16.4s, v3.4h, v4.h[3]
	//O[1]
	smull v17.4s, v1.4h, v4.h[3]
	smlsl v17.4s, v3.4h, v4.h[2]
	//E[0]
	smull v18.4s, v0.4h, v4.h[0]
	smlal v18.4s, v2.4h, v4.h[0]
	//E[1]
	smull v19.4s, v0.4h, v4.h[0]
	smlsl v19.4s, v2.4h, v4.h[0]

	sqadd v20.4s, v16.4s, v18.4s
    sqadd v21.4s, v19.4s, v17.4s
    sqsub v22.4s, v19.4s, v17.4s
    sqsub v23.4s, v18.4s, v16.4s

	sqrshrn v0.4h, v20.4s, #5
	sqrshrn v1.4h, v21.4s, #5
	sqrshrn v2.4h, v22.4s, #5
	sqrshrn v3.4h, v23.4s, #5

	//transpose
    trn1 v5.2s, v0.2s, v2.2s
	trn2 v7.2s, v0.2s, v2.2s
	trn1 v6.2s, v1.2s, v3.2s
	trn2 v18.2s, v1.2s, v3.2s
	trn1 v0.4h, v5.4h, v6.4h
	trn2 v1.4h, v5.4h, v6.4h
	trn1 v2.4h, v7.4h, v18.4h
	trn2 v3.4h, v7.4h, v18.4h

	/*---second butterfly---*/
	//O[0]
	smull v16.4s, v1.4h, v4.H[2]
	smlal v16.4s, v3.4h, v4.H[3]
	//O[1]
	smull v17.4s, v1.4h, v4.H[3]
	smlsl v17.4s, v3.4h, v4.H[2]
	//E[0]
	smull v18.4s, v0.4h, v4.H[0]
	smlal v18.4s, v2.4h, v4.H[0]
	//E[1]
	smull v19.4s, v0.4h, v4.H[0]
	smlsl v19.4s, v2.4h, v4.H[0]

	sqadd v20.4s, v16.4s, v18.4s
    sqadd v21.4s, v19.4s, v17.4s
    sqsub v22.4s, v19.4s, v17.4s
    sqsub v23.4s, v18.4s, v16.4s

    srshl v0.4s, v20.4s, v31.4s
    srshl v1.4s, v21.4s, v31.4s
    srshl v2.4s, v22.4s, v31.4s
    srshl v3.4s, v23.4s, v31.4s

    sqxtn v0.4h, v0.4s
    sqxtn v1.4h, v1.4s
    sqxtn v2.4h, v2.4s
    sqxtn v3.4h, v3.4s

    //transpose
    trn1 v5.2s, v0.2s, v2.2s
    trn2 v7.2s, v0.2s, v2.2s
    trn1 v6.2s, v1.2s, v3.2s
    trn2 v18.2s, v1.2s, v3.2s
    trn1 v0.4h, v5.4h, v6.4h
    trn2 v1.4h, v5.4h, v6.4h
    trn1 v2.4h, v7.4h, v18.4h
    trn2 v3.4h, v7.4h, v18.4h

    //clip
	dup v5.4h, w8               //minval
	dup v6.4h, w9               //maxval
	smin v0.4h, v0.4h, v6.4h
	smax v0.4h, v0.4h, v5.4h
	smin v1.4h, v1.4h, v6.4h
	smax v1.4h, v1.4h, v5.4h
	smin v2.4h, v2.4h, v6.4h
	smax v2.4h, v2.4h, v5.4h
	smin v3.4h, v3.4h, v6.4h
	smax v3.4h, v3.4h, v5.4h

	/*---add & store to blk---*/

    st1 {v0.4h, v1.4h, v2.4h, v3.4h}, [x1]

ret

#endif