//
//  YLYKIpadPlayerViewController.m
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKIpadPlayerViewController.h"
#import "YLYKPlayerHeaderView.h"
#import "YLYKPlayerControlView.h"
#import "YLYKPlayerContentView.h"
#import "YLYKPlayerContentFooterView.h"
#import "YLYKCourseServiceModule.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "YLYKCourseModel.h"
#import "YLYKAlbumModel.h"
#import "YLYKAlbumListModel.h"
#import "YLYKTimeTool.h"
#import "YLYKPlayerManager.h"
#import "NSStringTools.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TZImagePickerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "HWWeakTimer.h"
#import "YLYKDownloadNativeModule.h"
#import "YLYKCourseServiceModule.h"
#import "YLYKUmoneyServiceModule.h"
#import "YLYKServiceModule.h"
#import "YLYKAlbumServiceModule.h"
#import "AppDelegate.h"
#import "NoteListViewController.h"
#import "YLYKSlider.h"
#import "JECalourseView.h"
#import "CBLProgressHUD.h"
#import "AlbumListView.h"
#import "AlbumTableViewCell.h"
#import "YLYKImagePickerController.h"
#import <QiniuSDK.h>
#import "YLYKUploadImageTool.h"
#import "Reachability.h"
#import "JXFileHandle.h"
#import "LoginViewController.h"
#import <Bugout/Bugout.h>
#import "SendNoteEvent.h"
#import <AVFoundation/AVFoundation.h>
@import CoreTelephony;



@interface YLYKIpadPlayerViewController () <UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate,TZImagePickerControllerDelegate,UIGestureRecognizerDelegate,playFinshhCallbackDelegate,UITableViewDelegate,UITableViewDataSource> {
    YLYKPlayerHeaderView * playerHeaderView;   //播放信息头视图
    YLYKPlayerControlView * playerControlView; //播放控制视图
    YLYKPlayerContentView * playerContentView; //播放内容视图
    YLYKPlayerContentFooterView * playerContentFooterView; //播放内容底部视图
    UIImageView *playImageView; //播放图片信息
    
    CLLocationManager *locationManager;
    NSString *currentCity; //当前城市
    NSInteger totalLearnTime;
    NSInteger totalListenTime;
    BOOL liked;
    NSInteger localImageCount;
    float lastValue;
    
    CTCallCenter *callCenter;   //为了避免形成retain cycle而声明的一个变量，指向接收通话中心对象
    
    NSString *kPlaceholderText;
    NSString *cancelLoadFromWWAN;
    
    YLYKDirection direction;
    
    //心得按钮 用于隐藏
    UIButton *noteBtn;
    
    //播放头列表
    UIView *playHeaderListView;
    
}

@property (strong, nonatomic) UIView *maskView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableBgView;
// 黑色半透明蒙版
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *bgImgView;
// 文字的渐变的透明背景图。
@property (nonatomic, strong) UIButton *rateBtn;
@property (nonatomic, strong) UIButton *cycleBtn;
@property (nonatomic, assign) float learnSeconds;
@property (nonatomic, assign) float listenSeconds;
@property (nonatomic, assign) double rate;
@property (nonatomic, copy) NSString *duration;
// 当前课程所属专辑列表
@property (nonatomic, copy) NSArray *albumListArray;
@property (nonatomic, strong) YLYKAlbumModel *album;
// 当前播放课程在专辑中的位置
@property (nonatomic, assign) NSInteger currentCourseIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) NSTimer *listenTimer;
//当前播放的课程模型
@property (nonatomic, strong) YLYKCourseModel *currentModel;
// 暂停或者播放
@property (nonatomic, assign) BOOL playOrPause;
// 循环播放类型
@property (nonatomic, assign) NSInteger cycle;
@property (nonatomic, strong) YLYKPlayerManager *playerManager;
@property (nonatomic, strong) UIView *noteView;
// 定位按钮
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, assign) CGFloat fontsize;
@property (nonatomic, strong) UIButton *fontBtn;
@property (nonatomic, strong) UILabel *cornerLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *pptImgBtn;
@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UILabel *placeHolderLabel;
//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//缓存音乐图片
@property (nonatomic, strong) NSMutableDictionary *musicImageDic;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *fileKeysArr;
@property (nonatomic, strong) NSMutableDictionary *offLineCourseDict;

@end

@implementation YLYKIpadPlayerViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    direction = YLYKDirectionViretial;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
    [self loadViewData];
    
    
    kPlaceholderText = @"请写下您的心得";
    
    [BugoutConfig defaultConfig].enabledShakeFeedback = NO;
    [self.playerManager pause];
    self.playOrPause = YES;
    lastValue = 0.0;
    self.cycle = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cycle"] integerValue];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"use4G"];
    self.rate = 1.0;
    //    [self.view bringSubviewToFront:self.writeNoteBtn];
    //    [self createSlider];
    //    CGRect webviewframe = self.webView.scrollView.subviews[0].frame;
    //    webviewframe = CGRectMake(0, 30, self.webView.frame.size.width, self.webView.frame.size.height);
    //    self.webView.scrollView.subviews[0].frame = webviewframe;
    //    self.webView.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
    //    self.webView.userInteractionEnabled = YES;
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteClose:)];
    self.tap.delegate = self;
    //[self.webView addGestureRecognizer:self.tap];
    //    self.slider.value = 0;
    //    self.progressView.progress = 0;
    [self registerForKeyboardNotifications];
    
    playerControlView.slider.value = 0;
    playerControlView.progressView.progress = 0;
    
    
    
    
    
    // 移除上传失败的时间
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"listen"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"learn"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dateTime"];
    
    [self aboutCall];//监听电话通知
    
    //当旋转屏幕时 会发出通知
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation=YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    // 接收远程的是否暂停事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationPlayOrPause) name:@"playerStatusChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreptionNotificationPlayOrPause) name:@"handleInterreption" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otherHandleInterreptionNotificationPause) name:@"otherHandleInterreption" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remoteControllerNotification:) name:@"remoteControllerNotification" object:nil];
    // 暂停上次
    [[YLYKPlayerManager sharedPlayer] pause];
    //[CBLProgressHUD showLoadingHUDInView:self.view];
    // 判断是否缓存
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%li",(long)self.courseID]];
    if (obj) {
        // 更新课程内容
        [YLYKCourseServiceModule getCourseById:[NSString stringWithFormat:@"%ld",(long)self.courseID] success:^(id responseObject) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:[NSString stringWithFormat:@"%li",(long)self.courseID]];
        } failure:^(NSError *error) {
            [self getErrorCodeWithError:error];
        }];
        
        if ([self isDownloadCoursePathWithCourseId:self.courseID andUserId:self.useID]) {
            self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"download_high"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [self createPlayerWithObj:obj];
        __weak typeof(self) weakSelf = self;
        self.playerManager.cycleBlock = ^void(int cycle){
            if (cycle == 0) {
                [weakSelf playOrPause:nil];
            }
        };
    } else {
        [self loadData];
    }
    
    //初始化原始数据
    [self loadOriginData];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = YES;
    if (direction == YLYKDirectionViretial) {
        
    } else if (direction == YLYKDirectionHoriztion) {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    [self registerForKeyboardNotifications];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    UIImage *downloadImg = [UIImage imageNamed:@"download"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    downloadImg = [downloadImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:downloadImg style:UIBarButtonItemStyleDone target:self action:@selector(downloadCourse:)];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    //接收是否完成下载
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadCourseFinish:) name:[NSString stringWithFormat:@"downloadFinish%ld",(long)self.courseID ] object:nil];
    
    if ([self isDownloadCoursePathWithCourseId:self.courseID andUserId:self.useID]) {
        UIImage *downloadImg = [UIImage imageNamed:@"download_hight"];
        downloadImg = [downloadImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem.image =  downloadImg;
    }
    if (self.isFromDownload) {
        self.albumListArray = self.downloadedArray;
        for (NSInteger i = 0; i<self.albumListArray.count; i++) {
            if ( self.courseID == [[self.albumListArray[i] objectForKey:@"id"] integerValue]) {
                self.currentCourseIndex = i;
            }
        }
    } else {
        [self getAlbumListWithAlbum:[[self.currentModel.album objectForKey:@"id" ] integerValue]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (direction == YLYKDirectionViretial) {

    } else if (direction == YLYKDirectionHoriztion) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;

}

- (void)configView {
    //初始化创建
    
    CGFloat navBarHeight = 64;
    if (direction == YLYKDirectionHoriztion) {
        playerHeaderView = [[YLYKPlayerHeaderView alloc] initWithFrame:CGRectMake(0, 109 - navBarHeight, 512, 49)];
        playImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(20, playerHeaderView.bottom + 82, 417, 234)];
        
        playerControlView = [[YLYKPlayerControlView alloc] initWithFrame:CGRectMake(0, playImageView.bottom + 140, 417, 154)];
        playerControlView.direction = YLYKDirectionHoriztion;
        [playerControlView loadView];
        
        playerContentView = [[YLYKPlayerContentView alloc]initWithFrame:CGRectMake(playImageView.right + 89, 100 - navBarHeight, 478, 543)];
        playerContentFooterView = [[YLYKPlayerContentFooterView alloc]initWithFrame:CGRectMake(512, playerContentView.bottom + 26, 512, 99)];
        
        [self.view addSubview:playerHeaderView];
        [self.view addSubview:playImageView];
        [self.view addSubview:playerControlView];
        [self.view addSubview:playerContentView];
        [self.view addSubview:playerContentFooterView];
        
    } else if (direction == YLYKDirectionViretial) {
        playerHeaderView = [[YLYKPlayerHeaderView alloc] initWithFrame:CGRectMake(0, 74 - navBarHeight, SCREEN_WIDTH, 49)];
        playImageView    = [[UIImageView alloc] initWithFrame:CGRectMake(176, playerHeaderView.bottom + 30, 417, 234)];
        
        playerContentView = [[YLYKPlayerContentView alloc]initWithFrame:CGRectMake(80, playImageView.bottom + 21, 608, 461)];
        
        playerControlView = [[YLYKPlayerControlView alloc] initWithFrame:CGRectMake(0, playerContentView.bottom, 768, 155)];
        playerControlView.direction = YLYKDirectionViretial;
        [playerControlView loadView];
        
        playerContentFooterView = [[YLYKPlayerContentFooterView alloc]initWithFrame:CGRectMake(512, playerContentView.bottom + 26, 512, 99)];
        
        [self.view addSubview:playerHeaderView];
        [self.view addSubview:playImageView];
        [self.view addSubview:playerContentView];
        [self.view addSubview:playerControlView];
        [self.view addSubview:playerContentFooterView];
        
        playerContentFooterView.hidden = YES;
    }
}

//旋转改变frame
- (void)changeFrameWhenRotate {
    CGFloat navBarHeight = 64;
    if (!playerHeaderView) {
        [self configView];
    } else {
        if (direction == YLYKDirectionHoriztion) {
            
            [playerHeaderView setFrame:CGRectMake(20, 109 - navBarHeight, 417, 49)];
            playImageView.frame = CGRectMake(20, playerHeaderView.bottom + 82, 417, 234);
            playerControlView.frame = CGRectMake(0, playImageView.bottom + 140, 437, 154);
            playerControlView.direction = YLYKDirectionHoriztion;
            [playerControlView loadView];
            
            playerContentView.frame = CGRectMake(playImageView.right + 89, 100 - navBarHeight, 478, 543);
            playerContentFooterView.frame = CGRectMake(518, playerContentView.bottom + 26, 506, 99);
            
            [playerHeaderView updateFrame];
            [playerContentView updateFrame];
            playerContentFooterView.hidden = NO;
            
        } else if (direction == YLYKDirectionViretial) {
            [playerHeaderView setFrame:CGRectMake(0, 74 - navBarHeight, 768, 49)];
            playImageView.frame = CGRectMake(176, playerHeaderView.bottom + 30, 417, 234);
            playerContentView.frame = CGRectMake(80, playImageView.bottom + 21, 608, 461);
            playerControlView.frame = CGRectMake(0, playerContentView.bottom, 768, 155);
            playerControlView.direction = YLYKDirectionViretial;
            [playerControlView loadView];
            playerContentFooterView.hidden = YES;
            
            [playerHeaderView updateFrame];
            [playerContentView updateFrame];
        }
    }
}

- (void)createNoteView {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = NO;
    self.bgView.hidden = NO;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(hideNoteView:) forControlEvents:UIControlEventTouchUpInside];
    noteBtn = btn;
    [self.bgView addSubview:btn];
    
    self.noteView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-170, SCREEN_WIDTH,170)];
    //    [[UIApplication sharedApplication].delegate.window addSubview:self.noteView];
    [self.bgView addSubview:self.noteView];
    self.noteView.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 110)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8; //行距
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17],NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    self.textView.attributedText = [[NSAttributedString alloc]initWithString: self.textView.text attributes:attributes];
    self.textView.textColor = [UIColor lightGrayColor];
    [self.noteView addSubview:self.textView];
    self.textView.delegate = self;
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 50)];
    toolView.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:251 /255.0 alpha:1.0];
    [self.noteView addSubview:toolView];
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.playerManager isPlaying]) {
        [playBtn setImage:[UIImage imageNamed:@"note_pause"] forState:UIControlStateNormal];
    } else {
        [playBtn setImage:[UIImage imageNamed:@"note_play"] forState:UIControlStateNormal];
    }
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 15, 1, 20)];
    lineView.image = [UIImage imageNamed:@"oval"];
    [toolView addSubview:lineView];
    
    [playBtn addTarget:self action:@selector(playOrPauseNote:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.frame = CGRectMake(20, 10, 30, 30);
    [toolView addSubview:playBtn];
    
    [toolView addSubview:self.imgBtn];
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 30, 30)];
    [publishBtn setImage:[UIImage imageNamed:@"note_sent"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishNote) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:publishBtn];
    [self.textView becomeFirstResponder];
}


- (void)creatTableView {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = NO;
    self.bgView.hidden = NO;
    [self.tableBgView becomeFirstResponder];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    btn.backgroundColor=[UIColor clearColor];
    [btn addTarget:self action:@selector(hiddenTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:btn];
    
    if (direction == YLYKDirectionHoriztion) {
        self.tableBgView = [[UIView alloc] initWithFrame:CGRectMake(615 - 8, 272, 400 - 16 , 461 - 8)];
    } else if (direction == YLYKDirectionViretial) {
        self.tableBgView = [[UIView alloc] initWithFrame:CGRectMake(304, 528, 400 - 16 , 461 - 8)];
    }
    self.tableBgView.layer.cornerRadius = 4.0;
    self.tableBgView.layer.masksToBounds = YES;
    
    [self.bgView addSubview:self.tableBgView];
    playHeaderListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableBgView.frame.size.width, 44)];
    playHeaderListView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, playHeaderListView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [playHeaderListView addSubview:lineView];
    
    if (self.cycle == 2) {
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_on_turn"] forState:UIControlStateNormal];
    } else if (self.cycle == 1){
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_circle"] forState:UIControlStateNormal];
    } else {
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_single"] forState:UIControlStateNormal];
    }
    //
    //[headerView addSubview:self.cycleBtn];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, self.tableBgView.frame.size.width - 200, 20)];
    if (self.isFromDownload) {
        label.text = @"播放列表";
    } else {
        label.text = [self.currentModel.album objectForKey:@"name"];
    }
    
    [label setTextColor:[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1]];
    [label setFont:[UIFont systemFontOfSize:14]];
    label.textAlignment = NSTextAlignmentCenter;
    [playHeaderListView addSubview:label];
    self.tableView.hidden = NO;
    [self.tableBgView addSubview:playHeaderListView];
    [self.tableBgView addSubview:self.tableView];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableBgView.frame.size.height - 49, self.tableBgView.frame.size.width, 49)];
    footerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTableView)];
    [footerView addGestureRecognizer:gesture];
    footerView.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:251/255.0 alpha:1];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(footerView.frame.size.width/2 - 15, 10, 30, 30);
    [button addTarget:self action:@selector(hiddenTableView) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [footerView addSubview:button];
    //[self.tableBgView addSubview:footerView];
}

/*
 *加载视图数据
 */
- (void)loadViewData {
    NSArray *titleArr = @[@"赞",@"字号",@"心得",@"列表",@"写心得"];
    NSArray *btnArr = @[@"night_like_default",@"default_icon-fontsize_small",@"night_icon_note",@"night_icon_playlist",@"ipad_default_write"];
    playerContentFooterView.btnArr   = btnArr;
    playerContentFooterView.titleArr = titleArr;
    [playerContentFooterView loadView];
    
    [self getPlayerControlCallBack];
    [self getSliderEventCallBack];
    [self getFooterEventCallBack];
}
/*
 *刷新页面请求的网络数据
 */
- (void)refreshUI {
    [playerHeaderView setItem:self.currentModel];
    NSString *courseImgURLStr = [NSString stringWithFormat:@"%@course/%ld/cover",BASEURL_STRING,(long)self.courseID];
    [playImageView sd_setImageWithURL: [NSURL URLWithString:courseImgURLStr] placeholderImage:[UIImage imageNamed:@"ipad_player_default"]];
    [playerContentView setItem:self.currentModel];
    self.duration =  [NSString stringWithFormat:@"%ld",(long)self.currentModel.duration];
}


// 返回
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

// 下载
- (void)downloadCourse:(UIBarButtonItem*)sender {
    if ([self isDownloadCoursePathWithCourseId:self.courseID andUserId:self.useID]) {
        [CBLProgressHUD showTextHUDWithText:@"已下载" inView:self.view];
    } else {
        [CBLProgressHUD showTextHUDWithText:@"已添加到下载队列" inView:self.view];
        UIImage *downloadImg = [UIImage imageNamed:@"download_disable"];
        downloadImg = [downloadImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem.image =  downloadImg;
        YLYKDownloadNativeModule *downloadManager = [[YLYKDownloadNativeModule alloc] init];
        NSMutableDictionary *downloadDict = [self.currentModel mj_keyValues];
        [downloadDict removeObjectForKey:@"teachers"];
        NSArray *downloadArr = [NSArray arrayWithObject:downloadDict];
        [downloadManager startDownload:downloadArr];
    }
}


#pragma mark - 通过CourseID 加载音频数据
// 根据courseId获取当前的albumId
-(void)loadData {
    Reachability* curReach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            [CBLProgressHUD showTextHUDInWindowWithText:@"无法连接至网络，请检查网络设置"];
            //[CBLProgressHUD hideLoadingHUDInView:self.webView];
            return;
            break;
        case ReachableViaWiFi:
            break;
        case ReachableViaWWAN:
            break;
        default:
            NSLog(@"");
            break;
    }
    
    [YLYKCourseServiceModule getCourseById:[NSString stringWithFormat:@"%ld",(long)self.courseID] success:^(id responseObject) {
        YLYKCourseModel *course = [YLYKCourseModel mj_objectWithKeyValues:responseObject];
        [YLYKCourseModel mj_replacedKeyFromPropertyName];
        playerControlView.remainTimeLbl.text = [NSString stringWithFormat:@"-%@",[self timeFormatted:course.duration]];
        self.currentModel = course;
        NSNumber *albumId = [course.album objectForKey:@"id"];
        YLYKAlbumModel *album = [YLYKAlbumModel mj_objectWithKeyValues:course.album];
        self.album = album;
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:[NSString stringWithFormat:@"%li",(long)course.courseId]];
        [self getAlbumListWithAlbumId:[albumId integerValue]];
        [self createPlayerModelWithCourseId:course.courseId];
        //刷新界面数据
        [self refreshUI];
    } failure:^(NSError *error) {
        [self getErrorCodeWithError:error];
        
    }];
}
// 根据albumId来获取albumList
- (void)getAlbumListWithAlbum:(NSInteger)albumId
{
    NSDictionary *parameters = @{@"album_id":[NSString stringWithFormat:@"%ld",(long)albumId],@"limit":@"100"};
    
    [YLYKCourseServiceModule getCourseList:parameters success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        self.albumListArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        for (NSInteger i = 0; i<self.albumListArray.count; i++) {
            if ( self.courseID == [[self.albumListArray[i] objectForKey:@"id"] integerValue]) {
                //                self.currentCourseIndex = self.albumListArray.count - i -1;
                self.currentCourseIndex = i;
            }
        }
        
    } failure:^(NSError *error) {
        XXZQLog(@"%@",error);
        [self getErrorCodeWithError:error];
        //        [CBLProgressHUD  showTextHUDInWindowWithText:@""];
    }];
}

/*
 1. 获取当前course obj方法：通过id，先查缓存，有缓存用缓存obj进行回调，如果没有则请求网络，成功后获取到obj再回调
 2. 根据obj去播放的方法：
 3. 根据course obj中的albumID请求播放列表
 
 1. mode属性，决定player怎么进行播放列表
 2. list属性，存储待播放的列表
 3. 向list中添加播放obj的方法
 4. 回调方法
 */

- (void)getAlbumListWithAlbumId:(NSInteger)albumId {
    NSDictionary *parameters = @{@"album_id":[NSString stringWithFormat:@"%ld",(long)albumId],@"limit":@"100"};
    [YLYKCourseServiceModule getCourseList:parameters success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        self.albumListArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        for (NSInteger i = 0; i<self.albumListArray.count; i++) {
            if ( self.courseID == [[self.albumListArray[i] objectForKey:@"id"] integerValue]) {
                self.currentCourseIndex = i;
            }
        }
    } failure:^(NSError *error) {
        [self getErrorCodeWithError:error];
    }];
}

- (void)createPlayerModelWithCourseId: (NSInteger)courseId {
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%li",(long)courseId]];
    if (obj) {
        [self createPlayerWithObj:obj];
    } else {
        [YLYKCourseServiceModule getCourseById:[NSString stringWithFormat:@"%ld",(long)courseId] success:^(id responseObject) {
            [self createPlayerWithObj:responseObject];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:[NSString stringWithFormat:@"%li",(long)courseId]];
            __weak typeof(self) weakSelf = self;
            [CBLProgressHUD hideLoadingHUDInView:weakSelf.view];
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"下一节了"];
            if (self.cycle == 2 && str) {
                [self.playerManager setPlayingWithRate:self.rate];
                [self play];
                [self.playerManager play];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"下一节了"];
            }
        } failure:^(NSError *error) {
            XXZQLog(@"%@",error);
            [self getErrorCodeWithError:error];
        }];
    }
}

/*
 * 加载化原始数据
 */
- (void)loadOriginData {
    self.fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fontBtn.frame = CGRectMake(25, 110, 40, 40);
    
    if (FONT_SIZE) {
        NSString *fontSize = [NSString stringWithFormat:@"default_icon-fontsize_%@",FONT_SIZE];
        [self.fontBtn  setImage:[UIImage imageNamed:fontSize] forState:UIControlStateNormal];
    } else {
        [self.fontBtn  setImage:[UIImage imageNamed:@"default_icon-fontsize_small"] forState:UIControlStateNormal];
    }
    
    [self.fontBtn setTitle:@"字号" forState:UIControlStateNormal];
    [self.fontBtn setTitleColor:[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [self.fontBtn .titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.fontBtn setTitleEdgeInsets:UIEdgeInsetsMake(80.0, -self.fontBtn.frame.size.width+5, 0.0, 0.0)];
    [self.fontBtn setImageEdgeInsets:UIEdgeInsetsMake(-20.0, 0.0, 0.0, -
                                                      self.fontBtn.titleLabel.bounds.size.width)];
    [self.fontBtn  addTarget:self action:@selector(changeFontSize) forControlEvents:UIControlEventTouchUpInside];
    //[view addSubview:self.fontBtn ];
    
    if (self.rate == 1.25) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.25"] forState:UIControlStateNormal];
    } else if(self.rate == 1.50) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.5"] forState:UIControlStateNormal];
    } else if (self.rate == 0.80) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_0.8"] forState:UIControlStateNormal];
    } else if(self.rate == 1.00) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1"] forState:UIControlStateNormal];
    }
    
    //循环播放按钮
    if (self.cycle == 2) {
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_on_turn"] forState:UIControlStateNormal];
    } else if (self.cycle == 1){
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_circle"] forState:UIControlStateNormal];
    } else {
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_single"] forState:UIControlStateNormal];
    }
    
    
    [playerContentFooterView.experienceLbl setText:[NSString stringWithFormat:@"心得(%ld)",(long)self.currentModel.note_count]];
    
    NSString  *likeNumber = [NSString stringWithFormat:@"赞(%ld)", (long)self.currentModel.like_count];
    [playerContentFooterView.linkCourseLbl setText:likeNumber];
    if (self.currentModel.is_liked) {
        [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_highlight"] forState:UIControlStateNormal];
        liked = NO;
    } else {
        [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
        liked = YES;
    }
}

/*
 *加载音频数据
 *@prama courseId 课程ID
 */
- (void)loadDataWithCourseId:(NSInteger)courseId
{
    [YLYKCourseServiceModule getCourseById:[NSString stringWithFormat:@"%ld",(long)self.courseID] success:^(id responseObject) {
        YLYKCourseModel *course = [YLYKCourseModel mj_objectWithKeyValues:responseObject];
        self.currentModel = course;
        [YLYKCourseModel mj_replacedKeyFromPropertyName];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:[NSString stringWithFormat:@"%li",(long)course.courseId]];
    } failure:^(NSError *error) {
        [self getErrorCodeWithError:error];
    }];
}


- (void)createPlayerWithObj:(id)obj {
    YLYKCourseModel *course = [YLYKCourseModel mj_objectWithKeyValues:obj];
    [YLYKCourseModel mj_replacedKeyFromPropertyName];
    if (self.currentModel == course) {
        [self.playerManager play];
    } else {
        self.currentModel = course;
        totalLearnTime = 0;
        [self.listenTimer invalidate];
        self.listenTimer = nil;
        self.playerManager = [YLYKPlayerManager sharedPlayer];
        self.playerManager.delegate = self;
        NSString* cacheFilePath = [JXFileHandle cacheFileExistsWithURL:[NSURL URLWithString:course.media_url]];
        if ([self isDownloadCoursePathWithCourseId:course.courseId andUserId:self.useID] || cacheFilePath ) {
            [self creatPlayerWithCourse:course];
        } else {
            [self isPlayNetworkStateWithCourse:course];
        }
    }
    //[CBLProgressHUD showLoadingHUDInView:self.webView];
    //[self reloadUI:course];
    [self refreshUI];
    [self.tableView reloadData];
}

- (void)isPlayNetworkStateWithCourse:(YLYKCourseModel *)course {
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"不再提醒WIFI"];
    if (!obj) {
        NSString *netWorkState = [YLYKServiceModule getSystemNetworkState];
        if (![netWorkState isEqualToString:@"wifi"] && ![netWorkState isEqualToString:@"notReachable"]) {
            BOOL user4g = [[NSUserDefaults standardUserDefaults] boolForKey:@"use4G"];
            if (!user4g) {
                [self actionAndAlertViewTitle:@"确定使用流量听课？" withMessage:nil action1Title:@"不再提醒" action2Title:@"确定" firstAction:^(id result) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"不再提醒WIFI" forKey:@"不再提醒WIFI"];
                    [self creatPlayerWithCourse:course];
                } secondAction:^(id second) {
                    [self creatPlayerWithCourse:course];
                } cancelAction:^(id cancel) {
                    cancelLoadFromWWAN = @"canceled";
                }];
            } else {
                [self creatPlayerWithCourse:course];
            }
        } else {
            [self creatPlayerWithCourse:course];
        }
    } else {
        [self creatPlayerWithCourse:course];
    }
}

- (void)creatPlayerWithCourse:(YLYKCourseModel *)course {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = YES;
    [self.playerManager createPlayer:course withUserID:self.useID];
    playerControlView.playTimeLbl.text = [self timeFormatted:0];
    playerControlView.remainTimeLbl.text = [NSString stringWithFormat:@"-%@",[self timeFormatted:course.duration]];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"下一节了"];
    if (str) {
        [[YLYKPlayerManager sharedPlayer] play];
        [self.playerManager seekTo:0];
        [self play];
        [self play];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"下一节了"];
    } else {
        [self playLastTime];
    }
    __weak typeof(self) weakSelf = self;
    __block YLYKPlayerControlView * tempPlayerControlView = playerControlView;
    self.playerManager.block = ^void(int currentTime,float spareTime,float totalLoadTime){
        if (!weakSelf.playerManager.is_drag) {
            tempPlayerControlView.playTimeLbl.text = [weakSelf timeFormatted:currentTime];
            tempPlayerControlView.remainTimeLbl.text = [NSString stringWithFormat:@"-%@",[weakSelf timeFormatted:spareTime]];
            tempPlayerControlView.progressView.progress = totalLoadTime/(spareTime + currentTime);
            tempPlayerControlView.slider.value = currentTime/(spareTime + currentTime);
            weakSelf.learnSeconds = currentTime;
            weakSelf.listenSeconds = currentTime;
        }
    };
}

#pragma mark -是否继续上次播放
- (void)playLastTime {
    //在这里跳转上次播放的位置
    NSString *lastPlayTime = [NSString stringWithFormat:@"lastPlayTime%ld",(long)self.courseID];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:lastPlayTime];
    NSNumber *num = [dict objectForKey:@"course"];
    NSString *timeString = [dict objectForKey:@"time"];
    [self pause];
    NSString *duration = [self timeFormatted:self.currentModel.duration];
    if (self.courseID == [num integerValue] && ![timeString isEqualToString:@"00:00"] && ![timeString isEqualToString:duration]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSArray *array = [timeString componentsSeparatedByString:@":"];
            NSInteger min = [array[0] integerValue];
            NSInteger sec = [array[1] integerValue];
            float time = min *60 + sec;
            playerControlView.playTimeLbl.text = timeString;
            float value = time/[self.duration floatValue];
            playerControlView.slider.value = value;
            [self.playerManager seekTo:value];
            [self play];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            [self play];
        }];
        alertController.title = [NSString stringWithFormat:@"上次播放到%@，继续收听？",timeString];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
        UINavigationController * nav = (UINavigationController *)keyWindow.rootViewController;
        [nav presentViewController:alertController animated:YES completion:nil];
    } else {
        [self play];
    }
}
#pragma mark -Tools
//转换成时分秒
- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes, (long)seconds];
}

- (NSString *)anotherTimeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02ld'%02ld''",(long)minutes, (long)seconds];
}

- (NSString *)getNetWorkState {
    return [YLYKServiceModule getSystemNetworkState];
}

- (NSString *)getSecurtyUrlString: (NSString *)urlstring withParameters: (NSDictionary *)parameters {
    // 获得时间参数与随机数
    NSString *timeString = [NSStringTools getTimeString];
    NSString *randomStr = [NSStringTools getRandomString];
    
    // 拼接字典 ，并按照ascii排序
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:timeString forKey:@"timestamp"];
    [dict setObject:randomStr forKey:@"nonce"];
    [dict addEntriesFromDictionary:parameters];
    NSArray*arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSString *parastr;
    NSString *string = nil;
    for (int i=0; i<arr.count; i++) {
        NSString *value = [dict valueForKey:arr[i]];
        parastr = [NSString stringWithFormat:@"%@=%@",arr[i],value];
        if (string != nil) {
            string = [NSString stringWithFormat:@"%@&%@",string,parastr];
        } else {
            string = [NSString stringWithFormat:@"%@",parastr];
        }
    }
    // 将拼接好的字符串MD5运算
    NSString *md5String = [NSStringTools getMD5String:string];
    // 将运算好的MD5值拼接到url中
    md5String = [NSString stringWithFormat:@"%@&signature=%@",string,md5String];
    return md5String;
}

// 判断是否下载过该课程
- (BOOL )isDownloadCoursePathWithCourseId: (NSInteger )courseID andUserId: (NSInteger)userID {
    NSString *fileName = [NSStringTools getMD5String:[NSString stringWithFormat:@"%lu.%ld",(unsigned long)userID,(long)courseID]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Pandora/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/%@.mp3",fileName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

#pragma mark -获取当天日期
- (NSString *)getTodayDateTimeString {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:localeDate];
    return dateTime;
}

- (NSString *)timeIntervalToString:(NSInteger )intervar {
    NSTimeInterval time=intervar +28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

#pragma mark - 获取错误Code提醒
- (void)getErrorCodeWithError:(NSError *)error {
    NSData * errmessageData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString * errorString = [[NSString alloc] initWithData:errmessageData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:errorString];
    NSString * errorCode = [NSString stringWithFormat:@"%@",[dict objectForKey:@"error_code"]];
    if ([errorCode isEqualToString:@"401"] ) {
        [CBLProgressHUD showTextHUDInWindowWithText:@"登录已失效，请重新登录"];
        LoginViewController *login = [[LoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:nil];
        return;
    } else if ([errorCode isEqualToString:@"404"]){
        [CBLProgressHUD showTextHUDInWindowWithText:@"网络出错，请稍后再试"];
        return;
    } else if ([errorCode isEqualToString:@"408"]){
        [CBLProgressHUD showTextHUDInWindowWithText:@"系统时间与服务器时间不一致，请去设置更改系统时间"];
        return;
    } else if ([errorCode integerValue] > 499){
        [CBLProgressHUD showTextHUDInWindowWithText:@"服务器去学英语了，请通知阿树老师把它抓回来!"];
        return;
    } else if (!dict){
        [CBLProgressHUD showTextHUDInWindowWithText:@"请求超时，无法连接至服务器"];
        return;
    }
}


#pragma mark - 代码块回调事件

/*
 *playerControlView
 */

- (void)getPlayerControlCallBack {
    //播放控制台按钮回调事件
    [playerControlView getControlEventCallBack:^(YLYKPlayerControlEvent enventType) {
        switch (enventType) {
            case YLYKPlayerControlEventCycle:
            {
                NSLog(@"循环按钮事件");
                [self playCycle];
            }
                break;
            case YLYKPlayerControlEventBack:
            {
                NSLog(@"回退按钮事件");
                [self backPlayMedia];
            }
                break;
            case YLYKPlayerControlEventPlay:
            {
                NSLog(@"播放暂停按钮事件");
                [self playOrPauseNote];
            }
                break;
            case YLYKPlayerControlEventForward:
            {
                NSLog(@"前进按钮事件");
                [self forwardPlayMedia];
            }
                break;
            case YLYKPlayerControlEventSpeed:
            {
                NSLog(@"加速按钮事件");
                [self setPlayingRate];
            }
                break;
            case YLYKPlayerControlEventFontSize:
            {
                NSLog(@"字号大小事件");
                [self changeFontSize];
            }
                break;
            case YLYKPlayerControlEventNote:
            {
                NSLog(@"查看心得事件");
                [self jumpToNoteListView];
            }
                break;
            case YLYKPlayerControlEventAlbumList:
            {
                NSLog(@"专辑列表事件");
                [self creatTableView];
            }
                break;
            case YLYKPlayerControlEventWriteNote:
            {
                NSLog(@"写心得事件");
                [self writeNote];
            }
                break;
                
            default:
                break;
        }
    }];
}

/*
 *播放slider回调事件
 */
- (void)getSliderEventCallBack {
    [playerControlView getSliderEventCallBack:^(YLYKSliderEvent sliderEnventType, UISlider *sender) {
        switch (sliderEnventType) {
            case YLYKSliderEventValueChanged:
            {
                NSLog(@"valueChanged");
                [self sliderValueChanged:sender];
            }
                break;
            case YLYKSliderEventTouchCancel:
            {
                NSLog(@"TouchCancel");
                [self touchCancel:sender];
            }
                break;
            case YLYKSliderEventTouchUp:
            {
                NSLog(@"TouchUp");
                [self touchUp:sender];
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -slider手势相关：slider
//移动滑块调整播放进度
- (void)sliderValueChanged:(UISlider *)sender {
    if (sender.isTracking) {
        playerControlView.playTimeLbl.text = [self timeFormatted:sender.value *self.currentModel.duration];
        playerControlView.remainTimeLbl.text = [self timeFormatted:(1-sender.value) *self.currentModel.duration];
    } else {
        sender.value = lastValue;
    }
    self.playerManager.is_drag = YES;
    lastValue = sender.value;
}

- (void)touchCancel:(UISlider *)sender {
    // 滑动到屏幕外
    if (sender.state == 0) {
        if ([self.playerManager isPlaying]) {
            [self.playerManager pause];
            self.playerManager.isplay = YES;
        }
        
        [self.playerManager seekTo:sender.value];
    }
}

- (void)touchUp:(UISlider *)sender {
    if ([self.playerManager isPlaying]) {
        [self.playerManager pause];
        self.playerManager.isplay = YES;
    }
    [self.playerManager seekTo:sender.value];
}

/*
 *底部视图代码块回调
 */
- (void)getFooterEventCallBack {
    [playerContentFooterView getFooterEventCallBack:^(YLYKPlayerContentFooterEvent footerEnventType) {
        switch (footerEnventType) {
            case YLYKPlayerFooterEventPraise:
            {
                NSLog(@"赞");
                [self thumbUpCourse];
            }
                break;
            case YLYKPlayerFooterEventFontSize:
            {
                NSLog(@"字号大小");
                [self changeFontSize];
            }
                break;
            case YLYKPlayerFooterEventExperience:
            {
                NSLog(@"心得");
                [self jumpToNoteListView];
            }
                break;
            case YLYKPlayerFooterEventList:
            {
                NSLog(@"列表");
                [self creatTableView];
            }
                break;
            case YLYKPlayerFooterEventWriteExperience:
            {
                NSLog(@"写心得");
                [self writeNote];
                
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark -点赞,调整字号，调整倍速，打开心得列表
/*
 *点赞
 */
- (void)thumbUpCourse {
    if (liked) {
        [YLYKCourseServiceModule likeCourse:[NSString stringWithFormat:@"%ld",(long)self.currentModel.courseId] success:^(id responseObject) {
            if ([playerContentFooterView.linkCourseLbl.text isEqualToString:[NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count]]) {
                NSInteger num = self.currentModel.like_count + 1;
                [playerContentFooterView.linkCourseLbl setText:[NSString stringWithFormat:@"赞(%ld)",(long)num]];
                //                [playerContentFooterView.linkCourseLbl setTitle:[NSString stringWithFormat:@"赞(%ld)",(long)num] forState:UIControlStateNormal];
            } else {
                [playerContentFooterView.linkCourseLbl setText:[NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count]];
                //[self.likeBtn setTitle: [NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count] forState:UIControlStateNormal];
            }
            [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_highlight"] forState:UIControlStateNormal];
            liked = NO;
            [self loadDataWithCourseId:self.courseID];
        } failure:^(NSError *error) {
            [CBLProgressHUD  showTextHUDInWindowWithText:@"收藏失败"];
        }];
    } else {
        [YLYKCourseServiceModule unlikeCourse:[NSString stringWithFormat:@"%ld",(long)self.currentModel.courseId] success:^(id responseObject) {
            if ([playerContentFooterView.linkCourseLbl.text isEqualToString:[NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count]]) {
                NSInteger num = self.currentModel.like_count - 1;
                [playerContentFooterView.linkCourseLbl setText:[NSString stringWithFormat:@"赞(%ld)",(long)num]];
                //[self.likeBtn setTitle:[NSString stringWithFormat:@"赞(%ld)",(long)num] forState:UIControlStateNormal];
            } else {
                [playerContentFooterView.linkCourseLbl setText:[NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count]];
                // [self.likeBtn setTitle: [NSString stringWithFormat:@"赞(%ld)",(long)self.currentModel.like_count] forState:UIControlStateNormal];
            }
            [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
            //[self.likeBtn setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
            liked = YES;
            [self loadDataWithCourseId:self.courseID];
        } failure:^(NSError *error) {
            [CBLProgressHUD  showTextHUDInWindowWithText:@"收藏失败"];
        }];
    }
    
}

/*
 *调整字号
 */
- (void)changeFontSize {
    if (self.fontsize == 16) {
        self.fontsize = 18;
        [playerContentFooterView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_middle"] forState:UIControlStateNormal];
        [playerControlView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_middle"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"middle" forKey:@"fontSize"];
    } else if (self.fontsize == 18) {
        self.fontsize = 20;
        [playerContentFooterView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_big"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"big" forKey:@"fontSize"];
        [playerControlView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_big"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"big" forKey:@"fontSize"];
    } else {
        self.fontsize = 16;
        [playerContentFooterView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_small"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"small" forKey:@"fontSize"];
        [playerControlView.fontSizeBtn setImage:[UIImage imageNamed:@"default_icon-fontsize_small"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"small" forKey:@"fontSize"];
    }
    NSString *URL = STYLE_CSS_URL;
    if (!URL) {
        URL = @"https://static.youlinyouke.com/css/style.css";
    }
    NSString *html = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\"/><style>html,body{background:#F8FAFA;color:#5a5a5a;font-size:%f;}*{-webkit-user-select:text!important;-moz-user-select:text!important;-ms-user-select: text!important;}</style> ", URL, self.fontsize];
    NSString *str = [NSString stringWithFormat:@"%@%@",html,self.currentModel.content];
    [playerContentView.contentWebView loadHTMLString:str baseURL:nil];
}

/*
 *跳转到心得页
 */
- (void)jumpToNoteListView {
    self.bgView.hidden = YES;
    self.maskView.hidden = YES;
    NoteListViewController *note = [[NoteListViewController alloc] init];
    NSMutableDictionary *downloadDict = [self.currentModel mj_keyValues];
    note.courseInfo = downloadDict;
    [self.navigationController pushViewController:note animated:YES];
}

/*
 *写心得
 */
- (void)writeNote {
    self.bgView.hidden = YES;
    [self createNoteView];
    NSString *savedText = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ldcourseNote",(long)self.currentModel.courseId]];
    self.textView.textColor = [UIColor blackColor];
    [self createCourseTagForBtn];
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.text = kPlaceholderText;
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self.placeHolderLabel sizeToFit];
    [self.textView addSubview:self.placeHolderLabel];
    self.textView.font = [UIFont systemFontOfSize:14.f];
    self.placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 8.4) {
        [self.textView setValue:self.placeHolderLabel forKey:@"_placeholderLabel"];
    } else {
    }
    self.textView.text = savedText;
    [self.textView becomeFirstResponder];
}
- (void)createCourseTagForBtn {
    // 移除之前添加的label
    [self.cornerLabel removeFromSuperview];
    if (self.imgArray.count > 0) {
        self.cornerLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 15, 15)];
        self.cornerLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.imgArray.count];
        self.cornerLabel.textColor = [UIColor whiteColor];
        self.cornerLabel.backgroundColor=[UIColor redColor];
        self.cornerLabel.textAlignment = NSTextAlignmentCenter;
        self.cornerLabel.layer.cornerRadius  =  7.5;
        self.cornerLabel.layer.masksToBounds =YES;
        self.cornerLabel.font = [UIFont systemFontOfSize:11];
        [self.imgBtn addSubview:self.cornerLabel];
    }
}
#pragma mark -发布心得
- (void)publishNote {
    // 将图片保存至本地
    for (int i =0; i<self.imgArray.count; i++) {
        UIImage *image = self.imgArray[i];
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imageStr = [NSString stringWithFormat:@"/Documents/images%i.jpg",i];
        NSString *imagePath = [path_sandox stringByAppendingString:imageStr];
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }
    if (self.imgArray.count > 0) {
        [self getQiniuTokenWithImageCount:self.imgArray.count];
    } else {
        NSString *string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ((!_imgArray && self.imgArray.count == 0)) {
            [self createNote];
            [self.textView resignFirstResponder];
            self.bgView.hidden = YES;
            self.noteView.hidden = YES;
        } else {
            if ([self.textView.text isEqualToString:@""] || string==nil) {
                [CBLProgressHUD showTextHUDInWindowWithText:@"写点什么再发布吧"];
                return;
            }else {
                [self createNote];
            }
        }
    }
    localImageCount = self.imgArray.count;
}

// 从服务器拿到上传图片的token
- (void)getQiniuTokenWithImageCount:(NSInteger )imageCount {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%lu", (unsigned long)self.imgArray.count],@"image_count",nil];
    NSArray *array = @[@"note"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",parameters,@"body", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [CBLProgressHUD showTextHUDInWindowWithText:@"上传中"];
    [CBLProgressHUD showLoadingHUDInView:self.view];
    [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
        NSData *aJSONData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * QiqiuTokenArr  = [NSJSONSerialization JSONObjectWithData:aJSONData
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
        [self uploadToQiniuWithTokenAndKeys:QiqiuTokenArr];
    } failure:^(NSError *error) {
        [CBLProgressHUD showTextHUDInWindowWithText:@"上传失败"];
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }];
}

// 把图片上传至七牛
- (void)uploadToQiniuWithTokenAndKeys:(NSArray *)array {
    NSMutableArray *tokenArr = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        NSString *token = [array[i]  valueForKey:@"upload_token"];
        NSString *key =  [array[i]  valueForKey:@"file_key"];
        [self.fileKeysArr addObject:key];
        [tokenArr addObject:token];
    }
    [YLYKUploadImageTool uploadImages:self.imgArray withKeys:self.fileKeysArr andTokens:tokenArr success:^(NSArray * successArr) {
        [self createNote];
    } failure:^{
        [CBLProgressHUD showTextHUDInWindowWithText:@"上传失败"];
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }];
}

// 图片上传完成以后，开始上传笔记
- (void)createNote {
    self.textView.text = [self.textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSString *string = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.currentModel.courseId] ,@"course_id",string,@"content",self.fileKeysArr,@"file_keys",nil];
    
    NSArray *array = @[@"note"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",parameters,@"body", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self.imgArray removeAllObjects];
        [self.fileKeysArr removeAllObjects];
        [self.textView resignFirstResponder];
        //        self.noteView.hidden = YES;
        [self.noteView removeFromSuperview];
        self.bgView.hidden = YES;
        [self.imgBtn removeFromSuperview];
        // 上传成功移除图片数组
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%ldcourseNote",(long)self.currentModel.courseId]];
        SendNoteEvent *event = [[SendNoteEvent alloc] init];
        [SendNoteEvent application:[UIApplication sharedApplication] withSendNoteload:@{@"sendNoteEvent":@true}];
        [event startObserving];
        // 发送成功，去请求增加优币
        [self getReward];
    } failure:^(NSError *error) {
        [self.fileKeysArr removeAllObjects];
        [CBLProgressHUD showTextHUDInWindowWithText:@"上传失败"];
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }];
}

- (void)getReward {
    NSDictionary *dict = @{@"source":@"task",@"type_id":@"4"};
    [YLYKUmoneyServiceModule getReward:dict success:^(id responseObject) {
        NSDictionary *result = [NSStringTools getDictionaryWithJsonstring:responseObject];
        BOOL umoney = [[result objectForKey:@"result"] boolValue];
        if (umoney) {
            NSString *money = [[result objectForKey:@"package"] objectForKey:@"umoney"];
            NSString *text = [NSString stringWithFormat:@"每日发布心得，优币+%@",money];
            [CBLProgressHUD showTextHUDInWindowWithText:text];
        } else {
            [CBLProgressHUD showTextHUDInWindowWithText:@"上传成功"];
        }
        [self jumpToNoteListView];
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    } failure:^(NSError *error) {
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }];
}

#pragma mark - 跳转到登录界面
- (IBAction)showAlbumLIst:(id)sender {
    [self creatTableView];
}

- (void)downloadCourseFinish:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.rightBarButtonItem.image = [[UIImage imageNamed:@"download_hight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"downloadFinish%ld",(long)self.currentModel.courseId] object:nil];
}

- (void)playerStatusChange:(id)sender {
    //[self.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
}

- (void)pause {
    NSNumber *state;
    [self pauseTime];
    state = [NSNumber numberWithInteger:0];
    [self.playerManager pause];
    //  获取上一次上传的时间与本次的时间差
    NSString *lastTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"dateTime"];
    NSString *nowTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    if (lastTime == nil) {
        lastTime = nowTime;
    }
    NSInteger listenTime = [nowTime integerValue] - [lastTime integerValue];
    if (listenTime > 60) {
        listenTime = 0;
    }
    NSInteger listenInt =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"listen"] integerValue];
    NSInteger learnInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"learn"] integerValue];
    NSNumber *listenNumber = [NSNumber numberWithInteger:(listenTime + listenInt)];
    NSNumber *learnNumber = [NSNumber numberWithInteger:(listenTime + learnInt)];
    NSString *dateTime = [self getTodayDateTimeString];
    NSNumber *courseNum = [NSNumber numberWithInteger:self.courseID];
    NSString *learnCourseIdWithDate = [NSString stringWithFormat:@"learn%@%@",courseNum,dateTime];
    NSDictionary *learnDict = [[NSUserDefaults standardUserDefaults] objectForKey:learnCourseIdWithDate];
    // 获取该课程当日学习的时间总长
    NSInteger learnTotalTime = [[learnDict objectForKey:@"learnTime"] integerValue];
    if (learnTotalTime > self.learnSeconds + 1 ) {
        learnNumber = [NSNumber numberWithInteger:0];
    }
    [self postListenTime:listenNumber AndLearnTime:learnNumber];
    self.playOrPause = YES;
    //[self.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
}

- (void)play {
    NSNumber *state;
    state = [NSNumber numberWithInteger:1];
    //    if (self.slider.value == 1.000) {
    //        self.slider.value = 0;
    //        [self.playerManager seekTo:self.slider.value];
    //    }
    if (playerControlView.slider.value == 1.000) {
        playerControlView.slider.value = 0;
        [self.playerManager seekTo:playerControlView.slider.value];
    }
    // 未登录不开启定时器
    if (self.useID != 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dateTime"];
        NSString *nowTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:@"dateTime"];
        [self startTimer];
    }
    [self.playerManager play];
    self.playOrPause = NO;
    //[self.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
}

- (void)playOrPauseNote:(UIButton *)sender {
    [self.tableView reloadData];
    if (self.playOrPause) {
        [sender setImage:[UIImage imageNamed:@"note_pause"] forState:UIControlStateNormal];
        [self play];
    } else {
        [self pause];
        [sender setImage:[UIImage imageNamed:@"note_play"] forState:UIControlStateNormal];
    }
}

- (IBAction)playOrPause:(UIButton *)sender {
    [self.tableView reloadData];
    if (self.playOrPause) {
        if ([cancelLoadFromWWAN isEqualToString:@"canceled"]) {
            cancelLoadFromWWAN = @"notcancel";
            [self creatPlayerWithCourse:self.currentModel];
        } else {
            [sender setImage:[UIImage imageNamed:@"default_icon_play"] forState:UIControlStateNormal];
            [self play];
        }
    } else {
        [self pause];
        [sender setImage:[UIImage imageNamed:@"default_icon_pause"] forState:UIControlStateNormal];
    }
}

- (void)receiveNotificationPlayOrPause {
    if (self.playOrPause) {
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_pause"] forState:UIControlStateNormal];
        [self play];
    } else {
        [self pause];
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_play"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)handleInterreptionNotificationPlayOrPause {
    if (self.playOrPause) {
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_pause"] forState:UIControlStateNormal];
        [self play];
    } else {
        [self pause];
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_play"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)otherHandleInterreptionNotificationPause {
    [self pause];
    [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_play"] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

- (void)playOrPauseList:(UIButton *)sender {
    if (self.playOrPause) {
        [sender setImage:[UIImage imageNamed:@"playlist_icon_pause_default"] forState:UIControlStateNormal];
        [self play];
    } else {
        [self pause];
        [sender setImage:[UIImage imageNamed:@"playlist_play"] forState:UIControlStateNormal];
    }
}

- (void)remoteControllerNotification:(NSNotification *)noti {
    NSString *status = [noti.userInfo objectForKey:@"playStatus"];
    if ([status isEqualToString:@"play"]) {
        [self play];
    } else if ([status isEqualToString:@"pause"]) {
        [self pause];
    } else if ([status isEqualToString:@"previous"]) {
        self.currentCourseIndex -= 1;
        
        if (self.currentCourseIndex < self.albumListArray.count) {
            [self changeCourse];
        } else if(self.currentCourseIndex < 0) {
            self.currentCourseIndex = self.albumListArray.count - 1;
            NSLog(@"已经是第一课了");
            [self changeCourse];
        }
    } else if ([status isEqualToString:@"next"]) {
        self.currentCourseIndex += 1;
        if (self.currentCourseIndex < self.albumListArray.count) {
            // 暂停以上传学习时长
            [self changeCourse];
        } else if(self.currentCourseIndex == self.albumListArray.count) {
            NSLog(@"已经是最后一课了");
            self.currentCourseIndex = 0;
            [self changeCourse];
        }
    }
}
- (void)changeCourse {
    [self pause];
    [[NSUserDefaults standardUserDefaults] setObject:@"要播放下一节了" forKey:@"下一节了"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"use4G"];
    self.courseID = [[self.albumListArray[self.currentCourseIndex] objectForKey:@"id"] integerValue];
    [self createPlayerModelWithCourseId: [[self.albumListArray[self.currentCourseIndex] objectForKey:@"id"] integerValue]];
    [self.playerManager setPlayingWithRate:self.rate];
    [self.playerManager seekTo:0];
    playerControlView.slider.value = 0;
    [self.playerManager play];
}

#pragma mark - 循环播放 后退 前进 倍率播放

/*
 *循环播放
 */
- (void)playCycle {
    //TODO:实际上这里使用枚举来区别是否循环更好一些
    if (self.cycle == 0) {
        // 循环播放
        self.cycle = 1;
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_circle"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"cycle"];
    } else if(self.cycle == 1) {
        // 顺序播放
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"cycle"];
        self.cycle = 2;
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_on_turn"] forState:UIControlStateNormal];
    } else if (self.cycle == 2) {
        self.cycle = 0;
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"cycle"];
        [playerControlView.playControlBtn setImage:[UIImage imageNamed:@"default_icon_single"] forState:UIControlStateNormal];
    }
}

/*
 *后退播放
 */
- (void)backPlayMedia {
    playerControlView.slider.value = playerControlView.slider.value - 10.0/self.currentModel.duration;
    [self.playerManager seekTo:playerControlView.slider.value];
    
}
/*
 *播放或暂停
 */
- (void)playOrPauseNote {
    [self.tableView reloadData];
    if (self.playOrPause) {
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_pause"] forState:UIControlStateNormal];
        [self play];
    } else {
        [self pause];
        [playerControlView.playBtn setImage:[UIImage imageNamed:@"default_icon_play"] forState:UIControlStateNormal];
    }
}
/*
 *前进播放
 */
- (void)forwardPlayMedia {
    playerControlView.slider.value = playerControlView.slider.value + 10.0/self.currentModel.duration;
    [self.playerManager seekTo:playerControlView.slider.value];
}

/*
 *倍率播放
 */
- (void)setPlayingRate {
    if (self.rate == 1.00) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.25"] forState:UIControlStateNormal];
        self.rate = 1.25;
    } else if(self.rate == 1.25) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.5"] forState:UIControlStateNormal];
        self.rate = 1.50;
    } else if (self.rate == 1.50) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_0.8"] forState:UIControlStateNormal];
        self.rate = 0.80;
    } else if(self.rate == 0.80) {
        [playerControlView.speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1"] forState:UIControlStateNormal];
        self.rate = 1.00;
    }
    [self.playerManager setPlayingWithRate:self.rate];
}

BOOL ipadLoadingPause = NO;

- (void)courseCacheProgress:(CGFloat)progress {
    NSLog(@"===========%f", progress);
    playerControlView.progressView.progress = progress;
    if (progress < playerControlView.slider.value) {
        //        loadingPause = NO;
        if (!ipadLoadingPause) {
            [CBLProgressHUD showLoadingHUDInView:self.view];
            ipadLoadingPause = YES;
        }
        [self pause];
        XXZQLog(@"..................");
        //        [CBLProgressHUD showTextHUDWithText:@"加载中" inView:self.view];
        //
    } else {
        if (ipadLoadingPause) {
            [self play];
            ipadLoadingPause = NO;
        }
        [CBLProgressHUD hideLoadingHUDInView:self.view];
    }
}
#pragma mark -统计时长相关
- (void)startTimer {
    if (self.listenTimer) {
        [self.listenTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:60]];
    } else{
        self.listenTimer = [HWWeakTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timeFired) userInfo:nil repeats:YES];
    }
}

- (void)pauseTime {
    [self.listenTimer  setFireDate:[NSDate distantFuture]];
}

- (void)timeFired {
    NSInteger listen = 0;
    NSInteger learn = 0;
    listen += 60;
    learn += 60;
    listen = listen *self.rate;
    learn = learn *self.rate;
    NSString *dateTime = [self getTodayDateTimeString];
    NSNumber *courseNum = [NSNumber numberWithInteger:self.courseID];
    NSString *learnCourseIdWithDate = [NSString stringWithFormat:@"learn%@%@",courseNum,dateTime];
    NSDictionary *learnDict = [[NSUserDefaults standardUserDefaults] objectForKey:learnCourseIdWithDate];
    // 获取该课程当日学习的时间总长
    NSInteger learnTotalTime = [[learnDict objectForKey:@"learnTime"] integerValue];
    NSInteger listenInt =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"listen"] integerValue];
    NSInteger learnInt = [[[NSUserDefaults standardUserDefaults] objectForKey:@"learn"] integerValue];
    NSNumber *listenNumber = [NSNumber numberWithInteger:(listen + listenInt)] ;
    NSNumber *learnNumber = [NSNumber numberWithInteger:(learn + learnInt)];
    if (learnTotalTime > self.learnSeconds + 1 ) {
        learnNumber = [NSNumber numberWithInteger:0];
    }
    
    [self postListenTime:listenNumber AndLearnTime:learnNumber];
}

- (void)postListenTime: (NSNumber *)listenNumber AndLearnTime:(NSNumber *)learnNumber {
    __block NSNumber *listeNumber = listenNumber;
    __block NSNumber *learNumber = learnNumber;
    NSString *uploadTime = [NSString stringWithFormat:@"%i",(int)[[NSDate date] timeIntervalSince1970]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:listenNumber,@"listened_time",learnNumber,@"learned_time", uploadTime ,@"upload_time", nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dateTime"];
    NSArray *array = @[@"course",[NSString stringWithFormat:@"%ld",(long)self.currentModel.courseId],@"stat"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url",parameters,@"body", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
        totalLearnTime += [learnNumber integerValue];
        NSNumber *courseNum = [NSNumber numberWithInteger:self.courseID];
        NSNumber *userNum = [NSNumber numberWithInteger:self.useID];
        NSString *dateTime = [self getTodayDateTimeString];
        NSString *listenCourseIdWithDate = [NSString stringWithFormat:@"listen%@%@",userNum,dateTime];
        NSString *learnCourseIdWithDate = [NSString stringWithFormat:@"learn%@%@",courseNum,dateTime];
        // 获取今天收听的总时长
        NSDictionary *listenDict = [[NSUserDefaults standardUserDefaults] objectForKey:listenCourseIdWithDate];
        NSInteger listenTotalTime=0;
        if (listenDict == nil) {
            listenTotalTime = 0;
        } else {
            listenTotalTime = [[listenDict objectForKey:@"listenTime"] integerValue];
        }
        
        NSNumber *totalLearnTimeNum = [NSNumber numberWithInteger:totalLearnTime];
        // 将新收听的时长加入到总时长中
        listenTotalTime += [listenNumber integerValue];
        NSNumber *totalListenTimeNum = [NSNumber numberWithInteger:listenTotalTime];
        
        // 拼接成字典写入
        NSDictionary *learnDict = [NSDictionary dictionaryWithObjectsAndKeys:dateTime,@"dateTime",courseNum,@"courseNum",totalLearnTimeNum,@"learnTime", nil];
        
        NSDictionary *listenedDict = [NSDictionary dictionaryWithObjectsAndKeys:dateTime,@"date",totalListenTimeNum,@"listenTime", nil];
        [[NSUserDefaults standardUserDefaults] setObject:listenedDict forKey:listenCourseIdWithDate];
        [[NSUserDefaults standardUserDefaults] setObject:learnDict forKey:learnCourseIdWithDate];
        NSNumber *current = [NSNumber numberWithInteger:self.learnSeconds];
        [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"current"];
        
        // 上传成功，则将上一次上传失败的数据清空
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"listen"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"learn"];
        NSString *nowTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:@"dateTime"];
        
    } failure:^(NSError *error) {
        // 上传失败应当将这次数据存起来，计入下一次的时间重新上传。
        [[NSUserDefaults standardUserDefaults] setObject:listeNumber forKey:@"listen"];
        [[NSUserDefaults standardUserDefaults] setObject:learNumber forKey:@"learn"];
        NSString *nowTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[NSUserDefaults standardUserDefaults] setObject:nowTime forKey:@"dateTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 离线统计的时长,只统计下载过的课程
        if ([self isDownloadCoursePathWithCourseId:self.currentModel.courseId andUserId:self.useID]) {
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:listenNumber,@"listened_time",learnNumber,@"learned_time", uploadTime ,@"upload_time", nil];
            NSString *offlineTime = [NSString stringWithFormat:@"%ld",(long)self.currentModel.courseId];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:parameters forKey:offlineTime];
            NSDictionary *dict = [dic copy];
            NSDictionary *offlineDict = [NSDictionary dictionary];
            offlineDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"offLineCourseDict"];
            self.offLineCourseDict = [offlineDict mutableCopy];
            [self.offLineCourseDict setObject:dict forKey:[NSString stringWithFormat:@"offlineTime%@",offlineTime]];
            if (self.offLineCourseDict) {
                NSDictionary *courseDict = [self.offLineCourseDict copy];
                if ([courseDict isKindOfClass:[NSDictionary class]]) {
                    [[NSUserDefaults standardUserDefaults] setObject:courseDict  forKey:@"offLineCourseDict"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }
    }];
}

- (void)hideNoteView:(UIButton *)sender {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = YES;
    [sender removeFromSuperview];
    NSObject *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"不再提醒"];
    if (!obj) {
        if (self.textView.text.length > 0) {
            [self alertView];
        }
    };
    [[NSUserDefaults standardUserDefaults] setObject:self.textView.text forKey:[NSString stringWithFormat:@"%ldcourseNote",(long)self.currentModel.courseId]];
    //self.writeNoteBtn.hidden = NO;
    self.bgView.hidden = YES;
    [self.noteView removeFromSuperview];
    [self.textView endEditing:YES];
}

- (void)hiddenTableView {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = YES;
    self.tableBgView.hidden = YES;
    self.bgView.hidden = YES;
    self.tableView.hidden = YES;
}

- (void)hiddenMaskView {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = YES;
    [self.maskView removeFromSuperview];
    self.maskView.hidden = YES;
    self.maskView = nil;
    
}

- (void)alertView {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = NO;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"不再提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"不再提醒" forKey:@"不再提醒"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    alertController.title = [NSString stringWithFormat:@"本次编辑已自动保存"];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

#pragma mark -播放结束以后的操作
- (void)DoSomethingWhenFinished {
    if (self.cycle == 0) {
        [self playOrPause:nil];
        [self.playerManager seekTo:0];
        playerControlView.slider.value = 0;
        playerControlView.playTimeLbl.text = @"00:00";
        playerControlView.remainTimeLbl.text = [NSString stringWithFormat:@"-%@",[self timeFormatted:self.currentModel.duration]];
    } else if(self.cycle == 1) {
        [self.playerManager seekTo:0];
        playerControlView.slider.value = 0;
        [self.playerManager play];
    } else if (self.cycle == 2) {
        self.currentCourseIndex += 1;
        if (self.currentCourseIndex < self.albumListArray.count) {
            // 暂停以上传学习时长
            [self changeCourse];
        } else if(self.currentCourseIndex == self.albumListArray.count) {
            NSLog(@"已经是最后一课了");
            self.currentCourseIndex = 0;
            [self changeCourse];
        }
    }
}


#pragma mark -tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFromDownload) {
        self.albumListArray = self.downloadedArray;
    }
    return self.albumListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //指定cellIdentifier为自定义的cell
    static  NSString *CellIdentifier = @ "TableViewCell" ;
    //自定义cell类
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if  (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@ "AlbumTableViewCell"  owner:self options:nil] lastObject];
    }
    NSInteger courseId = [[self.albumListArray[indexPath.row] objectForKey:@"id"] integerValue];
    NSObject *obj;
    if (self.isFromDownload) {
        obj = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%li",(long)courseId]];
        if (!obj) {
            obj = self.albumListArray[indexPath.row];
        }
    } else{
        obj = self.albumListArray[indexPath.row];
    }
    YLYKCourseModel *course = [YLYKCourseModel mj_objectWithKeyValues:obj];
    [YLYKCourseModel mj_replacedKeyFromPropertyName];
    cell.teacherName.text = [course.teachers[0] objectForKey:@"name"];
    NSInteger date = course.in_time;
    cell.dateLabel.text = [self timeIntervalToString:date];
    cell.titleLabel.text = course.name;
    NSInteger  duration = course.duration;
    cell.timeLabel.text =  [self anotherTimeFormatted:duration];
    if (self.courseID == [[self.albumListArray[indexPath.row] objectForKey:@"id"] integerValue]) {
        cell.selected = YES;
        [cell.titleLabel setTextColor:KColor_b41930];
        [cell.timeLabel  setTextColor:KColor_b41930];
        [cell.dateLabel setTextColor:KColor_b41930];
        [cell.teacherName setTextColor:KColor_b41930];
        [cell.timeLabel setTextColor:KColor_b41930];
        
        cell.timeLabel.alpha = 0.6;
        cell.dateLabel.alpha = 0.6;
        cell.teacherName.alpha = 0.6;
        cell.timeLabel.alpha = 0.6;
        
        
        //        [cell.timeLabel setTextColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        //        [cell.titleLabel setTextColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        //        [cell.dateLabel setTextColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        //        [cell.teacherName setTextColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        [cell.lineView1 setBackgroundColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        [cell.lineView2 setBackgroundColor:[UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]];
        cell.playBtn.hidden = NO;
        [cell.playBtn addTarget:self action:@selector(playOrPauseList:) forControlEvents:UIControlEventTouchUpInside];
        if (self.playOrPause) {
            [cell.playBtn setImage:[UIImage imageNamed:@"playlist_play"] forState:UIControlStateNormal];
        } else{
            [cell.playBtn setImage:[UIImage imageNamed:@"playlist_icon_pause_default"] forState:UIControlStateNormal];
        }
    }
    return cell;
}

#pragma mark tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.currentCourseIndex == indexPath.row) {
        if (!self.playOrPause) {
            [self pause];
            [cell.playBtn setImage:[UIImage imageNamed:@"playlist_play"] forState:UIControlStateNormal];
        } else {
            [self play];
            [cell.playBtn setImage:[UIImage imageNamed:@"playlist_icon_pause_default"] forState:UIControlStateNormal];
        }
    } else {
        [self pause];
        [cell.playBtn setImage:[UIImage imageNamed:@"playlist_play"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"要播放下一节了" forKey:@"下一节了"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"use4G"];
        NSInteger courseId = [[self.albumListArray[indexPath.row]  objectForKey:@"id"] integerValue];
        [self createPlayerModelWithCourseId:courseId];
        self.currentCourseIndex = indexPath.row;
        self.courseID = [[self.albumListArray[indexPath.row] objectForKey:@"id"] integerValue];
        [self.playerManager setPlayingWithRate:self.rate];
        [self.playerManager seekTo:0];
        playerControlView.slider.value = 0;
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.1)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -键盘弹出相关
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHolderLabel.hidden = YES;
    
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    self.placeHolderLabel.hidden = YES;
}

-  (void)textViewDidEndEditing:(UITextView *)textView
{
    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:[NSString stringWithFormat:@"%ldcourseNote",(long)self.currentModel.courseId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *) notif
{
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        self.noteView.hidden = YES;
    } else {
        NSDictionary *info = [notif userInfo];
        NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        
        double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]; // 动画的持续时间
        CGRect frame = self.noteView.frame;
        frame.origin.y = SCREEN_HEIGHT - keyboardRect.size.height - self.noteView.frame.size.height ;
        [self hidePPTView];
        //self.transluteImg.userInteractionEnabled = NO;
        [UIView animateWithDuration:duration animations:^{
            self.noteView.frame = frame;
        }];
    }
}

- (void)hidePPTView
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.bgImgView.frame;
        frame.origin.y = - 210;
        self.bgImgView.frame = frame;
        //self.webViewTopLayout.constant = 0;
        [self.view layoutIfNeeded];
        //        CGRect frameimg = self.transluteImg.frame;
        //        frameimg.origin.y = 0;
        //        self.transluteImg.frame = frameimg;
    }];
    [self.pptImgBtn setImage:[UIImage imageNamed:@"play_pulldown"] forState:UIControlStateNormal];
}

- (void)keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    //    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    CGRect frame = self.noteView.frame;
    NSLog(@"%f",frame.origin.y);
    //self.transluteImg.userInteractionEnabled = YES;
    frame.origin.y = SCREEN_HEIGHT - self.noteView.frame.size.height ;
    double duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 动画的持续时间
    [UIView animateWithDuration:duration animations:^{
        self.noteView.frame = frame;
    }];
}

#pragma mark - 监听电话通知
- (void) aboutCall{
    __weak __typeof(self)weakSelf = self;
    //获取电话接入信息
    callCenter = [CTCallCenter new];
    callCenter.callEventHandler = ^(CTCall *call){
        if ([call.callState isEqualToString:CTCallStateDisconnected]){
            NSLog(@"Call has been disconnected");
            [weakSelf play];
        }else if ([call.callState isEqualToString:CTCallStateConnected]){
            NSLog(@"Call has just been connected");
            //[weakSelf pause];
        }else if([call.callState isEqualToString:CTCallStateIncoming]){
            NSLog(@"Call is incoming");
        }else if ([call.callState isEqualToString:CTCallStateDialing]){
            NSLog(@"call is dialing");
        }else{
            NSLog(@"Nothing is done");
            [weakSelf play];
        }
    };
}

#pragma mark - actionSheetDelegate
- (void)actionAndAlertViewTitle:(NSString *)title
                    withMessage:(NSString *)message action1Title:(NSString *)action1Title action2Title:(NSString *)action2Title firstAction:(void (^)(id result))firstAction secondAction:(void (^)(id second))secondAction cancelAction:(void (^)(id cancel))cancelAction {
    //    [BugoutConfig defaultConfig].enabledShakeFeedback = NO;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:action1Title style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        firstAction(action);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:action2Title style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        secondAction(action);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        cancelAction(action);
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playerStatusChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleInterreption" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"remoteControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"otherHandleInterreption" object:nil];
    self.navigationController.navigationBarHidden = YES;
    NSLog(@"释放了");
    
    // 移除定时器
    [self.timer invalidate];
    self.timer = nil;
    NSString *timeString = playerControlView.playTimeLbl.text;
    NSNumber *courseNum = [NSNumber numberWithInteger:self.courseID];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:timeString,@"time",courseNum,@"course", nil];
    NSString *lastPlayTime = [NSString stringWithFormat:@"lastPlayTime%@",courseNum];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:lastPlayTime];
}

- (void)appWillTerminate:(NSNotification *)notification {
    NSString *timeString = playerControlView.playTimeLbl.text;
    NSNumber *courseNum = [NSNumber numberWithInteger:self.courseID];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:timeString,@"time",courseNum,@"course", nil];
    NSString *lastPlayTime = [NSString stringWithFormat:@"lastPlayTime%@",courseNum];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:lastPlayTime];
}

#pragma mark - hidePPTImg
- (void)hidePPTImg:(UIButton *)sender {
    if (self.bgImgView.frame.origin.y <0) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.bgImgView.frame;
            frame.origin.y = 0;
            self.bgImgView.frame = frame;
            // self.webViewTopLayout.constant = 210;
            [self.view layoutIfNeeded];
            //            CGRect frameimg = self.transluteImg.frame;
            //            frameimg.origin.y = 210;
            //            self.transluteImg.frame = frameimg;
        }];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"PPTImgHide"];
        [self.pptImgBtn setImage:[UIImage imageNamed:@"play_push"] forState:UIControlStateNormal];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.bgImgView.frame;
            frame.origin.y = - 210;
            self.bgImgView.frame = frame;
            //self.webViewTopLayout.constant = 0;
            [self.view layoutIfNeeded];
            //            CGRect frameimg = self.transluteImg.frame;
            //            frameimg.origin.y = 0;
            //            self.transluteImg.frame = frameimg;
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PPTImgHide"];
        [self.pptImgBtn setImage:[UIImage imageNamed:@"play_pulldown"] forState:UIControlStateNormal];
    }
}
#pragma mark -照片选择相关
- (void)showImage {
    [[NSUserDefaults standardUserDefaults] setObject:self.textView.text forKey:[NSString stringWithFormat:@"%ldcourseNote",(long)self.currentModel.courseId]];
    self.bgView.hidden = YES;
    self.noteView.hidden = YES;
    if (self.imgArray.count > 0) {
        YLYKImagePickerController *imageVc = [[YLYKImagePickerController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVc];
        imageVc.imageArray = self.imgArray;
        imageVc.imageArrayBlock = ^void(NSMutableArray *imageArray){
            self.imgArray = imageArray;
            //[self createCourseTagForBtn];
            //[self writeNote:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(9- self.imgArray.count) delegate:self];
        imagePickerVc.navigationBar.tintColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
        imagePickerVc.barItemTextColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
        imagePickerVc.takePictureImageName = @"camera";
        // 选中与未选择两种状态
        imagePickerVc.photoSelImageName = @"choosed";
        imagePickerVc.photoDefImageName = @"choose_default";
        // 完成旁边的小红点
        imagePickerVc.photoNumberIconImageName = @"number";
        //预览界面 原图旁边的选中按钮
        //        imagePickerVc.photoPreviewOriginDefImageName = @"choosed";
        // 原图旁边选择原图的样式
        imagePickerVc.photoOriginSelImageName = @"photo_select";
        // 原图旁默认未选择原图的样式
        //        imagePickerVc.photoOriginDefImageName = @"choosed";
        
        // 完成按钮的样子
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:0.5];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray *photoArray = [NSMutableArray arrayWithArray:photos];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YLYKImagePickerController *imageVc = [[YLYKImagePickerController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVc];
        
        imageVc.imageArray = photoArray;
        imageVc.imageArrayBlock = ^void(NSMutableArray *imageArray){
            self.imgArray = imageArray;
            
            //[self writeNote:nil];
        };
        [self presentViewController:nav animated:YES completion:nil];
    });
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker
{
    
}

// 取消相册
- (void)imagePickerControllerDidCancel:(YLYKImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -定位相关
- (void)showCityLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        currentCity = [[NSString alloc] init];
        //        [locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        [locationManager startUpdatingLocation];
    } else {
        currentCity = @"";
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [self.locationBtn setTitle:@"未定位" forState:UIControlStateNormal];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
        if (placemarks.count > 0) {
            //            NSLog(@"%@",placemarks);
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"点此重试";
            }
            NSLog(@"%@",currentCity); //这就是当前的城市
            currentCity = [currentCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
            [self.locationBtn setTitle:currentCity forState:UIControlStateNormal];
        }
        else if (error == nil && placemarks.count == 0) {
            [self.locationBtn setTitle:@"定位失败，点此重试" forState:UIControlStateNormal];
        }
        else if (error) {
            [self.locationBtn setTitle:@"定位失败，点此重试" forState:UIControlStateNormal];
        }
    }];
}


//#pragma mark - 打开横竖屏切换
- (BOOL)shouldAutorotate{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - lazy-load
-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableDictionary *)musicImageDic
{
    if (_musicImageDic == nil) {
        _musicImageDic = [NSMutableDictionary dictionary];
    }
    return _musicImageDic;
}

- (YLYKCourseModel *)currentModel {
    if (!_currentModel) {
        _currentModel = [[YLYKCourseModel alloc] init];
    }
    return _currentModel;
}

- (YLYKAlbumModel *)album {
    if (!_album) {
        _album = [[YLYKAlbumModel alloc] init];
    }
    return _album;
}


- (UIView *)maskView {
    if (!_maskView) {
        
        //        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.hidden = NO;
        _maskView.backgroundColor = [UIColor colorWithRed:43/255.0 green:45/255.0 blue:48/255.0 alpha:0.5];
        //        [window addSubview: _maskView];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-200);
        btn.backgroundColor=[UIColor clearColor];
        [btn addTarget:self action:@selector(hiddenMaskView) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, _maskView.frame.size.height - 300 - 8, _maskView.frame.size.width-16, 300)];
        view.backgroundColor =  [UIColor whiteColor];
        view.layer.cornerRadius = 4.0;
        view.layer.masksToBounds = YES;
        [_maskView addSubview:view];
        
        UIView *closeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 50, view.frame.size.width, 50)];
        closeBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:251/255.0 alpha:1];
        closeBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMaskView)];
        
        [closeBgView addGestureRecognizer:gesture];
        
        [view addSubview:closeBgView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(view.frame.size.width/2 - 15, 10, 30, 30);
        [button addTarget:self action:@selector(hiddenMaskView) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [closeBgView addSubview:button];
        
        self.fontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.fontBtn.frame = CGRectMake(25, 110, 40, 40);
        
        if (FONT_SIZE) {
            NSString *fontSize = [NSString stringWithFormat:@"default_icon-fontsize_%@",FONT_SIZE];
            [self.fontBtn  setImage:[UIImage imageNamed:fontSize] forState:UIControlStateNormal];
        } else {
            [self.fontBtn  setImage:[UIImage imageNamed:@"default_icon-fontsize_small"] forState:UIControlStateNormal];
        }
        
        [self.fontBtn setTitle:@"字号" forState:UIControlStateNormal];
        [self.fontBtn setTitleColor:[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0]  forState:UIControlStateNormal];
        [self.fontBtn .titleLabel setFont:[UIFont systemFontOfSize:11]];
        [self.fontBtn setTitleEdgeInsets:UIEdgeInsetsMake(80.0, -self.fontBtn.frame.size.width+5, 0.0, 0.0)];
        [self.fontBtn setImageEdgeInsets:UIEdgeInsetsMake(-20.0, 0.0, 0.0, -
                                                          self.fontBtn.titleLabel.bounds.size.width)];
        [self.fontBtn  addTarget:self action:@selector(changeFontSize) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.fontBtn ];
        
        CGFloat spaceWidth = (SCREEN_WIDTH - 210) / 3;
        self.rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rateBtn.frame = CGRectMake( 25 + (40 + spaceWidth) *3 , 110, 40, 40);
        if (self.rate == 1.25) {
            [self.rateBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.25"] forState:UIControlStateNormal];
        } else if(self.rate == 1.50) {
            [self.rateBtn setImage:[UIImage imageNamed:@"night_icon_speed_1.5"] forState:UIControlStateNormal];
        } else if (self.rate == 0.80) {
            [self.rateBtn setImage:[UIImage imageNamed:@"night_icon_speed_0.8"] forState:UIControlStateNormal];
        } else if(self.rate == 1.00) {
            [self.rateBtn setImage:[UIImage imageNamed:@"night_icon_speed_1"] forState:UIControlStateNormal];
        }
        //        [self.rateBtn setImage:[UIImage imageNamed:@"icon_speed_1"] forState:UIControlStateNormal];
        [self.rateBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [self.rateBtn addTarget:self action:@selector(setPlayingRate) forControlEvents:UIControlEventTouchUpInside];
        [self.rateBtn setTitleColor:[UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.rateBtn setTitleEdgeInsets:UIEdgeInsetsMake(80.0, -self.rateBtn.frame.size.width+5, 0.0, 0.0)];
        [self.rateBtn setImageEdgeInsets:UIEdgeInsetsMake(-20.0, 0.0, 0.0, -
                                                          self.rateBtn.titleLabel.bounds.size.width)];
        self.rateBtn.contentMode = UIViewContentModeCenter;
        [self.rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [view addSubview:self.rateBtn];
        UIButton *noteListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        noteListBtn.frame = CGRectMake(25 + (40 + spaceWidth) *2, 110, 60, 40);
        [noteListBtn setImage:[UIImage imageNamed:@"play_icon_experencelist"] forState:UIControlStateNormal];
        [playerContentFooterView.experienceLbl setText:[NSString stringWithFormat:@"心得(%ld)",(long)self.currentModel.note_count]];
        noteListBtn.contentMode = UIViewContentModeCenter;
        
        
        NSString  *likeNumber = [NSString stringWithFormat:@"赞(%ld)", (long)self.currentModel.like_count];
        [playerContentFooterView.linkCourseLbl setText:likeNumber];
        if (self.currentModel.is_liked) {
            [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_highlight"] forState:UIControlStateNormal];
            liked = NO;
        } else {
            [playerContentFooterView.linkCourseBtn setImage:[UIImage imageNamed:@"praise_default"] forState:UIControlStateNormal];
            liked = YES;
        }
    }
    return _maskView;
}

-(NSArray *)albumListArray {
    if (!_albumListArray) {
        _albumListArray = nil;
    }
    return _albumListArray;
}

- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}

- (UIView *)bgView
{
    if (!_bgView) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        
        _bgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 1024)];
        _bgView.backgroundColor = [UIColor colorWithRed:43/255.0 green:45/255.0 blue:48/255.0 alpha:0.5];
        [window addSubview:_bgView];
    }
    
    return _bgView;
}

- (NSMutableArray *)fileKeysArr
{
    if (!_fileKeysArr) {
        _fileKeysArr = [NSMutableArray array];
    }
    return _fileKeysArr;
}

- (NSMutableDictionary *)offLineCourseDict {
    if (!_offLineCourseDict) {
        _offLineCourseDict = [[NSMutableDictionary alloc] init];
    }
    return _offLineCourseDict;
}

- (UIButton *)imgBtn
{
    if (!_imgBtn) {
        _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imgBtn setImage:[UIImage imageNamed:@"upload_highlight"] forState:UIControlStateNormal];
        [_imgBtn addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
        _imgBtn.frame = CGRectMake(100, 10, 30, 30);
    }
    return _imgBtn;
}

- (UIView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIView alloc] initWithFrame:CGRectMake(0, -210, SCREEN_WIDTH, 210)];
        [self.view addSubview:_bgImgView];
        _bgImgView.backgroundColor=[UIColor whiteColor];
        
    }
    return _bgImgView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 400,461 - 44 ) style:UITableViewStylePlain];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)bgBtn
{
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _bgBtn.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [_bgBtn addTarget:self action:@selector(hideNoteView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {// 横屏
        direction = YLYKDirectionHoriztion;
    } else {//竖屏
        direction = YLYKDirectionViretial;
    }
    [self hideNoteView:noteBtn];
    playHeaderListView.hidden = YES;
    [self hidePPTView];
    [self changeFrameWhenRotate];
    NSLog(@"将要旋转了?");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    NSLog(@"如果让我旋转,我已经旋转完了!");
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)getScreenDirection {
    if ([[UIScreen mainScreen] applicationFrame].size.height == 1024) {
        direction = YLYKDirectionHoriztion;//此时为横屏
    } else {
        direction = YLYKDirectionViretial;
    }
}

@end
