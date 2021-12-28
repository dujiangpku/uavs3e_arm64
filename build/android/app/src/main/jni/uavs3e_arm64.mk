ARM64_SRC_PATH:= $(LOCAL_PATH)/src/armv8

uavs3e_srcs_arm += $(ARM64_SRC_PATH)/arm64.c
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/itrans_arm64.c
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/def_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/pixel_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/itrans_dct2_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/itrans_dct8_dst7_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/inter_pred_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/deblock_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/alf_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/intra_pred_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/cost_arm64.S
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/sao_arm64.c
uavs3e_srcs_arm += $(ARM64_SRC_PATH)/sao_kernel_arm64.S