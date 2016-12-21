//
//  RegisterThirdViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/24.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RegisterThirdViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
#import "CustomTabBarViewController.h"

@interface RegisterThirdViewController ()<UITextFieldDelegate>{
    UITextField *passwordTxt;
    UITextField *rePasswordTxt;
    UITextField *nickNameTxt;
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
    [self.view endEditing:true];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([passwordTxt.text isEqual:@""] || [rePasswordTxt.text isEqual:@""] || [nickNameTxt.text isEqual:@""]){
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"请完善信息" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        return;
    }
    if (![passwordTxt.text isEqual:rePasswordTxt.text]) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"两次密码输入不一致" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        return;
    }
    
    [Toolkit showWithStatus:@"请稍等..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"saveCallBack:"];
    [dataProvider registerUser:_phone andPassword:passwordTxt.text andName:nickNameTxt.text];
}

-(void)saveCallBack:(id)dict{// 18810375184
    if ([dict[@"code"] intValue] == 200) {
        @try {
            dispatch_async(dispatch_get_main_queue(), ^{
//                DataProvider *dataProvider2 = [[DataProvider alloc] init];
//                [dataProvider2 setDelegateObject:self setBackFunctionName:@"editUserInfoCallBack:"];
//                [dataProvider2 editUserInfo:dict[@"data"] andNickName:[Toolkit phoneEncryption:_phone] andSex:@"0" andHomeAreaId:@"中国" andDescription:@""];
                DataProvider *dataProvider3 = [[DataProvider alloc] init];
                [dataProvider3 setDelegateObject:self setBackFunctionName:@"loginCallBack:"];
                [dataProvider3 login:_phone andPassword:passwordTxt.text];
            });
        } @catch (NSException *exception) {
            [SVProgressHUD dismiss];
        } @finally {
            
        }
    }else{
        [SVProgressHUD showErrorWithStatus:dict[@"data"]];
    }
}

-(void)editUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSLog(@"%@",dict);
        dispatch_async(dispatch_get_main_queue(), ^{
            DataProvider *dataProvider3 = [[DataProvider alloc] init];
            [dataProvider3 setDelegateObject:self setBackFunctionName:@"loginCallBack:"];
            [dataProvider3 login:_phone andPassword:passwordTxt.text];
        });
    }else{
        [SVProgressHUD showErrorWithStatus:dict[@"error"]];
    }
}

-(void)loginCallBack:(id)dict{
    [SVProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginCallBackSetting" object:nil userInfo:dict];
}

-(void)initView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 12, SCREEN_WIDTH, (15 + 45 + 0.5) * 4)];
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
    
    // nickNameLbl
    UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView3.frame) + 15 + (45 - 21) / 2, 100, 21)];
    nickNameLbl.text = @"昵称";
    [topView addSubview:nickNameLbl];
    // nickNameTxt
    nickNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), CGRectGetMaxY(lineView3.frame) + 15, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame), 45)];
    nickNameTxt.delegate = self;
    nickNameTxt.placeholder = @"请输入昵称";
    [topView addSubview:nickNameTxt];
    // lineView4
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nickNameTxt.frame), SCREEN_WIDTH, 0.5)];
    lineView4.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:lineView4];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
