//
//  WechatBridge.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/19.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKWechatNativeModule.h"
#import "WXApi.h"
#import "YLYKServiceModule.h"
#import "NSStringTools.h"
#import "AppDelegate.h"
#import "YLYKOrderServiceModule.h"

@implementation YLYKWechatNativeModule

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(goToPay:(NSDictionary *)parameters resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    NSDictionary *dict = @{@"goods_id": @"37",
                           @"channel":@"WX_APP",
                           @"count": @"1"};
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [YLYKOrderServiceModule createOrderWithParameters:dict success:^(id responseObject) {
            XXZQLog(@"%@",responseObject);
            NSDictionary *dict = [NSStringTools getDictionaryWithJsonstring:responseObject];
//            NSString *result = [dict objectForKey:@"result"];
            if ([[dict objectForKey:@"result"] integerValue]== 1) {
                NSDictionary *packageDict = [dict objectForKey:@"package"];
                [[NSUserDefaults standardUserDefaults] setObject:[packageDict objectForKey:@"order_id"] forKey:@"order_id"];
                NSDictionary *payment = [packageDict objectForKey:@"payment"];
                NSString *partner_id = [payment objectForKey:@"partner_id"];
                NSString *package = [payment objectForKey:@"package"];
                NSString *prepay_id = [payment objectForKey:@"prepay_id"];
                NSString *nonce_str= [payment objectForKey:@"nonce_str"];
                NSString *timestamp = [payment objectForKey:@"timestamp"];
                NSString *sign = [payment objectForKey:@"sign"];
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = partner_id;
                request.prepayId = prepay_id;
                request.package = package;
                request.nonceStr = nonce_str;
                request.timeStamp = [timestamp intValue];
                request.sign = sign;
                [WXApi sendReq:request];
                ((AppDelegate *)[UIApplication sharedApplication].delegate).paymentStateBlock = ^void(NSDictionary *success){
                    resolve(success);
                };
            } else {
                NSDictionary *package = [dict objectForKey:@"package"];
                NSString *message = [package objectForKey:@"message"];
                [CBLProgressHUD showTextHUDInWindowWithText:message];
            }
        } failure:^(NSError *error) {
            [CBLProgressHUD showTextHUDInWindowWithText:@"创建订单失败,请重试"];
        }];
    });
}

RCT_REMAP_METHOD(openWXApp,openWXApp:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [WXApi openWXApp];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}
@end
