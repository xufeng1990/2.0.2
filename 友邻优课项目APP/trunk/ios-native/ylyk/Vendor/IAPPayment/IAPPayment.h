//
//  IAPPayment.h
//  YLYK-App
//
//  Created by 友邻优课 on 2016/12/22.
//  Copyright © 2016年 Beijing Zhuomo Culture Media Co., Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

@protocol IAPManagerDelegate <NSObject>

@optional

- (void)receiveProduct:(SKProduct *)product;

- (void)successfulPurchaseOfId:(NSString *)productId andReceipt:(NSData *)transactionReceipt;

- (void)failedPurchaseWithError:(NSString *)errorDescripiton;

@end


@interface IAPPayment : NSObject

@property (nonatomic, assign) id <IAPManagerDelegate>delegate;

+ (instancetype)sharedManager;

- (BOOL)requestProductWithId:(NSString *)productId;

- (BOOL)purchaseProduct:(SKProduct *)skProduct;

- (BOOL)restorePurchase;

@end


