//
//  YBMainTableViewCell.h
//  YellowBook
//

#import <UIKit/UIKit.h>
#import "YBVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBMainTableViewCell : UITableViewCell

- (void)setVideoInfo: (YBVideoModel *)info;

@end

NS_ASSUME_NONNULL_END
