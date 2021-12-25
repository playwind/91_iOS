//
//  YBMainViewControllerTableViewController.h
//  YellowBook
//

#import <UIKit/UIKit.h>
#import "YBSourceURLS.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBMainViewControllerTableViewController : UITableViewController

@property (nonatomic) YB91Category videoCategory;

// 当用户暂停时, 将不会调用播放
- (void)playIfNeeded;

// 暂停播放. 如果该方法调用之前用户已暂停播放了, 当执行此操作时不会影响用户暂停态
- (void)pause;

@end

NS_ASSUME_NONNULL_END
