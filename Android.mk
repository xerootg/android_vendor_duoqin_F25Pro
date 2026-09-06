#
# Stock vendor RRO overlays - BUILD_PREBUILT into /vendor/overlay
# (the build system refuses prebuilt apks in PRODUCT_COPY_FILES)
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := CellbroadcastUIResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/CellbroadcastUIResOverlay/CellbroadcastUIResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/CellbroadcastUIResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FrameworkResOverlayExt
LOCAL_SRC_FILES := proprietary/vendor/overlay/FrameworkResOverlayExt/FrameworkResOverlayExt.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/FrameworkResOverlayExt
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := FrameworkResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/FrameworkResOverlay/FrameworkResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/FrameworkResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MtkSettingsResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/MtkSettingsResOverlay/MtkSettingsResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/MtkSettingsResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := MtkTelephonyServiceResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/MtkTelephonyServiceResOverlay/MtkTelephonyServiceResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/MtkTelephonyServiceResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SettingsProviderResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/SettingsProviderResOverlay/SettingsProviderResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/SettingsProviderResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := SystemUIResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/SystemUIResOverlay/SystemUIResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/SystemUIResOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WifiResMainlineOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/WifiResMainlineOverlay/WifiResMainlineOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/WifiResMainlineOverlay
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := WifiResOverlay
LOCAL_SRC_FILES := proprietary/vendor/overlay/WifiResOverlay/WifiResOverlay.apk
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_SUFFIX := .apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/overlay/WifiResOverlay
include $(BUILD_PREBUILT)
