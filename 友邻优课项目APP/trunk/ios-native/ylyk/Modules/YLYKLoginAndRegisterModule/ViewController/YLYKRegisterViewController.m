//
//  RegisterViewController.m
//  ylyk
//
//  Created by 友邻优课 on 2017/4/10.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKRegisterViewController.h"

@interface YLYKRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *captchaField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (assign, nonatomic) NSInteger leftTime;
@property (strong, nonatomic) UILabel * retry;
@property (strong, nonatomic) UIView * leftTimeView;
@property (weak, nonatomic) IBOutlet UIButton *shutBtn;
@property (weak, nonatomic) IBOutlet UILabel *captchaBtn;

@end

@implementation YLYKRegisterViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.captchaBtn.layer setMasksToBounds:YES];
    [self.captchaBtn.layer setCornerRadius:12.5]; //设置矩形四个圆角半径
    [self.captchaBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 0.78, 0.78, 0.78, 1 });
    [self.captchaBtn.layer setBorderColor:colorref1];
    self.captchaBtn.userInteractionEnabled = YES;
    [self.loginBtn.layer setMasksToBounds:YES];
    [self.loginBtn.layer setCornerRadius:22.0]; //设置矩形四个圆角半径
    [self.loginBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
    [self.loginBtn.layer setBorderColor:colorref];
    [self.loginBtn setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.captchaField resignFirstResponder];
    [self.phoneNumberField resignFirstResponder];
}

- (IBAction)dissmissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
