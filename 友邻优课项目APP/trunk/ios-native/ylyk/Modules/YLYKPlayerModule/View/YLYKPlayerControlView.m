//
//  YLYKPlayerControlView.m
//  ylyk
//
//  Created by 许锋 on 2017/4/25.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKPlayerControlView.h"
#import "UIImage+FromColor.h"

@implementation YLYKPlayerControlView

#pragma mark - Init
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}


- (void)configView {
    
    [self addSubview:self.playControlBtn];
    [self addSubview:self.backBtn];
    [self addSubview:self.playBtn];
    [self addSubview:self.forwardBtn];
    [self addSubview:self.speedBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.playTimeLbl];
    [self addSubview:self.remainTimeLbl];
    [self addSubview:self.slider];
    
    [self addSubview:self.fontSizeBtn];
    [self addSubview:self.noteBtn];
    [self addSubview:self.albumListBtn];
    [self addSubview:self.writeNoteBtn];
}

/**   加载视图  **/
- (void)loadView {
    switch (_direction) {
        case YLYKDirectionViretial:
        {
            [self loadVerticalView];
        }
            break;
        case YLYKDirectionHoriztion:
        {
            [self loadHorizontalView];
        }
            break;
        default:
            break;
    }
}

/*
 *加载横屏布局视图
 */
- (void)loadHorizontalView {
    
    self.fontSizeBtn.hidden = YES;
    self.noteBtn.hidden = YES;
    self.albumListBtn.hidden = YES;
    self.writeNoteBtn.hidden = YES;
    
    CGFloat space = 71;
    CGRect frame = CGRectMake(24, 12, 24, 24);
    
    //播放控制按钮
    self.playControlBtn.frame = frame;
    
    //后退播放按钮
    frame.origin.x    = self.playControlBtn.right + space;
    frame.origin.y    = 12;
    frame.size.width  = 24;
    frame.size.height = 24;
    self.backBtn.frame = frame;
    
    //播放暂停按钮
    frame.origin.x    = 204;
    frame.origin.y    = 0;
    frame.size.width  = 48;
    frame.size.height = 48;
    self.playBtn.frame = frame;
    
    //前进按钮
    frame.origin.x    = 316;
    frame.origin.y    = 12;
    frame.size.width  = 24;
    frame.size.height = 24;
    self.forwardBtn.frame = frame;
    
    //加速按钮
    frame.origin.x    = 412;
    frame.origin.y    = 12;
    frame.size.width  = 24;
    frame.size.height = 24;
    self.speedBtn.frame = frame;
    
    //播放进度条progressView
    frame = CGRectMake(20, self.playBtn.bottom + 62, 416, 3);
    self.progressView.frame = frame;
    
    //slider
    frame = CGRectMake(20, self.playBtn.bottom + 45, 416, 30);
    self.slider.frame = frame;
    //当前播放时间
    frame = CGRectMake(20, self.progressView.bottom + 10, 40, 11);
    self.playTimeLbl.frame = frame;
    self.playTimeLbl.textAlignment = NSTextAlignmentLeft;
    self.playTimeLbl.text  = @"00:00";
    
    //剩余播放时间
    frame = CGRectMake(self.progressView.right - 40, self.progressView.bottom + 10, 40, 11);
    self.remainTimeLbl.frame = frame;
    self.remainTimeLbl.textAlignment = NSTextAlignmentRight;
    
    self.remainTimeLbl.text  = @"00:00";
}

/*
 *加载竖屏布局视图
 */
- (void)loadVerticalView {
    
    self.fontSizeBtn.hidden = NO;
    self.noteBtn.hidden = NO;
    self.albumListBtn.hidden = NO;
    self.writeNoteBtn.hidden = NO;
    
    CGRect frame = CGRectMake(80, 32 , 24, 24);
    
    //倍速播放按钮
    self.speedBtn.frame = frame;
    
    //字号大小按钮
    frame = CGRectMake(175, 32, 24, 24);
    self.fontSizeBtn.frame = frame;
    
    //后退播放按钮
    frame = CGRectMake(275, 32, 24, 24);
    self.backBtn.frame = frame;
    
    //播放暂停按钮
    frame = CGRectMake(360, 20, 48, 48);
    self.playBtn.frame = frame;
    
    //前进按钮
    frame = CGRectMake(472, 32, 25, 25);
    self.forwardBtn.frame = frame;
    
    //查看心得按钮
    frame = CGRectMake(571, 33, 22, 24);
    self.noteBtn.frame = frame;
    
    //写心得按钮
    frame = CGRectMake(664, 32, 24, 24);
    self.writeNoteBtn.frame = frame;
    
    //循环播放提示
    frame  = CGRectMake(80, 115, 24, 20);
    self.playControlBtn.frame = frame;
    
    //当前播放时间
    frame = CGRectMake(114, 117, 40, 16);
    self.playTimeLbl.frame = frame;
    self.playTimeLbl.textAlignment = NSTextAlignmentRight;
    self.playTimeLbl.text  = @"00:00";
    
    
    //播放进度条progressView
    frame = CGRectMake(166, 124, 437, 3);
    self.progressView.frame = frame;
    
    //slider
    frame = CGRectMake(166, 108, 437, 30);
    self.slider.frame = frame;
    
    
    //剩余播放时间
    frame = CGRectMake(self.progressView.right + 11, 117, 40, 16);
    self.remainTimeLbl.frame = frame;
    self.remainTimeLbl.textAlignment = NSTextAlignmentLeft;
    self.remainTimeLbl.text  = @"00:00";
    
    //列表按钮
    frame = CGRectMake(768 - 81 - 21, 114, 21, 21);
    self.albumListBtn.frame = frame;
    
    
}



#pragma mark - 通过过代码块获取回调方法
/*
 *通过代码块获取回调方法
 */

- (void)getControlEventCallBack:(YLYKPlayerControlEventBlock)controlEventBlock {
    self.controlEventBlock = controlEventBlock;
}

- (void)getSliderEventCallBack:(YLYKPlayerSliderEventBlock)sliderEventBlock {
    self.sliderEventBlock = sliderEventBlock;
}

#pragma mark - 播放控制台按钮事件

/*
 *循环播放按钮
 */
- (void)cyclePlay:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}

/*
 *后退播放按钮
 */
- (void)backPlay:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}

/*
 *播放暂停按钮
 */
- (void)playOrPause:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}

/*
 *前进播放按钮
 */
- (void)forwardPlay:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}

/*
 *加速播放按钮
 */
- (void)speedPlay:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}

/*
 *设置字号大小
 */
- (void)setFontSize:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}
/*
 *查看心得
 */
- (void)seeNote:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}
/*
 *专辑列表
 */
- (void)showAlbumList:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
}
/*
 *写心得
 */
- (void)writeNote:(UIButton *)sender {
    self.controlEventBlock(sender.tag);
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


#pragma mark - Getter Methods

/*
 *播放循环控制按钮
 */
- (UIButton *)playControlBtn {
    if (!_playControlBtn) {
        _playControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playControlBtn setImage:[UIImage imageNamed:@"night_icon_circle"] forState:UIControlStateNormal];
        [_playControlBtn addTarget:self action:@selector(cyclePlay:) forControlEvents:UIControlEventTouchUpInside];
        [_playControlBtn setTag:YLYKPlayerControlEventCycle];
    }
    return _playControlBtn;
}
/*
 *后退播放按钮
 */
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"night_icon_10sback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTag:YLYKPlayerControlEventBack];
    }
    return _backBtn;
}

/*
 *播放暂停按钮
 */
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"default_icon_pause"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn setTag:YLYKPlayerControlEventPlay];
        
    }
    return _playBtn;
}

/*
 *前进按钮
 */
- (UIButton *)forwardBtn {
    if (!_forwardBtn) {
        _forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forwardBtn setImage:[UIImage imageNamed:@"night_icon_10sforward"] forState:UIControlStateNormal];
        [_forwardBtn addTarget:self action:@selector(forwardPlay:) forControlEvents:UIControlEventTouchUpInside];
        [_forwardBtn setTag:YLYKPlayerControlEventForward];
    }
    return _forwardBtn;
}

/*
 *加速按钮
 */
- (UIButton *)speedBtn {
    if (!_speedBtn) {
        _speedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speedBtn setImage:[UIImage imageNamed:@"night_icon_speed_1"] forState:UIControlStateNormal];
        [_speedBtn addTarget:self action:@selector(speedPlay:) forControlEvents:UIControlEventTouchUpInside];
        _speedBtn.userInteractionEnabled = YES;
        [_speedBtn setTag:YLYKPlayerControlEventSpeed];
    }
    return _speedBtn;
}

/*
 *播放进度条progressView
 */
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.progressTintColor=[UIColor grayColor];
        //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
        _progressView.trackTintColor =[UIColor grayColor];
    };
    return _progressView;
}

/*
 *当前播放时间
 */
- (UILabel *)playTimeLbl{
    if (!_playTimeLbl) {
        _playTimeLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                               rect:CGRectZero
                                                               text:nil
                                                          textColor:KColor_9a9b9c
                                                           textFont:FONT11
                                                       textAligment:NSTextAlignmentRight
                                                      numberOfLines:1];
        _playTimeLbl.backgroundColor = [UIColor whiteColor];
    }
    return _playTimeLbl;
}

/*
 *剩余播放时间
 */
- (UILabel *)remainTimeLbl{
    if (!_remainTimeLbl) {
        _remainTimeLbl = [YLYKCreateBasicControlManager showLabInView:self
                                                                 rect:CGRectZero
                                                                 text:nil
                                                            textColor:KColor_9a9b9c
                                                             textFont:FONT11
                                                         textAligment:NSTextAlignmentRight
                                                        numberOfLines:1];
        _remainTimeLbl.backgroundColor = [UIColor whiteColor];
    }
    return _remainTimeLbl;
}


- (YLYKSlider *)slider {
    if (!_slider) {
        //左右轨的图片
        UIImage *stetchLeftTrack     = [UIImage imageNamed:@"slider_bg"];
        UIImage *stetchRightTrack = nil;
        stetchRightTrack    = [stetchRightTrack imageWithColor:[UIColor grayColor] size:CGSizeMake(768, 3)];
        //[UIImage imageNamed:@"play_toumiingmengceng"];
        //滑块图片
        UIImage *thumbImage          = [UIImage imageNamed:@"slider"];
        UIImage *thumbImageHighlight = [UIImage imageNamed:@"slider_seleted"];
        _slider = [[YLYKSlider alloc] initWithFrame:CGRectZero];
        _slider.maximumTrackTintColor = [UIColor lightGrayColor];
        _slider.backgroundColor = [UIColor clearColor];
        _slider.value = 0.0;
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        [_slider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_slider setThumbImage:thumbImageHighlight forState:UIControlStateHighlighted];
        [_slider setThumbImage:thumbImage forState:UIControlStateNormal];
        //滑块拖动时的事件
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventAllTouchEvents];
    }
    return _slider;
}

/*
 *设置字号大小
 */
- (UIButton *)fontSizeBtn {
    if (!_fontSizeBtn) {
        _fontSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fontSizeBtn setImage:[UIImage imageNamed:@"night_icon-fontsize_small"] forState:UIControlStateNormal];
        [_fontSizeBtn addTarget:self action:@selector(setFontSize:) forControlEvents:UIControlEventTouchUpInside];
        [_fontSizeBtn setTag:YLYKPlayerControlEventFontSize];
    }
    return _fontSizeBtn;
}

/*
 *查看心得
 */
- (UIButton *)noteBtn {
    if (!_noteBtn) {
        _noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noteBtn setImage:[UIImage imageNamed:@"night_icon_note"] forState:UIControlStateNormal];
        [_noteBtn addTarget:self action:@selector(seeNote:) forControlEvents:UIControlEventTouchUpInside];
        [_noteBtn setTag:YLYKPlayerControlEventNote];
    }
    return _noteBtn;
}

/*
 *专辑列表
 */
- (UIButton *)albumListBtn {
    if (!_albumListBtn) {
        _albumListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumListBtn setImage:[UIImage imageNamed:@"night_icon_playlist"] forState:UIControlStateNormal];
        [_albumListBtn addTarget:self action:@selector(showAlbumList:) forControlEvents:UIControlEventTouchUpInside];
        [_albumListBtn setTag:YLYKPlayerControlEventAlbumList];
    }
    return _albumListBtn;
}

/*
 *写心得
 */
- (UIButton *)writeNoteBtn {
    if (!_writeNoteBtn) {
        _writeNoteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_writeNoteBtn setImage:[UIImage imageNamed:@"ipad_default_write"] forState:UIControlStateNormal];
        [_writeNoteBtn addTarget:self action:@selector(writeNote:) forControlEvents:UIControlEventTouchUpInside];
        [_writeNoteBtn setTag:YLYKPlayerControlEventWriteNote];
    }
    return _writeNoteBtn;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
