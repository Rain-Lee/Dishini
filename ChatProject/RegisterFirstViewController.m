//
//  RegisterFirstViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RegisterFirstViewController.h"
#import "RegisterSecondViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterFirstViewController ()<UITextFieldDelegate>{
    // view
    UITextField *phoneTxt;
    UIButton *nextBtn;
}

@end

@implementation RegisterFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"填写手机号"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTxt resignFirstResponder];
}

#pragma mark - 自定义方法
-(void)initView{
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, Header_Height + 20, SCREEN_WIDTH, 21)];
    titleLbl.text = [self.iFlagType isEqual:@"1"] ? @"请输入你的手机号" : @"通过短信验证码登陆";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:21];
    [self.view addSubview:titleLbl];
    // phoneTxt
    phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLbl.frame) + 20, SCREEN_WIDTH - 30, 45)];
    phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    phoneTxt.delegate = self;
    phoneTxt.placeholder = @"请填写手机号码";
    phoneTxt.borderStyle = UITextBorderStyleNone;
    [phoneTxt addTarget:self action:@selector(textFieldChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:phoneTxt];
    
    // lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    // nextBtn
    nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTxt.frame) + 20, SCREEN_WIDTH - 30, 45)];
    nextBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.enabled = false;
    [nextBtn addTarget:self action:@selector(nextEvent) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.masksToBounds = true;
    nextBtn.layer.cornerRadius = 6;
    [self.view addSubview:nextBtn];
}

-(void)nextEvent{
    [Toolkit showWithStatus:@"加载中..."];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneTxt.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            RegisterSecondViewController *registerSecondVC = [[RegisterSecondViewController alloc] init];
            registerSecondVC.phone = phoneTxt.text;
            registerSecondVC.iFlagType = self.iFlagType;
            [self.navigationController pushViewController:registerSecondVC animated:true];
        }else{
            phoneTxt.text = @"";
            [Toolkit alertView:self andTitle:@"提示" andMsg:error.userInfo[@"getVerificationCode"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        }
    }];
}

-(void)textFieldChangeEvent:(UITextField *)textField{
    if ([phoneTxt.text isEqual:@""]) {
        nextBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
        nextBtn.enabled = false;
    }else{
        nextBtn.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.10 alpha:1.00];
        nextBtn.enabled = true;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
