//
//  SearchBridge.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKSearchNativeModule.h"
#import <PYSearch.h>
#import "YLYKCourseServiceModule.h"
#import "YLYKServiceModule.h"
#import "YLYKSearchResultViewController.h"
#import "NSStringTools.h"
#import "YLYKCourseModel.h"
#import "MJExtension.h"
#import "YLYKServiceModule.h"

@interface YLYKSearchNativeModule ()

@property (nonatomic, strong) NSMutableArray *courseArray;

@end


@implementation YLYKSearchNativeModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(goToSearchView) {
    self.courseArray = [NSMutableArray array];
    dispatch_async(dispatch_get_main_queue(), ^{
        PYSearchViewController *searchVC = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"搜索课程" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            
            NSDictionary *parameters = @{@"keyword":searchText};
            
            NSString *netStatus = [YLYKServiceModule getSystemNetworkState];
            
            if ([netStatus isEqualToString:@"notReachable"]) {
                [CBLProgressHUD showTextHUDInWindowWithText:@"无法连接至网络，请检查网络设置"];
                return;
            }
            
            [YLYKCourseServiceModule getCourseList:parameters success:^(id responseObject) {
                XXZQLog(@"%@",responseObject);
                [self.courseArray removeAllObjects];
                NSMutableArray *resultArray = [NSStringTools getArrayWithJSONString:responseObject];
                if (resultArray.count > 0) {
                    for (NSDictionary *dict in resultArray) {
                        YLYKCourseModel *course = [YLYKCourseModel mj_objectWithKeyValues:dict];
                        [self.courseArray addObject:course];
                    }
                    YLYKSearchResultViewController *result = [[YLYKSearchResultViewController alloc] init];
                    result.searchText = searchText;
                    result.resultArray = self.courseArray;
                    [searchViewController.navigationController pushViewController:result animated:YES];
                } else {
                    [CBLProgressHUD showTextHUDInWindowWithText:@"没有搜索结果"];
                }
            } failure:^(NSError *error) {
                [CBLProgressHUD showTextHUDInWindowWithText:@"搜索失败"];
                NSString *errCode = [self getErrorCodeWithError:error];
                NSString *errMessage = [self getErrorMessageWithError:error];
                XXZQLog(@"%@,%@",errCode,errMessage);
                if (!errCode && !errMessage) {
                    
                }
            }];
        }];
        searchVC.navigationController.navigationBar.translucent = NO;
        searchVC.searchHistoriesCount = 6;
        searchVC.searchBar.frame = CGRectMake(100, 0, 100 , 32);
        searchVC.searchBarBackgroundColor = [UIColor colorWithRed:242/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
        [searchVC.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0]];
        YLYKNavigationController *nav =
        [[YLYKNavigationController alloc] initWithRootViewController:searchVC];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        UINavigationController *nav1 = (UINavigationController *)window.rootViewController;
        [nav1 presentViewController:nav animated:YES completion:nil];
    });
}

- (NSString *)getErrorMessageWithError:(NSError *)error {
    NSData * errmessageData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString * errorString = [[NSString alloc] initWithData:errmessageData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:errorString];
    NSString *errorMessage = [dict objectForKey:@"error_message"];
    return errorMessage;
}

- (NSString *)getErrorCodeWithError:(NSError *)error {
    NSData * errmessageData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSString * errorString = [[NSString alloc] initWithData:errmessageData encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:errorString];
    NSString * errorCode = [dict objectForKey:@"error_code"];
    return errorCode;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}
@end
