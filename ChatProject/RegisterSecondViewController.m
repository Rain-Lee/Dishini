//
//  RegisterSecondViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/24.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RegisterSecondViewController.h"
#import "ChatProject-swift.h"
#import "RegisterThirdViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface RegisterSecondViewController ()<UITextFieldDelegate>{
    // view
    UITextField *vericationTxt;
    UIButton *commentBtn;
}

@end

@implementation RegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"填写验证码"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [vericationTxt resignFirstResponder];
}

-(void)initView{
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, Header_Height + 25, SCREEN_WIDTH - 40, 55)];
    titleLbl.text = @"短信验证码已发送，请填写验证码";
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:titleLbl];
    
    // phoneLbl
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLbl.frame) + 15 + (45 - 21) / 2, 100, 21)];
    phoneLbl.text = @"手机号";
    phoneLbl.textColor = [UIColor grayColor];
    [self.view addSubview:phoneLbl];
    // phoneTxt
    UITextField *phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(titleLbl.frame) + 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    phoneTxt.text = self.phone;
    phoneTxt.enabled = false;
    phoneTxt.textColor = [UIColor grayColor];
    [self.view addSubview:phoneTxt];
    // lineView1
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView1];
    
    // vericationLbl
    UILabel *vericationLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView1.frame) + 15 + (45 - 21) / 2, 100, 21)];
    vericationLbl.text = @"验证码";
    [self.view addSubview:vericationLbl];
    // vericationTxt
    vericationTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(lineView1.frame) + 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    vericationTxt.delegate = self;
    vericationTxt.keyboardType = UIKeyboardTypeNumberPad;
    vericationTxt.placeholder = @"请输入验证码";
    [vericationTxt addTarget:self action:@selector(vericationEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:vericationTxt];
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(vericationTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    
    // commentBtn
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView2.frame) + 20, SCREEN_WIDTH - 30, 45)];
    commentBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
    [commentBtn setTitle:@"提交" forState:UIControlStateNormal];
    commentBtn.enabled = false;
    [commentBtn addTarget:self action:@selector(commentEvent) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.layer.masksToBounds = true;
    commentBtn.layer.cornerRadius = 6;
    [self.view addSubview:commentBtn];
    
    // timeBtn
    Timer *timeBtn = [[Timer alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160) / 2, CGRectGetMaxY(commentBtn.frame) + 15, 160, 21)];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:timeBtn];
}

-(void)commentEvent{
    [SMSSDK commitVerificationCode:vericationTxt.text phoneNumber:_phone zone:@"86" result:^(NSError *error) {
        if (!error) {
            if ([self.iFlagType isEqual:@"1"]) {
                RegisterThirdViewController *registerThirdVC = [[RegisterThirdViewController alloc] init];
                registerThirdVC.phone = self.phone;
                [self.navigationController pushViewController:registerThirdVC animated:true];
            }else{
                // 通过短信验证码登陆
            }
        }else{
            NSLog(@"%@",error);
            [Toolkit alertView:self andTitle:@"提示" andMsg:error.userInfo[@"commitVerificationCode"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        }
    }];
}

-(void)vericationEvent:(UITextField *)textField{
    if ([vericationTxt.text isEqual:@""]) {
        commentBtn.enabled = false;
        commentBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
    }else{
        commentBtn.enabled = true;
        commentBtn.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.10 alpha:1.00];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
