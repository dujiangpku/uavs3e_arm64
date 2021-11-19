#include "arm64.h"

#if defined(__arm64__)
void uavs3e_funs_init_arm64()
{
#if(BIT_DEPTH==8)
    uavs3e_funs_handle.recon[0] = uavs3e_recon_w4_arm64;
    uavs3e_funs_handle.recon[1] = uavs3e_recon_w8_arm64;

    uavs3e_funs_handle.itrans_dct2[1][1] = uavs3e_itrans_dct2_h4_w4_arm64;


#else
    //uavs3e_funs_handle.itrans_dct2[1][1] = uavs3e_itrans_dct2_h4_w4_arm64;
    /*
    int i;

    uavs3e_funs_handle.ip_flt_y_hor = uavs3e_if_hor_luma_frame_arm64;
    uavs3e_funs_handle.ip_flt_y_ver = uavs3e_if_ver_luma_frame_arm64;
    uavs3e_funs_handle.ip_flt_y_ver_ext = uavs3e_if_ver_luma_frame_ext_arm64;

    for (i = 0; i < CU_SIZE_NUM; i++) {
        uavs3e_funs_handle.ipcpy[i] = uavs3e_if_cpy_w16x_arm64;
        uavs3e_funs_handle.ipflt[IPFILTER_H_8][i] = uavs3e_if_hor_luma_w8x_arm64;
        uavs3e_funs_handle.ipflt[IPFILTER_V_8][i] = uavs3e_if_ver_luma_w8x_arm64;
        uavs3e_funs_handle.ipflt_ext[IPFILTER_EXT_8][i] = uavs3e_if_hor_ver_luma_w8x_arm64;
    }

    uavs3e_funs_handle.ipcpy[0] = uavs3e_if_cpy_w4_arm64;
    uavs3e_funs_handle.ipcpy[1] = uavs3e_if_cpy_w8_arm64;
    uavs3e_funs_handle.ipcpy[2] = uavs3e_if_cpy_w16_arm64;
    uavs3e_funs_handle.ipflt[IPFILTER_H_8][0] = uavs3e_if_hor_luma_w4_arm64;
    uavs3e_funs_handle.ipflt[IPFILTER_H_8][1] = uavs3e_if_hor_luma_w8_arm64;
    uavs3e_funs_handle.ipflt[IPFILTER_V_8][0] = uavs3e_if_ver_luma_w4_arm64;
    uavs3e_funs_handle.ipflt[IPFILTER_V_8][1] = uavs3e_if_ver_luma_w8_arm64;
    uavs3e_funs_handle.ipflt_ext[IPFILTER_EXT_8][0] = uavs3e_if_hor_ver_luma_w4_arm64;
    uavs3e_funs_handle.ipflt_ext[IPFILTER_EXT_8][1] = uavs3e_if_hor_ver_luma_w8_arm64;

    uavs3e_funs_handle.itrans_dct2[1][1] = uavs3e_itrans_dct2_h4_w4_arm64;
    uavs3e_funs_handle.itrans_dct2[1][2] = uavs3e_itrans_dct2_h4_w8_arm64;
    uavs3e_funs_handle.itrans_dct2[1][3] = uavs3e_itrans_dct2_h4_w16_arm64;
    uavs3e_funs_handle.itrans_dct2[1][4] = uavs3e_itrans_dct2_h4_w32_arm64;

    uavs3e_funs_handle.itrans_dct2[2][1] = uavs3e_itrans_dct2_h8_w4_arm64;
    uavs3e_funs_handle.itrans_dct2[2][2] = uavs3e_itrans_dct2_h8_w8_arm64;
    uavs3e_funs_handle.itrans_dct2[2][3] = uavs3e_itrans_dct2_h8_w16_arm64;
    uavs3e_funs_handle.itrans_dct2[2][4] = uavs3e_itrans_dct2_h8_w32_arm64;
    uavs3e_funs_handle.itrans_dct2[2][5] = uavs3e_itrans_dct2_h8_w64_arm64;

    uavs3e_funs_handle.itrans_dct2[3][1] = uavs3e_itrans_dct2_h16_w4_arm64;
    uavs3e_funs_handle.itrans_dct2[3][2] = uavs3e_itrans_dct2_h16_w8_arm64;
    uavs3e_funs_handle.itrans_dct2[3][3] = uavs3e_itrans_dct2_h16_w16_arm64;
    uavs3e_funs_handle.itrans_dct2[3][4] = uavs3e_itrans_dct2_h16_w32_arm64;
    uavs3e_funs_handle.itrans_dct2[3][5] = uavs3e_itrans_dct2_h16_w64_arm64;

    uavs3e_funs_handle.itrans_dct2[4][1] = uavs3e_itrans_dct2_h32_w4_arm64;
    uavs3e_funs_handle.itrans_dct2[4][2] = uavs3e_itrans_dct2_h32_w8_arm64;
    uavs3e_funs_handle.itrans_dct2[4][3] = uavs3e_itrans_dct2_h32_w16_arm64;
    uavs3e_funs_handle.itrans_dct2[4][4] = uavs3e_itrans_dct2_h32_w32_arm64;
    uavs3e_funs_handle.itrans_dct2[4][5] = uavs3e_itrans_dct2_h32_w64_arm64;

    uavs3e_funs_handle.itrans_dct2[5][2] = uavs3e_itrans_dct2_h64_w8_arm64;
    uavs3e_funs_handle.itrans_dct2[5][3] = uavs3e_itrans_dct2_h64_w16_arm64;
    uavs3e_funs_handle.itrans_dct2[5][4] = uavs3e_itrans_dct2_h64_w32_arm64;
    uavs3e_funs_handle.itrans_dct2[5][5] = uavs3e_itrans_dct2_h64_w64_arm64;

    uavs3e_funs_handle.deblock_luma[0] = uavs3e_deblock_ver_luma_arm64;
    uavs3e_funs_handle.deblock_luma[1] = uavs3e_deblock_hor_luma_arm64;
    uavs3e_funs_handle.deblock_chroma[0] = uavs3e_deblock_ver_chroma_arm64;
    uavs3e_funs_handle.deblock_chroma[1] = uavs3e_deblock_hor_chroma_arm64;

    uavs3e_funs_handle.sao = uavs3e_sao_on_lcu_arm64;
    //uavs3e_funs_handle.alf = uavs3e_alf_one_lcu_sse; // ERROR
    uavs3e_funs_handle.alf_calc = uavs3e_alf_calc_corr_arm64;

    uavs3e_funs_handle.cost_satd[0][0] = uavs3e_had_4x4_arm64;

    uavs3e_funs_handle.recon[0] = uavs3e_recon_w4_arm64;

    uavs3e_funs_handle.pel_diff[0] = uavs3e_pel_diff_4_arm64;
    uavs3e_funs_handle.pel_diff[1] = uavs3e_pel_diff_8_arm64;

    uavs3e_funs_handle.affine_sobel_flt_hor = affine_sobel_flt_hor_arm64;
    uavs3e_funs_handle.affine_sobel_flt_ver = affine_sobel_flt_ver_arm64;
    uavs3e_funs_handle.affine_coef_computer = affine_coef_computer_arm64;
    */
#endif

}
#endif