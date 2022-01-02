//
//  YB91CommentViewModel.h
//  YellowBook
//

#import <Foundation/Foundation.h>
#import "YBSourceURLs.h"
#import "YBCommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@class YBVideoModel;

@interface YB91CommentViewModel : NSObject

- (instancetype) initWithVideoId:(NSString *)vid;

- (void) loadDataWithIndex: (NSInteger) page
          success:(void (^)(NSArray<YBCommentModel *> *commentArray))success
          failure: (void (^)(NSString *message))failure;

@end

NS_ASSUME_NONNULL_END
