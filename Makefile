ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoTodayView13

NoTodayView13_FILES = Tweak.xm
NoTodayView13_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += notodayview13prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
