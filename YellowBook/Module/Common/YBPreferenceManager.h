//
//  YBPreferenceManager.h
//  YellowBook
//
//  Created by forrest on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBPreferenceManager : NSObject

- (BOOL) isShowFloatWindowOnBack;

- (void) setShowFloatWindowOnBack:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
