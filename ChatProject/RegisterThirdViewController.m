//
//  RegisterThirdViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/24.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RegisterThirdViewController.h"

@interface RegisterThirdViewController ()<UITextFieldDelegate>{
    UITextField *passwordTxt;
    UITextField *rePasswordTxt;
    UIButton *commentBtn;
}

@end

@implementation RegisterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarTitle:@"填写密码"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"完成"];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.00];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [passwordTxt resignFirstResponder];
    [rePasswordTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    
}

-(void)initView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 12, SCREEN_WIDTH, 45 * 3 + 15 * 3 + 1.5)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    // phoneLbl
    UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + (45 - 21) / 2, 100, 21)];
    phoneLbl.text = @"手机号";
    phoneLbl.textColor = [UIColor grayColor];
    [topView addSubview:phoneLbl];
    // phoneTxt
    UITextField *phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    phoneTxt.text = self.phone;
    phoneTxt.enabled = false;
    phoneTxt.textColor = [UIColor grayColor];
    [topView addSubview:phoneTxt];
    // lineView1
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:lineView1];
    
    // passwordLbl
    UILabel *passwordLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView1.frame) + 15 + (45 - 21) / 2, 100, 21)];
    passwordLbl.text = @"密码";
    [topView addSubview:passwordLbl];
    // passwordTxt
    passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(lineView1.frame) + 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    passwordTxt.delegate = self;
    passwordTxt.secureTextEntry = true;
    passwordTxt.placeholder = @"请设置密码";
    [topView addSubview:passwordTxt];
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(passwordTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:lineView2];
    
    // rePasswordLbl
    UILabel *rePasswordLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView2.frame) + 15 + (45 - 21) / 2, 100, 21)];
    rePasswordLbl.text = @"确认密码";
    [topView addSubview:rePasswordLbl];
    // rePasswordTxt
    rePasswordTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(lineView2.frame) + 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    rePasswordTxt.delegate = self;
    rePasswordTxt.secureTextEntry = true;
    rePasswordTxt.placeholder = @"请再次填入";
    [topView addSubview:rePasswordTxt];
    // lineView3
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(rePasswordTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:lineView3];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
