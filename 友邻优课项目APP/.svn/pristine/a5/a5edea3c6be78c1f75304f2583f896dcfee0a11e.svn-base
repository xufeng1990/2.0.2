//
//  YLYKPlayerControlView.h
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLYKSlider.h"


/*
 *播放控制器控制台事件
 */
typedef NS_ENUM(NSInteger, YLYKPlayerControlEvent) {
    YLYKPlayerControlEventCycle      = 170420,
    YLYKPlayerControlEventBack       = 170421,
    YLYKPlayerControlEventPlay       = 170422,
    YLYKPlayerControlEventForward    = 170423,
    YLYKPlayerControlEventSpeed      = 170424,
    YLYKPlayerControlEventFontSize   = 170425,
    YLYKPlayerControlEventNote       = 170426,
    YLYKPlayerControlEventAlbumList  = 170427,
    YLYKPlayerControlEventWriteNote  = 170428,
};

/*
 *slider 滑动回调事件
 */
typedef NS_ENUM(NSInteger, YLYKSliderEvent) {
    YLYKSliderEventValueChanged      = 170430,
    YLYKSliderEventTouchCancel       = 170431,
    YLYKSliderEventTouchUp           = 170432,
};

/*
 *横竖屏方向
 */
typedef NS_ENUM(NSInteger, YLYKDirection) {
    YLYKDirectionHoriztion      = 0,
    YLYKDirectionViretial       = 1,
};

typedef void(^YLYKPlayerControlEventBlock)(YLYKPlayerControlEvent enventType);
typedef void(^YLYKPlayerSliderEventBlock)(YLYKSliderEvent sliderEnventType,UISlider *sender);


@interface YLYKPlayerControlView : UIView


/*
 *控制事件代码块
 */
@property(nonatomic,copy)YLYKPlayerControlEventBlock controlEventBlock;

/*
 *slider事件代码块
 */
@property(nonatomic,copy)YLYKPlayerSliderEventBlock sliderEventBlock;

/*
 *播放循环控制按钮
 */
@property(nonatomic,strong) UIButton * playControlBtn;

/*
 *后退播放按钮
 */
@property(nonatomic,strong) UIButton * backBtn;

/*
 *播放暂停按钮
 */
@property(nonatomic,strong) UIButton * playBtn;

/*
 *前进按钮
 */
@property(nonatomic,strong) UIButton * forwardBtn;

/*
 *加速按钮
 */
@property(nonatomic,strong) UIButton * speedBtn;

/*
 *播放进度条progressView
 */
@property(nonatomic,strong) UIProgressView * progressView;

/*
 *播放时间
 */
@property(nonatomic,strong) UILabel * playTimeLbl;

/*
 *剩余时间
 */
@property(nonatomic,strong) UILabel * remainTimeLbl;

/*
 *播放滑动控件 slider
 */
@property (strong, nonatomic) YLYKSlider * slider;



/*
 *竖屏多增加 4 个按钮 字号 心得 列表 写心得
 */
@property(nonatomic,strong) UIButton * fontSizeBtn;
@property(nonatomic,strong) UIButton * noteBtn;
@property(nonatomic,strong) UIButton * albumListBtn;
@property(nonatomic,strong) UIButton * writeNoteBtn;

/*
 *横竖屏类型
 */
@property(nonatomic,assign)YLYKDirection direction;

#pragma mark - Public Method

/*
 *加载视图
 */
- (void)loadView;

/*
 *通过代码块获取回调方法
 */

- (void)getControlEventCallBack:(YLYKPlayerControlEventBlock)controlEventBlock;

- (void)getSliderEventCallBack:(YLYKPlayerSliderEventBlock)sliderEventBlock;


@end
