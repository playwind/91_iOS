//
//  YB91VideoViewModel.m
//  YellowBook
//

#import "YB91VideoViewModel.h"
#import "NSString+URLEncode.h"

@interface YB91VideoViewModel ()

@property (nonatomic, assign) YB91Category category;
@property (nonatomic, assign) NSInteger page;

@end

@implementation YB91VideoViewModel

- (instancetype)initWithCategory:(YB91Category)category page:(NSInteger)page {
    self = [super init];
    if (self) {
        self.category = category;
        self.page = page;
    }
    
    return self;
}

- (void) loadMore:(Boolean)more
          success:(void (^)(NSArray<YBVideoModel *> *videoArray))success
          failure: (void (^)(NSString *message))failure {
    if (more) {
        self.page++;
    }
    
    NSString *url = [self getURLByCategory];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"cn_CN" forKey:@"session_language"];
    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"response: %@", htmlString);
        NSMutableArray<YBVideoModel *> * videos = [self parseVideoListFromHtml: htmlString];
        if (success) {
            success(videos);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure([NSString stringWithFormat:@"Error: %@", error]);
        }
    }];
}

- (void) parseVideoUrl:(NSString *)url
               success:(void (^)(NSString *videoURL)) success
               failure:(void (^)(NSString *message)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"response: %@", htmlString);
        @try {
            NSString *url = [self parseVideoURLFromHtml: htmlString];
            if (success) {
                success(url);
            }
        } @catch (NSException *exception) {
            if (failure) {
                failure(@"解析错误");
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure([NSString stringWithFormat: @"%@", error]);
        }
    }];
}

- (NSString *) parseVideoURLFromHtml: (NSString *)htmlString {
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString: htmlString];
    OCQueryObject *videos = document.Query(@"video#player_one");
    if(videos.count == 0) {
        NSLog(@"没发现视频，作为游客每天只能观看15部视频");
        return @"";
    }
    NSString *url = videos.first().Query(@"script").first().html();
    NSRange start = [url rangeOfString:@"strencode2("];
    if (start.location == NSNotFound) {
        return @"";
    }
    NSRange end = [url rangeOfString: @"\")"];
    if (end.location == NSNotFound) {
        return @"";
    }
    NSUInteger startIndex = start.location + 12;
    NSUInteger count = end.location - startIndex;
    url = [url substringWithRange: NSMakeRange(startIndex, count)];
    url = [url URLDecodeUsingEncoding: NSUTF8StringEncoding];
    document = [[OCGumboDocument alloc] initWithHTMLString: url];
    url = document.Query(@"source").first().attr(@"src");
    NSLog(@"video url: %@", url);
    return url;
}

- (NSMutableArray<YBVideoModel *> *) parseVideoListFromHtml: (NSString *)htmlString {
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString: htmlString];
    OCQueryObject *videos = document.Query(@"div.videos-text-align");
    NSLog(@"find video size: %ld", videos.count);
    NSMutableArray<YBVideoModel *> *videoArray = [[NSMutableArray alloc] initWithCapacity:videos.count];
    for (int i = 0; i < videos.count; i++) {
        YBVideoModel *videoModel = [[YBVideoModel alloc] init];
        OCGumboNode *video = videos.get(i);
        OCGumboNode *aTag = video.Query(@"a").first();
        NSString *videoURL = aTag.attr(@"href");
        NSLog(@"视频链接: %@", videoURL);
        videoModel.videoURL = videoURL;
        NSString *videoTitle = aTag.Query(@"span.video-title").first().text();
        NSLog(@"视频标题: %@", videoTitle);
        videoModel.videoTitle = videoTitle;
        NSString *videoCover = aTag.Query(@"img.img-responsive").first().attr(@"src");
        NSLog(@"视频封面: %@", videoCover);
        videoModel.videoCover = videoCover;
        NSString *videoDuration = aTag.Query(@"span.duration").first().text();
        NSLog(@"视频时长: %@", videoDuration);
        videoModel.videoDuration = videoDuration;
        //*[@id="wrapper"]/div[1]/div[3]/div/div/div[1]/div/text()[2]
        NSString *videoContent = video.text();
        NSLog(@"视频内容: %@", videoContent);
        NSRange titleStart = [videoContent rangeOfString:videoTitle];
        if (titleStart.location == NSNotFound) {
            titleStart = NSMakeRange(5, 1);
        }
        NSRange timeStart = [videoContent rangeOfString:@"添加时间"];
        NSRange authorStart = [videoContent rangeOfString:@"作者:"];
        NSRange viewStart = [videoContent rangeOfString:@"查看:"];
        NSRange favStart = [videoContent rangeOfString:@"收藏:"];
        NSRange commentStart = [videoContent rangeOfString:@"留言:"];
        NSRange jifen = [videoContent rangeOfString:@"积分"];
        
        NSString *duration = [videoContent substringToIndex: titleStart.location];
        duration = [duration stringByReplacingOccurrencesOfString:@"HD" withString:@""];
        duration = [duration stringByReplacingOccurrencesOfString:@"91" withString:@""];
        NSString *addTime = [videoContent substringWithRange:NSMakeRange(timeStart.location, authorStart.location - timeStart.location)];
        addTime = [addTime stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *author = [videoContent substringWithRange:NSMakeRange(authorStart.location, viewStart.location - authorStart.location)];
        author = [author stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        author = [author stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        author = [author stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *fav = [videoContent substringWithRange:NSMakeRange(favStart.location, commentStart.location - favStart.location)];
        NSString *comment = [videoContent substringWithRange:NSMakeRange(commentStart.location, jifen.location - commentStart.location)];
        NSString *commentNumber = [comment substringFromIndex: [comment rangeOfString: @"留言:"].location + 3];
        NSString *views = [videoContent substringWithRange:NSMakeRange(viewStart.location, favStart.location - viewStart.location)];
        NSString *favNumber = [fav substringFromIndex: [fav rangeOfString: @"收藏:"].location + 3];
        
        videoModel.videoFavorites = [favNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        videoModel.videoComments = commentNumber;
        videoModel.videoAuthor = author;
        
        videoContent = [NSString stringWithFormat:@"%@\t时长: %@\t%@\n%@\t%@ %@", author, duration, views, addTime, fav, comment];
        videoModel.videoDesc = videoContent;
        [videoArray addObject:videoModel];
    }
    return videoArray;
}

- (NSString *)getURLByCategory {
    NSString *categoryStr = @"";
    int m = 0;
    
    if ((self.category == YB91CategoryLatest)) {
        return [NSString stringWithFormat: @"https://www.91porn.com/v.php?next=watch&page=%ld", (long)self.page];
    }

    switch (self.category) {
        case YB91CategoryMain:
            categoryStr = @"hot";
            break;
        case YB91CategoryOri:
            categoryStr = @"ori";
            break;
        case YB91CategoryHot:
            categoryStr = @"hot";
            break;
        case YB91CategoryTop:
            categoryStr = @"top";
            break;
        case YB91CategoryLong:
            categoryStr = @"long";
            break;
        case YB91CategoryLonger:
            categoryStr = @"longer";
            break;
        case YB91CategoryTf:
            categoryStr = @"tf";
            break;
        case YB91CategoryMf:
            categoryStr = @"mf";
            break;
        case YB91CategoryRf:
            categoryStr = @"rf";
            break;
        case YB91CategoryHD:
            categoryStr = @"hd";
            break;
        case YB91CategoryLastMonthHot:
            categoryStr = @"top";
            m = -1;
            break;
        case YB91CategoryMd:
            categoryStr = @"md";
            break;
        default:
            categoryStr = @"";
            break;
    }
    
    categoryStr = [NSString stringWithFormat:@"https://www.91porn.com/v.php?category=%@&viewtype=basic&page=%ld&m=%d", categoryStr, (long)_page, m];
    
    return categoryStr;
}

@end
