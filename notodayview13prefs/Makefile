ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoTodayView13Prefs

NoTodayView13Prefs_FILES = NTVRootListController.m
NoTodayView13Prefs_FRAMEWORKS = UIKit
NoTodayView13Prefs_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
NoTodayView13Prefs_INSTALL_PATH = /Library/PreferenceBundles
NoTodayView13Prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
