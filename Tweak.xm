#define PLIST_PATH @"/var/mobile/Library/Preferences/com.icraze.notodayview13prefs.plist"

@interface SBRootFolderView : UIView
@property(nonatomic, readwrite, assign, getter=isTodayViewPageHidden) BOOL todayViewPageHidden;
@end

static BOOL kEnableOnHomescreen;
static BOOL kEnableOnLockscreen;

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
	kEnableOnHomescreen = [prefs objectForKey:@"kEnableOnHomescreen"] ? [[prefs objectForKey:@"kEnableOnHomescreen"] boolValue] : YES;
	kEnableOnLockscreen = [prefs objectForKey:@"kEnableOnLockscreen"] ? [[prefs objectForKey:@"kEnableOnLockscreen"] boolValue] : YES;
}

%group HS
%hook SBRootFolderView
-(void)didMoveToWindow {
	%orig;
	self.todayViewPageHidden = YES;
}
%end
%end

%group LS
%hook SBMainDisplayPolicyAggregator
-(bool)_allowsCapabilityLockScreenTodayViewWithExplanation:(id)arg1 {
	return NO;
}
%end
%end

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.icraze.notodayview13prefs.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	if (kEnableOnHomescreen) {
		%init(HS);
	}
	if (kEnableOnLockscreen) {
		%init(LS);
	}
}
