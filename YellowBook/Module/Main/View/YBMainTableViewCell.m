//
//  YBMainTableViewCell.m
//  YellowBook
//

#import "YBMainTableViewCell.h"

@interface YBMainTableViewCell ()

@property (nonatomic, strong)UIImageView * videoCovers;

@property (nonatomic, strong)UIImageView * authorPhoto;

@property (nonatomic, strong)UILabel * videoTitle;

@property (nonatomic, strong)UILabel * authorName;

@end

@implementation YBMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // _videoCovers = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"cover"]];
        _videoCovers = [[UIImageView alloc] init];
        _videoCovers.contentMode = UIViewContentModeScaleAspectFit;
        _videoCovers.clipsToBounds = YES;
        // _videoCovers.backgroundColor = [UIColor redColor];
        _videoCovers.layer.masksToBounds = YES;
        _videoCovers.layer.cornerRadius = 15;
        _videoCovers.image = [UIImage imageNamed:@"cover"];
        [self.contentView addSubview:_videoCovers];
        
        _videoTitle = [[UILabel alloc] init];
        //_videoTitle.text = @"学了十年代码写的《狂扁小朋友》";
        _videoTitle.textColor = [UIColor blackColor];
        _videoTitle.font = [UIFont systemFontOfSize:14];
        _videoTitle.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_videoTitle];
        
//        _authorPhoto = [[UIImageView alloc] init];
//        _authorPhoto.contentMode = UIViewContentModeScaleAspectFit;
//        //  把图片设置成圆形。  我这里在故事版里面设置的imageView是一个正方形(因为头像图片都是放在正方形的imageView里)
//        _authorPhoto.layer.cornerRadius=20;//裁成圆角
//        _authorPhoto.layer.masksToBounds=YES;//隐藏裁剪掉的部分
//        [self.contentView addSubview: _authorPhoto];
        
        _authorName = [[UILabel alloc] init];
        _authorName.textColor = [UIColor grayColor];
        _authorName.font = [UIFont systemFontOfSize: 12];
        _authorName.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview: _authorName];
        
        [_videoCovers mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top);
            make.size.mas_equalTo(CGSizeMake(376, 235)).priorityHigh();
            make.bottom.mas_equalTo(_videoTitle.mas_top);
        }];
        
//        [_authorPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_videoCovers.mas_left);
//            make.top.equalTo(_videoCovers.mas_bottom).offset(10);
//            make.size.mas_equalTo(CGSizeMake(40, 40)).priorityHigh();
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//        }];
        
        [_videoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoCovers.mas_left).offset(10);
            make.right.equalTo(_videoCovers.mas_right).offset(10);
            make.top.equalTo(_videoCovers.mas_bottom).offset(10);
            make.bottom.mas_equalTo(_authorName.mas_top);
        }];
        
        [_authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_videoTitle);
            make.right.equalTo(_videoTitle);
            make.top.equalTo(_videoTitle.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(10);
        }];
        
        [self setNeedsUpdateConstraints];
        [self setContentMode:UIViewContentModeCenter];
    }
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

// AutoLayout 更新约束
- (void)updateConstraints {
    [super updateConstraints];
}

// 官方文档介绍: Masonry约束不能放在这里
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setVideoInfo:(YBVideoModel *)info {
    [_videoCovers sd_setImageWithURL: [NSURL URLWithString: info.videoCover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

    }];
    
    [_videoTitle setText:info.videoTitle];
    
//    [_authorPhoto sd_setImageWithURL: [NSURL URLWithString: [author valueForKey:@"face"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//    }];
    
    [_authorName setText:info.videoAuthor];
}

@end
