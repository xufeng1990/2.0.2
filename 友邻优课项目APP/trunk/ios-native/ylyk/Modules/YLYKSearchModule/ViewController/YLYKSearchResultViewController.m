//
//  SearchResultViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/3/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKSearchResultViewController.h"
#import "YLYKSearchResultCell.h"
#import "YLYKCourseModel.h"
#import "UIImageView+WebCache.h"
#import "YLYKPlayerViewController.h"
#import "CourseViewController.h"
#import "YLYKHighlightingFontManager.h"

@interface YLYKSearchResultViewController () <UITableViewDelegate,UITableViewDataSource> {
    YLYKHighlightingFontManager *highlightingFontManager;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YLYKSearchResultViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView];
    
    highlightingFontManager = [YLYKHighlightingFontManager shareInstance];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationItem.title = @"搜索结果";
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(back)];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTableView {
    [self.view addSubview:self.tableView];
}

#pragma mark - tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static  NSString *CellIdentifier = @"YLYKSearchResultCell" ;
    //自定义cell类
    YLYKSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if  (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@ "YLYKSearchResultCell"  owner:self options:nil] lastObject];
    }
    YLYKCourseModel *course = self.resultArray[indexPath.row];
    //cell.teacherNmae.attributedText = [self string:[course.teachers[0] objectForKey:@"name"] highlightString:self.searchText];
    //cell.courseName.attributedText = [self string:course.name highlightString:self.searchText];
    NSInteger duration = course.duration;
    cell.courseDuration.text =  [self anotherTimeFormatted:duration];
    [cell.courseImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@course/%ld/cover",BASEURL_STRING,(long)course.courseId]] placeholderImage:[[UIImage alloc] init]];
    //cell.albumName.attributedText =  [self string:[course.album objectForKey:@"name"] highlightString:self.searchText] ;
    
    NSString *teacherName = [course.teachers[0] objectForKey:@"name"];
    NSString *courseName  = course.name;
    NSString *albumName   = [course.album objectForKey:@"name"];
    
    cell.teacherNmae.attributedText = [highlightingFontManager getHiglightingFontString:teacherName keyString:self.searchText font:[UIFont systemFontOfSize:11] highlightingColor:[UIColor colorWithHexString:@"#b41930"]] ;
    
    cell.courseName.attributedText = [highlightingFontManager getHiglightingFontString:courseName keyString:self.searchText font:[UIFont systemFontOfSize:16] highlightingColor:[UIColor colorWithHexString:@"#b41930"]];
    cell.albumName.attributedText = [highlightingFontManager getHiglightingFontString:albumName keyString:self.searchText font:[UIFont systemFontOfSize:11] highlightingColor:[UIColor colorWithHexString:@"#b41930"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YLYKCourseModel *course = [self.resultArray objectAtSafetyIndex:indexPath.row];;
    CourseViewController *courseVC = [[CourseViewController alloc] init];
    [courseVC openPlayerController:[NSString stringWithFormat:@"%ld",(long)course.courseId] fromHomeOrDownload:nil courseListString:nil resolver:^(id result) {
        
    } rejecter:^(NSString *code, NSString *message, NSError *error) {
        
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

//#pragma mark - 字符串拆分方法
//// 中英文拆开，先暂时搁置
//- (NSString *)getChineseStringWithString:(NSString *)string {
//    //(unicode中文编码范围是0x4e00~0x9fa5)
//    for (int i = 0; i < string.length; i++) {
//        int utfCode = 0;
//        void *buffer = &utfCode;
//        NSRange range = NSMakeRange(i, 1);
//        BOOL b = [string getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
//        if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)) {
//            return [string substringFromIndex:i];
//        }
//    }
//    return nil;
//}
//- (NSMutableAttributedString *)string:(NSString *)result highlightString:(NSString *)keyword {
//    NSMutableAttributedString *attrituteString = [[NSMutableAttributedString alloc] initWithString:result];
//    NSString *newStr = keyword;
//    NSString *temp =nil;
//    for(int i =0; i < [newStr length]; i++)
//    {
//        temp = [newStr substringWithRange:NSMakeRange(i,1)];
//        NSArray *arr = [self rangeOfSubString:temp inString:result];
//        for (NSString *rangeStr in arr) {
//            NSRange range = NSRangeFromString(rangeStr);
//            //[attrituteString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:(178/255.0) green:(29/255.0) blue:(51/255.0) alpha:1.0]} range:range];
//        }
//    }
//    return attrituteString;
//}
//
//- (NSArray *)rangeOfSubString:(NSString *)subStr inString:(NSString *)string {
//    NSMutableArray *rangeArray = [NSMutableArray array];
//    NSString *string1 = [string stringByAppendingString:subStr];
//    NSString *temp;
//    for (int i = 0; i < string.length; i ++) {
//        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
//        if ([temp isEqualToString:subStr]) {
//            NSRange range = {i,subStr.length};
//            [rangeArray addObject:NSStringFromRange(range)];
//        }
//    }
//    return rangeArray;
//}

- (NSString *)anotherTimeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02ld'%02ld''",(long)minutes, (long)seconds];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.rowHeight = 90;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
