//
//  YBPreferenceManager.m
//  YellowBook
//
//  Created by forrest on 2021/12/29.
//

#import "YBPreferenceManager.h"

@implementation YBPreferenceManager

- (BOOL)isShowFloatWindowOnBack {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL showFloatWindow = [userDefaults boolForKey:@"showFloatWindowOnBack"];
    return showFloatWindow;
}

- (void)setShowFloatWindowOnBack:(BOOL)isShow {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:@"showFloatWindowOnBack"];
    [userDefaults synchronize];
}

@end
