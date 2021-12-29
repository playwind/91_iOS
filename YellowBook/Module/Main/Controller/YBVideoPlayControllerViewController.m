//
//  YBVideoPlayControllerViewController.m
//  YellowBook
//

#import "YBVideoPlayControllerViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "YB91VideoViewModel.h"
#import "AwemeListCell.h"
#import "SJFloatSmallViewTransitionController.h"
#import "YBPreferenceManager.h"

@interface YBVideoPlayControllerViewController ()
@property (nonatomic, strong) SJVideoPlayer *player;
@property BOOL showFloatWindow;
@end

@implementation YBVideoPlayControllerViewController

// step 1
+ (instancetype)viewControllerWithVideoInfo:(YBVideoModel *)videoInfo {
    YBVideoPlayControllerViewController *instance = nil;
    YBPreferenceManager *preferenceManager = YBPreferenceManager.new;
    BOOL showFloatWindow = [preferenceManager isShowFloatWindowOnBack];
    if (showFloatWindow) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        
        // compare videoId
        for ( __kindof UIViewController *vc in window.SVTC_playbackInFloatingViewControllers ) {
            if ( [vc isKindOfClass:YBVideoPlayControllerViewController.class] ) {
                YBVideoPlayControllerViewController *playbackViewController = vc;
                if ( playbackViewController.videoInfo == videoInfo ) {
                    instance = playbackViewController;
                    break;
                }
            }
        }
    }
    
    if ( instance == nil ) {
        instance = [YBVideoPlayControllerViewController.alloc initWithVideoId:videoInfo];
    }
    instance.showFloatWindow = showFloatWindow;
    return instance;
}

- (instancetype)initWithVideoId:(YBVideoModel *)videoInfo {
    self = [super init];
    if ( self ) {
        _videoInfo = videoInfo;
    }
    return self;
}

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
    _player.resumePlaybackWhenAppDidEnterForeground = YES;
    
    if (_showFloatWindow) {
        // step 2
        _player.floatSmallViewController = SJFloatSmallViewTransitionController.alloc.init;
        __weak typeof(self) _self = self;
        _player.floatSmallViewController.doubleTappedOnTheFloatViewExeBlock = ^(id<SJFloatSmallViewController>  _Nonnull controller) {
            __strong typeof(_self) self = _self;
            if ( self == nil ) return;
            self.player.isPaused ? [self.player play] : [self.player pause];
        };
        
        [self _test];
    }
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

// step 3
- (SJFloatSmallViewTransitionController *_Nullable)SVTC_floatSmallViewTransitionController {
    return (SJFloatSmallViewTransitionController *)_player.floatSmallViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [(SJDYPlaybackListViewController *)self.pageViewController.focusedViewController playIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // step 4
    _player.vc_isDisappeared = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    // step 5
    _player.vc_isDisappeared = YES;
}

- (void)_test {
    _player.defaultFloatSmallViewControlLayer.bottomHeight = 35;
    
    SJEdgeControlButtonItem *playItem = [SJEdgeControlButtonItem.alloc initWithTag:101];
    [playItem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(playOrPause)]];
    [_player.defaultFloatSmallViewControlLayer.bottomAdapter addItem:playItem];
    __weak typeof(self) _self = self;
    _player.playbackObserver.playbackStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        __strong typeof(_self) self = _self;
        if ( self == nil ) return;
        [self _updatePlayItem];
    };
    [self _updatePlayItem];
}

- (void)_updatePlayItem {
    SJEdgeControlButtonItem *playItem = [_player.defaultFloatSmallViewControlLayer.bottomAdapter itemForTag:101];
    playItem.image = self.player.isPaused ? SJVideoPlayerConfigurations.shared.resources.playImage : SJVideoPlayerConfigurations.shared.resources.pauseImage;
    [self.player.defaultFloatSmallViewControlLayer.bottomAdapter reload];
}

- (void)playOrPause {
    self.player.isPaused ? [self.player play] : [self.player pauseForUser];
}

@end
