

#import <UIKit/UIKit.h>

@interface CBLProgressHUD : UIView

@property (nonatomic, readonly, strong) UIView *centerLoadingHUD;

+ (CBLProgressHUD *)showLoadingHUDInView:(UIView *)superView;

+ (CBLProgressHUD *)showLoadingHUDInView:(UIView *)superView hideContent:(BOOL)hide;


+ (CBLProgressHUD *)hideLoadingHUDInView:(UIView *)superView;

+ (NSArray *)hideAllLoadingHUDInView:(UIView *)superView;

/*!
 @method
 @abstract 显示一个文本提示框，持续1s
 @discussion 如果希望提示框消失之后再执行跳转界面，可以使用下面的方法showTextHUDWithText:onView:afterDelay:completion:。注：当显示HUD时，该view不能接受手势响应，但是naviBar和tabBar可以
 @param text 提示的文字
 @param view HUD显示在此view上，HUD是此view的子视图
 @result 返回空
 */
+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view;


+ (void)showTextHUDInWindowWithText:(NSString *)text;



/*!
 @method
 @abstract 显示一个文本提示框，并在消失后执行completionBlock
 @discussion
 @param text 文字 (这里把这个方法需要的参数列出来)
 @param view HUD显示在此view上，HUD是此view的子视图
 @param second HUD显示持续的时间，单位是秒(s)
 @param completionBlock HUD消失后执行的Block
 @result 返回空
 */
+ (void)showTextHUDWithText:(NSString *)text inView:(UIView *)view afterDelay:(NSInteger)second completion:(void (^)())completionBlock;

@end
