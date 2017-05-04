//
//  IAPPlugin.m
//  YLYK-App
//
//  Created by 友邻优课 on 2016/12/22.
//  Copyright © 2016年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//

#import "YLYKIAPPayNativeModule.h"
#import "IAPPayment.h"
#import "CBLProgressHUD.h"
#import "YLYKServiceModule.h"
#import "YLYKServiceModule.h"
#import "NSStringTools.h"

@interface YLYKIAPPayNativeModule() <IAPManagerDelegate> {
    NSString * _successCallback;
    NSString * _errorCallback;
}

@property (strong, nonatomic) IAPPayment *iapPayment;

@end

@implementation YLYKIAPPayNativeModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(onIAPPay) {
    NSString *CurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [YLYKServiceModule getSystemVersionsuccess:^(id responseObject) {
        NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:responseObject];
        NSDictionary *client = [dict objectForKey:@"client"];
        NSDictionary *iosClient = [client objectForKey:@"ios"];
        NSString *reviewVersionCode = [[iosClient objectForKey:@"review"] objectForKey:@"version_code"];
        NSString *productId = [[iosClient objectForKey:@"review"] objectForKey:@"product_id"];
        if (reviewVersionCode && [reviewVersionCode integerValue] <= [CurrentVersion integerValue]) {
            self.iapPayment = [IAPPayment sharedManager];
            self.iapPayment.delegate = self;
            if ([productId integerValue] == 11365) {
                 [self.iapPayment requestProductWithId:productId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CBLProgressHUD showLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
                });
            }
        }
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CBLProgressHUD showTextHUDInWindowWithText:@"获取商品信息失败"];
        });
    }];
}

- (void)receiveProduct:(SKProduct *)product {
    if (product != nil) {
        if (![self.iapPayment purchaseProduct:product]) {
            [self sendCallbackToJavaScriptWithStatus:@"error" andMessage:@"您禁止了应用内购买权限,请到设置中开启"];
        }
    } else {
        [self sendCallbackToJavaScriptWithStatus:@"error" andMessage:@"无法连接至appstore"];
    }
}

// 向自己的服务器验证购买凭证（此处应该考虑将凭证本地保存,对服务器有失败重发机制）
// 服务器要做的事情:
// 接收ios端发过来的购买凭证。
// 判断凭证是否已经存在或验证过，然后存储该凭证。
// 将该凭证发送到苹果的服务器验证，并将验证结果返回给客户端。
// 如果需要，修改用户相应的会员权限

- (void)successfulPurchaseOfId:(NSString *)productId andReceipt:(NSData *)transactionReceipt {
    NSString  *transactionReceiptString = [transactionReceipt base64EncodedStringWithOptions:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [CBLProgressHUD showLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
    });
    if ([transactionReceiptString length] > 0) {
        
        NSString * receipt = [[NSUserDefaults standardUserDefaults] objectForKey:@"receiptObject"];
        
        XXZQLog(@"transactionReceiptString%@", transactionReceiptString);
        
        if (receipt == transactionReceiptString) {
            XXZQLog(@"非法购买");
        } else {
            // 存在本地
            [[NSUserDefaults standardUserDefaults] setObject:transactionReceiptString forKey:@"receiptObject"];
            
            NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
            
            // https://sandbox.itunes.apple.com/verifyReceipt 测试地址
            // https://buy.itunes.apple.com/verifyReceipt 正式发布验证地址
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
            request.HTTPMethod = @"POST";
            NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", transactionReceiptString];
            NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
            
            request.HTTPBody = payloadData;
            // 提交验证请求，并获得官方的验证JSON结果
            NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            // 官方验证结果为空
            if (result == nil) {
                [self sendCallbackToJavaScriptWithStatus:@"error" andMessage:@"验证失败"];
                XXZQLog(@"验证失败");
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            XXZQLog(@"%@", dict);
            
            if (dict != nil) {
                // 比对字典中以下信息基本上可以保证数据安全
                // bundle_id&application_version&product_id&transaction_id
                XXZQLog(@"验证成功");
                NSArray *array = @[@"vip",@"iap"];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array,@"url", nil];
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
           
                [[YLYKServiceModule sharedInstance] postWithURLString:str success:^(id responseObject) {
                    NSLog(@"%@",responseObject);
                } failure:^(NSError *error) {
                    
                }];
                [self sendCallbackToJavaScriptWithStatus:@"success" andMessage:@"交易成功"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [CBLProgressHUD hideLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
            });
        }
        [self sendCallbackToJavaScriptWithStatus:@"success" andMessage:@"交易成功"];
    }
}

// 购买失败的原因
- (void)failedPurchaseWithError:(NSString *)errorDescripiton {
    XXZQLog(@"购买失败");
    [self sendCallbackToJavaScriptWithStatus:@"error" andMessage:errorDescripiton];
}

// 完成事件以后通知js的方法
- (void)sendCallbackToJavaScriptWithStatus: (NSString *)status andMessage: (NSString *)message {
    int resultWithStatus;
    NSString * _callbackID;
    dispatch_async(dispatch_get_main_queue(), ^{
        [CBLProgressHUD hideLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
    });
    if ([status isEqualToString:@"success"]) {
        resultWithStatus = 1;
        _callbackID = _successCallback;
    } else {
        resultWithStatus = 2;
        _callbackID = _errorCallback;
    }
}

@end
