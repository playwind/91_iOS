//
//  YBVideoModel.m
//  YellowBook
//

#import "YBVideoModel.h"
#import "YBSourceURLs.h"
@implementation YBVideoModel

+ (NSArray<YBVideoModel *> *)testItems {
    return [YBVideoModel testItemsWithCount: 20];
}

+ (NSArray<YBVideoModel *> *)testItemsWithCount:(NSInteger)count {
    NSMutableArray<YBVideoModel *> *items = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        [items addObject: [YBVideoModel testItem]];
    }
    
    return items;
}

+ (instancetype)testItem {
    YBVideoModel *item = [YBVideoModel new];
    item.videoURL = TEST_VIDEO_URL;
    item.videoCover = TEST_VIDEO_COVER;
    item.videoTitle = @"xxx";
    item.videoAuthor = @"奥特曼";
    item.videoDuration = @"2:34";
    item.videoUploadTime = @"2021-10-18 15:12:30";
    item.videoFavorites = @"888";
    
    return item;
}

@end
