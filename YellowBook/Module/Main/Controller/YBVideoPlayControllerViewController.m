//
//  YBVideoPlayControllerViewController.m
//  YellowBook
//
//  Created by 郑传书 on 2021/12/3.
//

#import "YBVideoPlayControllerViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "YB91VideoViewModel.h"

@interface YBVideoPlayControllerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) UILabel *videoTitle;
@property (nonatomic, strong) UILabel *videoURL;
@end

@implementation YBVideoPlayControllerViewController

- (void)getVideoUrl {
    NSString *url = _videoInfo.videoURL;
    NSLog(@"play video: %@", url);
    [SVProgressHUD show];
    [[[YB91VideoViewModel alloc] init] parseVideoUrl:url success:^(NSString * _Nonnull videoURL) {
        dispatch_async(dispatch_get_main_queue(),   ^ {
            [SVProgressHUD showSuccessWithStatus: @"视频地址解析成功"];
            NSMutableDictionary * headers = [NSMutableDictionary dictionary];
            [headers setObject:@"https://www.91porn.com/" forKey:@"Referer"];
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoURL] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
            [self.player setURLAsset: [[SJVideoPlayerURLAsset alloc] initWithAVAsset:asset]];
            self.videoURL.text = videoURL;
        });
    } failure:^(NSString * _Nonnull message) {
        NSLog(@"Error: %@", message);
        [SVProgressHUD showErrorWithStatus: @"视频地址解析失败"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initViews];
    _player.gestureControl.supportedGestureTypes |= SJPlayerGestureType_LongPress;
    _player.rateWhenLongPressGestureTriggered = 2.0;
}

- (void)initViews {
    self.title = NSStringFromClass(self.class);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    [_containerView addSubview:_player.view];
    
    _videoTitle = [[UILabel alloc] init];
    _videoTitle.numberOfLines = 0;
    [_videoTitle sizeToFit];
    _videoTitle.textColor = [UIColor blackColor];
    _videoTitle.font = [UIFont systemFontOfSize:18];
    _videoTitle.textAlignment = NSTextAlignmentLeft;
    _videoTitle.text = _videoInfo.videoTitle;
    [self.view addSubview:_videoTitle];
    
    _videoURL = [[UILabel alloc] init];
    [_videoURL setNumberOfLines:0];
    [_videoURL sizeToFit];
    [self.view addSubview: _videoURL];
    
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [_videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_containerView).mas_offset(10);
        make.right.mas_equalTo(_containerView);
        make.top.mas_equalTo(_containerView.mas_bottom).mas_offset(10);
    }];
    
    [_videoURL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_containerView).mas_offset(10);
        make.right.mas_equalTo(_containerView);
        make.top.mas_equalTo(_videoTitle.mas_bottom).mas_offset(10);
    }];
    
    [self getVideoUrl];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
