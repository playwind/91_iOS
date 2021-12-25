//
//  YB91VideoViewModel.h
//  YellowBook
//

#import <Foundation/Foundation.h>
#import "YBSourceURLs.h"
#import "YBVideoModel.h"
NS_ASSUME_NONNULL_BEGIN

@class YBVideoModel;

@interface YB91VideoViewModel : NSObject

- (instancetype) initWithCategory:(YB91Category)category page:(NSInteger)page;

- (void) loadMore:(Boolean)more
          success:(void (^)(NSArray<YBVideoModel *> *videoArray))success
          failure: (void (^)(NSString *message))failure;

- (void) parseVideoUrl:(NSString *)url
               success:(void (^)(NSString *videoURL)) success
               failure:(void (^)(NSString *message)) failure;

@end

NS_ASSUME_NONNULL_END
