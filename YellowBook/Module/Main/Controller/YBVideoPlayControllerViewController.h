//
//  YBVideoPlayControllerViewController.h
//  YellowBook
//

#import <UIKit/UIKit.h>
#import "YBVideoModel.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBVideoPlayControllerViewController : BaseViewController

@property (nonatomic, strong) YBVideoModel * videoInfo;

+ (instancetype)viewControllerWithVideoInfo:(YBVideoModel *)videoInfo;

@end

NS_ASSUME_NONNULL_END
