//
//  NoteTraceCell.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/16.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKNoteTraceCell.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"
#import "YLYKPlayerViewController.h"

#define kSpace 10
#define imgWidth ([UIScreen mainScreen].bounds.size.width-94-30)/3//高宽相等

@interface YLYKNoteTraceCell ()<SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewsHeight;
@property (weak, nonatomic) IBOutlet UIView *opacityView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, copy) NSString *courseId;

@end

@implementation YLYKNoteTraceCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"YLYKNoteTraceCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setTraceModel:(YLYKTraceModel *)traceModel {
    _timeLineLabel.text = [NSString stringWithFormat:@"%ld",(long)traceModel.listened_time];
    _contentLabel.text = [traceModel.content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    _timeLineLabel.text = [self dateWithDateString:traceModel.in_time];
    self.imagesArray = traceModel.images;
    NSString *courseId = [NSString stringWithFormat:@"%@",[traceModel.course objectForKey:@"id"]];
    NSString *URLString = [NSString stringWithFormat:@"%@course/%@/cover",BASEURL_STRING, courseId];
    [_courseImageView sd_setImageWithURL:[NSURL URLWithString:URLString]];
    _teacherNameLabel.text = traceModel.teacherName;
    _courseNameLabel.text = [traceModel.course objectForKey:@"name"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPlayerController:)];
    _opacityView.userInteractionEnabled = YES;
    [_opacityView addGestureRecognizer:tap];
    self.courseId = courseId;
    if (traceModel.images.count>0) {
        int i = (ceil((float)traceModel.images.count/3));
        self.imageViewsHeight.constant = i * (kSpace+imgWidth);
        [self createImageView:traceModel.images];
    } else {
        _imagesView.hidden = YES;
        self.imageViewsHeight.constant = 0;
    }
}

#pragma mark - 创建ImageView
- (void)createImageView:(NSArray *)images {
    for (UIImageView *imageviews in _imagesView.subviews) {
        [imageviews removeFromSuperview];
    }
    for (NSInteger i=0;i < images.count;i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kSpace+imgWidth)*(i%3)+2,(kSpace+imgWidth)*(i/3)+2, imgWidth-4, imgWidth-4)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.tag = i+100000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [_imagesView addSubview:imageView];
    }
}

#pragma mark - 打开音频播放
- (void)openPlayerController:(UITapGestureRecognizer *)tap {
    [self.myDelegate change:self.courseId];
}


- (void)tapAction:(UITapGestureRecognizer*)tap {
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag - 100000;
    browser.sourceImagesContainerView = self.imagesView;
    browser.imageCount = self.imagesArray.count;
    browser.delegate = self;
    [browser show];
}

- (NSString *)dateWithDateString:(NSInteger)timeInterval {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger delta = [timeZone secondsFromGMT];
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat =@"HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval+delta];
    NSString *timeStr = [matter stringFromDate:date];
    return timeStr;
}

#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *imageName = self.imagesArray[index];
    NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imageView = self.imagesView.subviews[index];
    return imageView.image;
}

-(NSArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSArray array];
    }
    return _imagesArray;
}

@end
