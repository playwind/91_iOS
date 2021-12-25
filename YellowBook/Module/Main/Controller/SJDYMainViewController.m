//
//  SJDYMainViewController.m
//  SJVideoPlayer_Example
//
//  Created by BlueDancer on 2020/6/12.
//  Copyright © 2020 changsanjiang. All rights reserved.
//

#import "SJDYMainViewController.h"
#import <SJUIKit/SJPageViewController.h>
#import <SJUIKit/UIViewController+SJPageViewControllerExtended.h>
#import <SJUIKit/SJPageMenuBar.h>
#import <SJUIKit/SJPageMenuItemView.h>
#import <Masonry/Masonry.h>
#import <SJFullscreenPopGesture/SJFullscreenPopGesture.h>
#import "YBMainViewControllerTableViewController.h"
#import "YBSourceURLS.h"

typedef NS_ENUM(NSUInteger, DYApplicationState) {
    DYApplicationStateBecomeActive,
    DYApplicationStateResignActive,
};
 
@interface SJDYMainViewController ()<SJPageViewControllerDelegate, SJPageViewControllerDataSource, SJPageMenuBarDataSource, SJPageMenuBarDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong, nullable) SJPageViewController *pageViewController;
@property (nonatomic, strong, nullable) SJPageMenuBar *pageMenuBar;
@property (nonatomic, strong, nullable) SJPageItemManager *pageItemManager;
@property (nonatomic, strong, nullable) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGFloat shift;

@property (nonatomic) DYApplicationState applicationState;
@end

@implementation SJDYMainViewController
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupViews];
    [self _setupGesture];
    [self _setupObservers];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - -[%@ %s]", (int)__LINE__, NSStringFromClass([self class]), sel_getName(_cmd));
#endif
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)_handlePan:(UIPanGestureRecognizer *)pan {
    CGFloat offset = [pan translationInView:pan.view].x;

    switch ( pan.state ) {
        case UIGestureRecognizerStatePossible: break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateBegan: {
            _pageViewController.view.transform = CGAffineTransformIdentity;
            [self playOrPause];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat rate = offset / self.view.bounds.size.width;
            _pageViewController.view.transform = CGAffineTransformMakeTranslation(self.shift * rate, 0);
        }
            break;
        case UIGestureRecognizerStateEnded: {
            BOOL push = -offset > self.shift;
            [UIView animateWithDuration:0.25 animations:^{
                self.pageViewController.view.transform = CGAffineTransformMakeTranslation(push ? -self.shift : 0, 0);
            } completion:^(BOOL finished) {
                self.pageViewController.view.transform = CGAffineTransformIdentity;
                [self playOrPause];
            }];
        }
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

- (void)_setupViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.sj_displayMode = SJPreViewDisplayModeSnapshot;
    self.shift = UIScreen.mainScreen.bounds.size.width * 0.382;
    
    _pageViewController = [SJPageViewController.alloc initWithOptions:nil];
    _pageViewController.edgesForExtendedLayout = UIRectEdgeNone;
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    _pageMenuBar = [SJPageMenuBar.alloc initWithFrame:CGRectZero];
    _pageMenuBar.backgroundColor = UIColor.whiteColor;
    _pageMenuBar.dataSource = self;
    _pageMenuBar.delegate = self;
    _pageMenuBar.distribution = SJPageMenuBarDistributionEqualSpacing;
    _pageMenuBar.scrollIndicatorLayoutMode = SJPageMenuBarScrollIndicatorLayoutModeEqualItemViewLayoutWidth;
    _pageMenuBar.scrollIndicatorSize = CGSizeMake(16, 2);
    _pageMenuBar.itemTintColor = [UIColor blackColor];
    _pageMenuBar.focusedItemTintColor = [UIColor colorWithRed:0.92 green:0.05 blue:0.5 alpha:1];
    _pageMenuBar.scrollIndicatorTintColor = _pageMenuBar.focusedItemTintColor;
    
    _pageItemManager = [SJPageItemManager.alloc init];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryMain]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryLatest]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryOri]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryHot]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryTop]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryLong]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryLonger]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryTf]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryMf]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryRf]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryHD]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryLastMonthHot]];
    [_pageItemManager addPageItem:[self _pageItemWithType:YB91CategoryMd]];
    
    [_pageMenuBar scrollToItemAtIndex:0 animated:NO];

    [self.view addSubview:_pageMenuBar];
    [_pageMenuBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.offset(20);
        }
        //make.centerX.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [_pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(_pageMenuBar.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)_setupGesture {
    _panGesture = [UIPanGestureRecognizer.alloc initWithTarget:self action:@selector(_handlePan:)];
    _panGesture.delegate = self;
    
    UIScrollView *collectionView = [_pageViewController sj_lookupScrollView];
    //[collectionView addGestureRecognizer:_panGesture];
}

- (void)_setupObservers {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationDidBecomeActive {
    _applicationState = DYApplicationStateBecomeActive;
    [self playOrPause];
}

- (void)applicationWillResignActive {
    _applicationState = DYApplicationStateResignActive;
    [self playOrPause];
}

#pragma mark - UIGestureRecognizerDelegate

// 是否允许左滑弹出用户个人主页
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ( _pageViewController.focusedIndex == 0 )
        return NO;
    
    CGPoint translate = [gestureRecognizer translationInView:gestureRecognizer.view];
    UIScrollView *collectionView = [_pageViewController sj_lookupScrollView];
    return !collectionView.isDragging && !collectionView.isDecelerating && translate.x < 0 && translate.y == 0;
}


#pragma mark - SJPageMenuBarDataSource, SJPageViewControllerDataSource, SJPageViewControllerDelegate


// page menu bar

- (NSUInteger)numberOfItemsInPageMenuBar:(SJPageMenuBar *)bar {
    return _pageItemManager.numberOfPageItems;
}

- (__kindof UIView<SJPageMenuItemView> *)pageMenuBar:(SJPageMenuBar *)bar viewForItemAtIndex:(NSInteger)index {
    return [_pageItemManager menuViewAtIndex:index];
}

- (void)pageMenuBar:(SJPageMenuBar *)bar focusedIndexDidChange:(NSUInteger)index {
    if ( ![_pageViewController isViewControllerVisibleAtIndex:index] ) {
        [_pageViewController setViewControllerAtIndex:index];
        YBMainViewControllerTableViewController *cur = [_pageViewController viewControllerAtIndex:index];
        for ( YBMainViewControllerTableViewController *vc in _pageViewController.cachedViewControllers ) {
            if ( cur != vc ) [vc pause];
        }
        [cur playIfNeeded];
    }
}

// page view controller

- (NSUInteger)numberOfViewControllersInPageViewController:(SJPageViewController *)pageViewController {
    return _pageItemManager.numberOfPageItems;
}

- (__kindof UIViewController *)pageViewController:(SJPageViewController *)pageViewController viewControllerAtIndex:(NSInteger)index {
    return [_pageItemManager viewControllerAtIndex:index];
}

- (void)pageViewController:(SJPageViewController *)pageViewController didScrollInRange:(NSRange)range distanceProgress:(CGFloat)progress {
    [_pageMenuBar scrollInRange:range distanceProgress:progress];
}

- (SJPageItem *)_pageItemWithType:(YB91Category)type {
    SJPageMenuItemView *menuView = [SJPageMenuItemView.alloc initWithFrame:CGRectZero];
    menuView.font = [UIFont boldSystemFontOfSize:14];
    switch ( type ) {
        case YB91CategoryMain:
            menuView.text = @"主页";
            break;
        case YB91CategoryLatest:
            menuView.text = @"最新视频";
            break;
        case YB91CategoryOri:
            menuView.text = @"91原创";
            break;
        case YB91CategoryHot:
            menuView.text = @"当前最热";
            break;
        case YB91CategoryTop:
            menuView.text = @"本月最热";
            break;
        case YB91CategoryLong:
            menuView.text = @"10分钟以上";
            break;
        case YB91CategoryLonger:
            menuView.text = @"20分钟以上";
            break;
        case YB91CategoryTf:
            menuView.text = @"本月收藏";
            break;
        case YB91CategoryMf:
            menuView.text = @"收藏最多";
            break;
        case YB91CategoryRf:
            menuView.text = @"最近加精";
            break;
        case YB91CategoryHD:
            menuView.text = @"HD高清";
            break;
        case YB91CategoryLastMonthHot:
            menuView.text = @"上月最热";
            break;
        case YB91CategoryMd:
            menuView.text = @"本月讨论";
            break;
    }
    YBMainViewControllerTableViewController *vc = YBMainViewControllerTableViewController.new;
    vc.videoCategory = type;
    // vc.delegate = self;
    return [SJPageItem.alloc initWithType:type viewController:vc menuView:menuView];
}

#pragma mark -

- (void)pageViewControllerWillBeginDragging:(SJPageViewController *)pageViewController {
    [self playOrPause];
}

- (void)pageViewControllerDidEndDragging:(SJPageViewController *)pageViewController willDecelerate:(BOOL)decelerate {
    if ( !decelerate ) [self playOrPause];
}

- (void)pageViewControllerDidEndDecelerating:(SJPageViewController *)pageViewController {
    [self playOrPause];
}

- (void)pageViewControllerDidScroll:(SJPageViewController *)pageViewController {
    [self playOrPause];
}

#pragma mark -

- (void)playOrPause {
    _applicationState == DYApplicationStateResignActive ||
    _pageViewController.isDragging ||
    _pageViewController.isDecelerating ||
    _panGesture.state == UIGestureRecognizerStateBegan ||
    _panGesture.state == UIGestureRecognizerStateChanged ||
    self.navigationController.topViewController != self ? [self pause] : [self play];
}

- (void)pause {
    for (YBMainViewControllerTableViewController *vc in _pageViewController.cachedViewControllers ) {
        [vc pause];
    }
}

- (void)play {
    [(YBMainViewControllerTableViewController *)_pageViewController.focusedViewController playIfNeeded];
}
@end
