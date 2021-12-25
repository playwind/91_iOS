//
//  YBSourceURLs.h
//  YellowBook
//

#ifndef YBSourceURLs_h
#define YBSourceURLs_h

/**
 * 主页 （最近加精第一页）
 * 最新视频https://www.91porn.com/v.php?next=watch&page=3
 * ori 91原创
 * hot 当前最热
 * top 本月最热
 * long 10分钟以上
 * longer 20分钟以上
 * tf 本月收藏
 * mf 收藏最多
 * rf 最近加精
 * hd 高清
 * top&m=-1 上月最热https://www.91porn.com/v.php?category=top&m=-1&viewtype=basic
 * md 本月讨论
 */

typedef NS_ENUM(NSUInteger, YB91Category) {
    YB91CategoryMain,//主页
    YB91CategoryLatest,// 最新视频
    YB91CategoryOri,// 91原创
    YB91CategoryHot, // 当前最热
    YB91CategoryTop, // 本月最热
    YB91CategoryLong, // 10分钟以上
    YB91CategoryLonger, //20分钟以上
    YB91CategoryTf, //本月收藏
    YB91CategoryMf, //收藏最多
    YB91CategoryRf, //最近加精
    YB91CategoryHD, //HD高清
    YB91CategoryLastMonthHot, //上月最热
    YB91CategoryMd //本月讨论
};

#define TEST_VIDEO_URL @"https://dh2.v.netease.com/2017/cg/fxtpty.mp4"

#define TEST_VIDEO_COVER @"https://xy2.res.netease.com/pc/zt/20151203150349/images/pic/b3_2a6166c.jpg"

#define VIDEO_CATEGORY_PAGE = @"https://www.91porn.com/v.php?category=%@&viewtype=basic&page=%@"

#endif /* YBSourceURLs_h */
