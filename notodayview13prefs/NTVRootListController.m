#include "NTVRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import <spawn.h>

@implementation NTVRootListController
-(id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)loadView {
	[super loadView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
}

- (void)respring:(id)sender {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SleepSaver" message:@"Applying Settings Will Respring Your Device. Are You Sure You Want To Respring Now?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Not Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
	}];

	UIAlertAction *respring = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		pid_t pid;
		const char* args[] = {"sbreload", NULL, NULL};
		posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
	}];

	[alert addAction:dismiss];
	[alert addAction:respring];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)paypal:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/iCrazeiOS"] options:@{} completionHandler:nil];
}

-(void)github:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/iCrazeiOS"] options:@{} completionHandler:nil];
}
@end
