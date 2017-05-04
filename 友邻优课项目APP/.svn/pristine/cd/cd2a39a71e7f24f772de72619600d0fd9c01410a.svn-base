

#import "CBLProgressHUD.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

#pragma mark - CBLLoadingHUD

@interface CBLLoadingHUD : UIView

@property (nonatomic, strong) UIImageView *wheelImageView;

@property (nonatomic, strong) UIImageView *lineImageView;

@property (nonatomic, strong) UILabel *loadingLabel;

- (void)startLoading;

- (void)stopLoading;

@end

@implementation CBLLoadingHUD
{
    __weak CABasicAnimation *_rotationAnimation;
}

- (void)startLoading
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _rotationAnimation = rotationAnimation;
    _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    _rotationAnimation.duration = 1.0;
    _rotationAnimation.cumulative = YES;
    _rotationAnimation.repeatCount = HUGE_VAL;
    [self.wheelImageView.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopLoading
{
    [self.wheelImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

- (UIImageView *)wheelImageView
{
    if (!_wheelImageView) {
        _wheelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle"]];
    }
    return _wheelImageView;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    }
    return _lineImageView;
}

- (UILabel *)loadingLabel
{
    if (!_loadingLabel) {
        _loadingLabel = [[UILabel alloc] init];
        _loadingLabel.textColor = [UIColor whiteColor];
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
//        _loadingLabel.text = NSLocalizedString(@"loading", nil);
        _loadingLabel.font = [UIFont systemFontOfSize:12];
    }
    return _loadingLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.wheelImageView];
        [self addSubview:self.lineImageView];
        [self addSubview:self.loadingLabel];
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.69];
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.wheelImageView.frame = CGRectMake(width*(30.0/84.0), height*(11.0/84.0), width*(22.0/84.0), width*(22.0/84.0));
    
//    self.lineImageView.frame = CGRectMake(width*(16.0/84.0), self.wheelImageView.frame.origin.y+self.wheelImageView.frame.size.height+4, width*(50.0/84.0), 2);
    self.lineImageView.frame = CGRectMake(width*(22.0/84.0), height*(11.0/84.0), width*(41.0/84.0),  width*(41.0/84.0));
    self.lineImageView.contentMode = UIViewContentModeCenter;
    
    CGFloat labelHeight = height * (14.0/84.0);
    
    self.loadingLabel.frame = CGRectMake(0, height-height*(9.0/84.0)-labelHeight, width, labelHeight);
}

@end

#pragma mark - CBLProgressHUD

@interface CBLProgressHUD ()

@property (nonatomic, strong) CBLLoadingHUD *centerLoadingHUD;

@end

@implementation CBLProgressHUD

- (CBLLoadingHUD *)centerLoadingHUD
{
    if (!_centerLoadingHUD) {
        _centerLoadingHUD = [[CBLLoadingHUD alloc] init];
        _centerLoadingHUD.frame = CGRectMake(0, 0, 100, 100);
        [self addSubview:_centerLoadingHUD];
    }
    return _centerLoadingHUD;
}

- (void)layoutSubviews
{
    self.centerLoadingHUD.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview.superview) {
        self.frame = newSuperview.superview.bounds;
    }else{
        self.frame = newSuperview.bounds;
    }
    [(CBLLoadingHUD *)self.centerLoadingHUD startLoading];
}

- (void)didMoveToWindow
{
    if (self.superview.frame.origin.y != 0 || self.superview.bounds.size.height<[UIScreen mainScreen].bounds.size.height) {
        self.frame = CGRectMake(0, -64, self.superview.frame.size.width, self.superview.frame.size.height+64);
    }else{
        self.frame = self.superview.bounds;
    }
    self.superview.userInteractionEnabled = NO;
}

+ (CBLProgressHUD *)showLoadingHUDInView:(UIView *)superView
{
    return [self showLoadingHUDInView:superView hideContent:NO];
}

+ (CBLProgressHUD *)showLoadingHUDInView:(UIView *)superView hideContent:(BOOL)hide
{
    CBLProgressHUD *hud = [[CBLProgressHUD alloc] init];
    hud.backgroundColor = hide?[UIColor whiteColor]:[UIColor clearColor];
    [superView addSubview:hud];
    [superView bringSubviewToFront:hud];
    return hud;
}

+ (NSArray *)allHUDInView:(UIView *)superView
{
    NSMutableArray *arrM = [NSMutableArray array];
    
    [superView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CBLProgressHUD class]]) {
            [arrM addObject:obj];
        }
    }];
    return arrM;
}

+ (CBLProgressHUD *)hideLoadingHUDInView:(UIView *)superView
{
    NSArray *huds = [self allHUDInView:superView];
    CBLProgressHUD *hud = [huds firstObject];//找到最早添加的
    hud.superview.userInteractionEnabled = YES;
    [hud removeFromSuperview];
    [(CBLLoadingHUD *)hud.centerLoadingHUD stopLoading];
    return hud;
}

+ (NSArray *)hideAllLoadingHUDInView:(UIView *)superView
{
    NSArray *huds = [self allHUDInView:superView];
    [huds enumerateObjectsUsingBlock:^(CBLProgressHUD * _Nonnull hud, NSUInteger idx, BOOL * _Nonnull stop) {
        hud.superview.userInteractionEnabled = YES;
        [hud removeFromSuperview];
        [(CBLLoadingHUD *)hud.centerLoadingHUD stopLoading];
    }];
    return huds;
}

+ (void)showTextHUDInWindowWithText:(NSString *)text
{
    [CBLProgressHUD showTextHUDWithText:text inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view
{
    [self showTextHUDWithText:text inView:view afterDelay:1.5 completion:nil];
}

+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSInteger)second completion:(void (^)())completionBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;

    hud.labelText = text;
    hud.yOffset = -64.0f;
    hud.completionBlock = ^{
        if (completionBlock) {
            completionBlock();
        }
    };
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:second];
}

@end

