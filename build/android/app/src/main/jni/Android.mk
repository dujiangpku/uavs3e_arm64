LOCAL_PATH   := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := uavs3e-lib
LOCAL_LDLIBS:=-L$(SYSROOT)/usr/lib -lm -llog

LOCAL_C_INCLUDES := $(LOCAL_PATH)/inc  \
                    $(LOCAL_PATH)/test

uavs3e_srcs_c   += $(LOCAL_PATH)/src/alf.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/analyze.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/bitstream.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_alf.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_cost.c          \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_df.c          \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_ipred.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_itdq.c         \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_mc.c               \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_refman.c                 \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_sao.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_tables.c          \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_thread.c          \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_thread_win32.c         \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/com_util.c            \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/entropy.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/inter.c          \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/intra.c             \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/lookahead.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/me.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/quant.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/ratectrl.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/sao.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/tables.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/transform.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/uavs3e.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/src/util.c           \
uavs3e_srcs_c   += $(LOCAL_PATH)/test/utest.c

LOCAL_SRC_FILES := $(uavs3e_srcs_c)

include $(BUILD_SHARED_LIBRARY)