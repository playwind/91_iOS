//
//  YBVideoPlayControllerViewController.m
//  YellowBook
//

#import "YBVideoPlayControllerViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "YB91VideoViewModel.h"
#import "AwemeListCell.h"

@interface YBVideoPlayControllerViewController ()
@property (nonatomic, strong) SJVideoPlayer *player;
@end

@implementation YBVideoPlayControllerViewController

- (void)getVideoUrl {
    [SVProgressHUD show];
    [[[YB91VideoViewModel alloc] init] parseVideoUrl:_videoInfo.videoURL success:^(NSString * _Nonnull videoURL) {
        dispatch_async(dispatch_get_main_queue(),   ^ {
            [SVProgressHUD dismiss];
            NSMutableDictionary * headers = [NSMutableDictionary dictionary];
            [headers setObject:@"https://www.91porn.com/" forKey:@"Referer"];
            //NSString *url = TEST_VIDEO_URL;
            NSString *url = videoURL;
            AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:@{@"AVURLAssetHTTPHeaderFieldsKey" : headers}];
            [self.player setURLAsset: [[SJVideoPlayerURLAsset alloc] initWithAVAsset:asset]];
        });
    } failure:^(NSString * _Nonnull message) {
        NSLog(@"Error: %@", message);
        [SVProgressHUD showErrorWithStatus: @"视频地址解析失败"];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setStatusBarBackgroundColor: [UIColor clearColor]];
    [self setBackgroundImage:@"img_video_loading"];
    [self setLeftButton:@"icon_titlebar_whiteback"];
    [self initViews];
    _player.gestureControl.supportedGestureTypes |= SJPlayerGestureType_LongPress;
    _player.rateWhenLongPressGestureTriggered = 2.0;
    
}

- (void)initViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _player = [SJVideoPlayer player];
    
    UIView *videoContainer = [UIView new];
    [videoContainer addSubview: _player.view];
    //[self.view addSubview: videoContainer];
    
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    AwemeListCell *cell = [[AwemeListCell alloc] init];
    cell.playerView = videoContainer;
    [cell initSubViews];
    [cell initData: _videoInfo];
    [self.view addSubview: cell];
    
    [cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
    [self getVideoUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [(SJDYPlaybackListViewController *)self.pageViewController.focusedViewController playIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)applicationBecomeActive {

}

- (void)applicationEnterBackground {

}

@end
