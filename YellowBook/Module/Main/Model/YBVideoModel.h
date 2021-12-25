//
//  YBVideoModel.h
//  YellowBook
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBVideoModel : NSObject

+ (NSArray<YBVideoModel *> *)testItems;
+ (NSArray<YBVideoModel *> *)testItemsWithCount: (NSInteger) count;
+ (instancetype) testItem;

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy, nullable) NSString *videoPreviewURL;
@property (nonatomic, copy, nullable) NSString *videoTitle;
@property (nonatomic, copy, nullable) NSString *videoDuration;
@property (nonatomic, copy, nullable) NSString *videoCover;
@property (nonatomic, copy, nullable) NSString *videoAuthor;
@property (nonatomic, copy, nullable) NSString *videoUploadTime;
@property (nonatomic, copy, nullable) NSString *videoFavorites;

@end

NS_ASSUME_NONNULL_END
