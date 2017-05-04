//
//  YLYKPlayerSetSkinView.m
//  ylyk
//
//  Created by 许锋 on 2017/4/26.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKPlayerSetSkinView.h"
#import "UIImage+FromColor.h"

@interface YLYKPlayerSetSkinView () {
    UIView *bottomBgView; //底部背景视图
    UIButton *cancelBtn; //取消隐藏按钮
    
    UIImageView *brightnessMinImg; //亮度最小图标
    UIImageView *brightnessMaxImg; //亮度最大图标
    
    UIImageView *nightViewImgView;
}

@end


@implementation YLYKPlayerSetSkinView

#define BgView_Height 225

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
        self.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBgView:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tapGesture];
        
        [self configView];
        [self loadView];
    }
    return self;
}
- (void)configView {
    
    [self addSubview:self.contentBgView];
    [self getMinBrightnessImgView];
    [self.contentBgView addSubview:brightnessMinImg];
    [self.contentBgView addSubview:self.progressView];
    [self.contentBgView addSubview:self.brightnessControlSlider];
    [self getMaxBrightnessImgView];
    [self.contentBgView addSubview:brightnessMaxImg];
    [self.contentBgView addSubview:self.bgColorBtn1];
    [self.contentBgView addSubview:self.bgColorBtn2];
    [self.contentBgView addSubview:self.bgColorBtn3];
    [self.contentBgView addSubview:self.bgColorBtn4];
    
    nightViewImgView = [[UIImageView alloc]init];
    nightViewImgView.image = [UIImage imageNamed:@"icon_night"];
    [self.bgColorBtn4 addSubview:nightViewImgView];
    
    bottomBgView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomBgView.backgroundColor = [UIColor colorWithHexString:@"#f8fafa"];
    [self.contentBgView addSubview:bottomBgView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"default_icon-close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeSkinView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBgView addSubview:cancelBtn];
    
    
}

/**   加载视图  **/
- (void)loadView {
    CGRect frame = CGRectMake(8, SCREEN_HEIGHT - BgView_Height - 7 , SCREEN_WIDTH - 16, BgView_Height);
    self.contentBgView.frame = frame;
    
    bottomBgView.frame = CGRectMake(0, BgView_Height - 49, SCREEN_WIDTH - 16, 49);
    
    cancelBtn.frame = CGRectMake((self.contentBgView.frame.size.width - 30) / 2.0, 7, 30, 30);
    
    CGFloat btnWidth = (SCREEN_WIDTH - 16 - 20 * 2 - 10 *3) / 4.0;
    
    //亮度大 小 图标标识
    
    frame = CGRectMake(21, 54, 12, 12);
    brightnessMinImg.frame = frame;
    brightnessMinImg.image = [UIImage imageNamed:KPlayerSetBrightenSmallImg];
    
    frame = CGRectMake(self.contentBgView.frame.size.width - 20 - 18, 50, 18, 18);
    brightnessMaxImg.frame = frame;
    brightnessMaxImg.image = [UIImage imageNamed:KPlayerSetBrightenBigImg];
    
    
    //播放进度条progressView
    frame = CGRectMake(42, 61, SCREEN_WIDTH - 16 - 90, 3);
    self.progressView.frame = frame;
    
    //亮度控制条
    frame = CGRectMake(42, 61 - 15 , SCREEN_WIDTH - 16 - 90, 30);
    self.brightnessControlSlider.frame = frame;
    self.brightnessControlSlider.value = KScreenNightenValue;
    //背景色选择按钮
    frame = CGRectMake(20, 100, btnWidth, 30);
    self.bgColorBtn1.frame = frame;
    
    frame = CGRectMake(self.bgColorBtn1.right + 10, 100, btnWidth, 30);
    self.bgColorBtn2.frame = frame;
    
    frame = CGRectMake(self.bgColorBtn2.right + 10, 100, btnWidth, 30);
    self.bgColorBtn3.frame = frame;
    
    frame = CGRectMake(self.bgColorBtn3.right + 10, 100, btnWidth, 30);
    self.bgColorBtn4.frame = frame;
    
    frame = CGRectMake((btnWidth - 11)/2.0, 9, 11, 12);
    nightViewImgView.frame = frame;
    
}

//点击空白处隐藏提示视图
-(void)tapBgView:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self];
    if (point.y < SCREEN_HEIGHT - BgView_Height - 8) {
        //[self removeFromSuperview];
        self.hidden = YES;
    }
}
- (void)closeSkinView:(UIButton *)sender {
    self.hidden = YES;
}

- (void)show {
    self.hidden = NO;
}


- (void)setBgColor:(UIColor *)bgColor bottomBgColor:(UIColor *)bottomBgColor aplha:(CGFloat)aplha {
    if (bgColor) {
        self.contentBgView.backgroundColor = bgColor;
        //self.contentBgView.alpha = 0.88;
    }
    if (bottomBgColor) {
        bottomBgView.backgroundColor = bottomBgColor;
    }
    bottomBgView.alpha = aplha;
    _bgColorBtn1.layer.borderColor = bgColor.CGColor;
    _bgColorBtn2.layer.borderColor = bgColor.CGColor;
    _bgColorBtn3.layer.borderColor = bgColor.CGColor;
    _bgColorBtn4.layer.borderColor = bgColor.CGColor;

}
- (void)setBrightnesBgImage:(UIImage *)smallImg bigImg:(UIImage *)bigImg  dotImg:(UIImage *)dotImg {
    brightnessMinImg.image = smallImg;
    brightnessMaxImg.image = bigImg;
}

- (void)setSelectSkinBgAlpha:(YLYKPlayerSkinType)playerSkinType {
    switch (playerSkinType) {
        case YLYKPlayerSkinType1:
        {
            self.bgColorBtn1.alpha = 1;
            self.bgColorBtn2.alpha = 1;
            self.bgColorBtn3.alpha = 1;
            self.bgColorBtn4.alpha = 1;

        }
            break;
        case YLYKPlayerSkinType2:
        {
            self.bgColorBtn1.alpha = 1;
            self.bgColorBtn2.alpha = 1;
            self.bgColorBtn3.alpha = 1;
            self.bgColorBtn4.alpha = 1;
        }
            break;
        case YLYKPlayerSkinType3:
        {
            self.bgColorBtn1.alpha = 1;
            self.bgColorBtn2.alpha = 1;
            self.bgColorBtn3.alpha = 1;
            self.bgColorBtn4.alpha = 1;
        }
            break;
        case YLYKPlayerSkinType4:
        {
            self.bgColorBtn1.alpha = 1;
            self.bgColorBtn2.alpha = 1;
            self.bgColorBtn3.alpha = 1;
            self.bgColorBtn4.alpha = 1;
            
        }
            break;
            
        default:
            break;
    }
}

- (void)setSliderProgressImg:(UIImage *)sliderBgImage progressDefaultImage:(UIImage *)progressDefaultImage progressHighlightImage:(UIImage *)progressHighlightImage {
    //设置播放进度条颜色
    [_brightnessControlSlider setMinimumTrackImage:sliderBgImage forState:UIControlStateNormal];
    [_brightnessControlSlider setThumbImage:progressHighlightImage forState:UIControlStateHighlighted];
    [_brightnessControlSlider setThumbImage:progressDefaultImage forState:UIControlStateNormal];
}

/*
 *通过代码块获取回调方法
 */

- (void)getPlayerSkinCallBack:(YLYKPlayerSkinTypeBlock)skinTypeBlock {
    self.skinType = skinTypeBlock;
}

- (void)getSliderEventCallBack:(YLYKPlayerSliderEventBlock)sliderEventBlock {
    self.sliderEventBlock = sliderEventBlock;
    
}

#pragma mark -slider手势相关：slider
//移动滑块调整播放进度
- (void)sliderValueChanged:(UISlider *)sender {
    self.sliderEventBlock(YLYKSliderEventValueChanged,sender);
}

- (void)touchCancel:(UISlider *)sender {
    self.sliderEventBlock(YLYKSliderEventTouchCancel,sender);
}

- (void)touchUp:(UISlider *)sender {
    self.sliderEventBlock(YLYKSliderEventTouchUp,sender);
}

/*
 *设置播放背景皮肤
 */
- (void)setPlayerSkin:(UIButton *)sender {
    switch (sender.tag) {
        case YLYKPlayerSkinType1:
        {
            NSLog(@"颜色1");
            self.skinType(YLYKPlayerSkinType1);
            
        }
            break;
        case YLYKPlayerSkinType2:
        {
            NSLog(@"颜色2");
            self.skinType(YLYKPlayerSkinType2);
           
            
        }
            break;
        case YLYKPlayerSkinType3:
        {
            NSLog(@"颜色3");
            self.skinType(YLYKPlayerSkinType3);
           
        }
            break;
        case YLYKPlayerSkinType4:
        {
            NSLog(@"颜色4");
            self.skinType(YLYKPlayerSkinType4);
           
            
        }
            break;
            
            
        default:
            break;
    }
}

#pragma maark - Get Methods

/*
 *获取亮度最小图标
 */
- (void)getMinBrightnessImgView {
    if (!brightnessMinImg) {
        brightnessMinImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        brightnessMinImg.image = [UIImage imageNamed:@"default_icon_lighten_small"];
    }
}

/*
 *获取亮度最大图标
 */
- (void)getMaxBrightnessImgView {
    if (!brightnessMaxImg) {
        brightnessMaxImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        brightnessMaxImg.image = [UIImage imageNamed:@"default_icon_lighten_default"];
    }
}
/*
 *亮度调整
 */
- (YLYKSlider *)brightnessControlSlider {
    if (!_brightnessControlSlider) {
        //左右轨的图片
        UIImage *stetchLeftTrack     = [UIImage imageNamed:@"slider_bg"];
       // UIImage *stetchRightTrack    = [UIImage imageNamed:@"play_toumiingmengceng"];
        UIImage *stetchRightTrack = nil;
        stetchRightTrack    = [stetchRightTrack imageWithColor:[UIColor grayColor] size:CGSizeMake(768, 3)];
        //滑块图片
        UIImage *thumbImage          = [UIImage imageNamed:@"slider"];
        UIImage *thumbImageHighlight = [UIImage imageNamed:@"slider_seleted"];
        _brightnessControlSlider = [[YLYKSlider alloc] initWithFrame:CGRectZero];
        _brightnessControlSlider.maximumTrackTintColor = [UIColor clearColor];
        _brightnessControlSlider.backgroundColor = [UIColor clearColor];
        _brightnessControlSlider.value = 0.5;
        _brightnessControlSlider.minimumValue = 0.0;
        _brightnessControlSlider.maximumValue = 1.0;
        [_brightnessControlSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [_brightnessControlSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_brightnessControlSlider setThumbImage:thumbImageHighlight forState:UIControlStateHighlighted];
        [_brightnessControlSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        
        //滑块拖动时的事件
        [_brightnessControlSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_brightnessControlSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_brightnessControlSlider addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventAllTouchEvents];
    }
    return _brightnessControlSlider;
}

/*
 *播放进度条progressView
 */
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor=[UIColor lightGrayColor];
        //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
        _progressView.trackTintColor =[UIColor lightGrayColor];
    };
    return _progressView;
}
/*
 *背景颜色
 *bgColorBtn1 #f8fafa
 *bgColorBtn2 #bce0c2
 *bgColorBtn3 #f9f2e2
 *bgColorBtn4 #171717
 */
- (UIButton *)bgColorBtn1 {
    if (!_bgColorBtn1) {
        _bgColorBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgColorBtn1 setBackgroundColor:[UIColor colorWithHexString:@"#f8fafa"]];
        [_bgColorBtn1 addTarget:self action:@selector(setPlayerSkin:) forControlEvents:UIControlEventTouchUpInside];
        [_bgColorBtn1 setTag:YLYKPlayerSkinType1];
        _bgColorBtn1.layer.masksToBounds = YES;
        _bgColorBtn1.layer.cornerRadius = 4.0;
        _bgColorBtn1.layer.borderWidth = 2;
        _bgColorBtn1.layer.borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1].CGColor;

    }
    return _bgColorBtn1;
}

- (UIButton *)bgColorBtn2 {
    if (!_bgColorBtn2) {
        _bgColorBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgColorBtn2 setBackgroundColor:[UIColor colorWithHexString:@"#bce0c2"]];
        [_bgColorBtn2 addTarget:self action:@selector(setPlayerSkin:) forControlEvents:UIControlEventTouchUpInside];
        [_bgColorBtn2 setTag:YLYKPlayerSkinType2];
        _bgColorBtn2.layer.masksToBounds = YES;
        _bgColorBtn2.layer.cornerRadius = 4.0;
        _bgColorBtn2.layer.borderWidth = 2;
        _bgColorBtn2.layer.borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1].CGColor;
    }
    return _bgColorBtn2;
}

- (UIButton *)bgColorBtn3 {
    if (!_bgColorBtn3) {
        _bgColorBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgColorBtn3 setBackgroundColor:[UIColor colorWithHexString:@"#f9f2e2"]];
        [_bgColorBtn3 addTarget:self action:@selector(setPlayerSkin:) forControlEvents:UIControlEventTouchUpInside];
        [_bgColorBtn3 setTag:YLYKPlayerSkinType3];
        _bgColorBtn3.layer.masksToBounds = YES;
        _bgColorBtn3.layer.cornerRadius = 4.0;
        _bgColorBtn3.layer.borderWidth = 2;
        _bgColorBtn3.layer.borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1].CGColor;


    }
    return _bgColorBtn3;
}

- (UIButton *)bgColorBtn4 {
    if (!_bgColorBtn4) {
        _bgColorBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgColorBtn4 setBackgroundColor:[UIColor colorWithHexString:@"#171717"]];
        [_bgColorBtn4 addTarget:self action:@selector(setPlayerSkin:) forControlEvents:UIControlEventTouchUpInside];
        [_bgColorBtn4 setTag:YLYKPlayerSkinType4];
        _bgColorBtn4.layer.masksToBounds = YES;
        _bgColorBtn4.layer.cornerRadius = 4.0;
        _bgColorBtn4.layer.borderWidth = 2;
        _bgColorBtn4.layer.borderColor = [UIColor colorWithRed:200 green:200 blue:200 alpha:1].CGColor;

    }
    return _bgColorBtn4;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentBgView.userInteractionEnabled = YES;
        _contentBgView.backgroundColor = [UIColor whiteColor];
        _contentBgView.layer.masksToBounds = YES;
        _contentBgView.layer.cornerRadius  = 4.0;
    }
    return _contentBgView;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
