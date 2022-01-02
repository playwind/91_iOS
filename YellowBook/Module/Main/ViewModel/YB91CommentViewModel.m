//
//  YB91CommentViewModel.m
//  YellowBook
//

#import "YB91CommentViewModel.h"
#import "NSString+URLEncode.h"
#import "YBCommentModel.h"

@interface YB91CommentViewModel ()

@property (nonatomic, assign) NSString *videoId;

@end

@implementation YB91CommentViewModel

- (instancetype)initWithVideoId:(NSString *)vid {
    self = [super init];
    if (self) {
        self.videoId = vid;
    }
    
    return self;
}

- (void) loadDataWithIndex: (NSInteger) page
                   success:(void (^)(NSArray<YBCommentModel *> *commentArray))success
                   failure: (void (^)(NSString *message))failure {
    NSString *url = [NSString stringWithFormat:@"https://www.91porn.com/show_comments2.php?VID=%@&start=%d&comment_per_page=30", _videoId, page];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"cn_CN" forKey:@"session_language"];
    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *htmlString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"response: %@", htmlString);
        NSArray<YBCommentModel *> * comment = [self parseCommentsFromHtml: htmlString];
        if (success) {
            success(comment);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure([NSString stringWithFormat:@"Error: %@", error]);
        }
    }];
}

- (NSArray<YBCommentModel *> *) parseCommentsFromHtml: (NSString *)htmlString {
    NSMutableArray<YBCommentModel *> *comments = [[NSMutableArray alloc] init];
    OCGumboDocument *document = [[OCGumboDocument alloc] initWithHTMLString:htmlString];
    OCQueryObject *queryObjects = document.Query(@"table.comment-divider");
    NSLog(@"find comment size: %ld", queryObjects.count);
    for (int i = 0; i < queryObjects.count; i++) {
        YBCommentModel *commentModel = YBCommentModel.new;
        OCGumboNode *comment = queryObjects.get(i);
        OCGumboNode *td = comment.Query(@"td").first();
        NSString *content = td.text();
        NSLog(@"comment: %@", content);
        content = [content stringByReplacingOccurrencesOfString:@"举报" withString:@""];
        commentModel.commentTitle = @"";
        commentModel.commentContent = content;
        [comments addObject:commentModel];
    }
    
    return comments;
}

@end
