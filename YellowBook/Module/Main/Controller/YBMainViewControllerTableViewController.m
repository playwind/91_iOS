//
//  YBMainViewControllerTableViewController.m
//  YellowBook
//

#import "YBMainViewControllerTableViewController.h"
#import "YBMainTableViewCell.h"
#import "YBVideoPlayControllerViewController.h"
#import "YB91VideoViewModel.h"

@interface YBMainViewControllerTableViewController ()

@property (nonatomic, copy) NSMutableArray<YBVideoModel *> * videoList;

@property (nonatomic, copy) YB91VideoViewModel *viewModel;

@end

@implementation YBMainViewControllerTableViewController

@synthesize videoList = _videoList;
@synthesize videoCategory = _videoCategory;

- (void)loadData {
    [SVProgressHUD show];
    [_viewModel loadMore:false success:^(NSArray<YBVideoModel *> *videoArrays) {
        self->_videoList = videoArrays.mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSString * errorInfo) {
        NSLog(@"%@", errorInfo);
        [SVProgressHUD showErrorWithStatus: errorInfo];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMore {
    [_viewModel loadMore:true success:^(NSArray<YBVideoModel *> *videoArrays) {
        [self.videoList addObjectsFromArray:videoArrays];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSString * errorInfo) {
        NSLog(@"%@", errorInfo);
        [SVProgressHUD showErrorWithStatus: errorInfo];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _viewModel = [[YB91VideoViewModel alloc] initWithCategory:_videoCategory page:1];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction: @selector(loadData)];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.tableView.estimatedRowHeight = 285;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.autoresizesSubviews = NO;
    
    _videoList = [[NSMutableArray alloc] init];

    //[self.tableView.mj_header beginRefreshing];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YBMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoId"];
    if (!cell) {
        cell = [[YBMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoId"];
    }
    
    YBVideoModel *video = [self.videoList objectAtIndex:(indexPath.row)];
    [cell setVideoInfo: video];
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tabBarController.tabBar.hidden=YES;
    YBVideoModel *videoInfo = [self.videoList objectAtIndex:(indexPath.row)];
    YBVideoPlayControllerViewController *videoController = [YBVideoPlayControllerViewController viewControllerWithVideoInfo: videoInfo];
    videoController.hidesBottomBarWhenPushed = true;
    videoController.videoInfo = videoInfo;
    [self.navigationController pushViewController:videoController animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pause {
    
}

- (void)playIfNeeded {
    
}

@end
