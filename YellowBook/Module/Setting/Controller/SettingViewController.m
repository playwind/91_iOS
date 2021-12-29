//
//  SettingViewController.m
//  Meizi
//
//  Created by Sunnyyoung on 15/7/17.
//  Copyright (c) 2015年 Sunnyyoung. All rights reserved.
//

#import "SettingViewController.h"
#import "../View/CacheSizeLabel+Manager.h"
#import "YBPreferenceManager.h"

@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet CacheSizeLabel *cacheSizeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *floatWindowSwitcher;

@end

@implementation SettingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cacheSizeLabel reloadCacheSize];
    YBPreferenceManager *preferenceManager = YBPreferenceManager.new;
    BOOL isOn = [preferenceManager isShowFloatWindowOnBack];
    [self.floatWindowSwitcher setOn:isOn];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.cacheSizeLabel clearCache];
    } else if (indexPath.row == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/playwind/YellowBook"] options:nil completionHandler:nil];
    }
}
- (IBAction)showFloatWindow:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isOn = [switchButton isOn];
    YBPreferenceManager *preferenceManager = YBPreferenceManager.new;
    [preferenceManager setShowFloatWindowOnBack:isOn];
}

@end
