//
//  LoginViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTabBarViewController.h"
#import "AppDelegate.h"
#import "RegisterFirstViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    // view
    UITextField *phoneTxt;
    UITextField *passwordTxt;
    UIButton *loginBtn;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBarTitle:@"登陆"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
}

#pragma mark - 自定义方法
-(void)initView{
    if (true) { // 判断账号是否存在
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 55) / 2, Header_Height + 50, 55, 55)];
        photoIv.image = [UIImage imageNamed:@"default_photo"];
        [self.view addSubview:photoIv];
        // phoneLbl
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(photoIv.frame) + 15, SCREEN_WIDTH, 21)];
        phoneLbl.textAlignment = NSTextAlignmentCenter;
        phoneLbl.text = @"12345678901";
        [self.view addSubview:phoneLbl];
        
        // passwordLbl
        UILabel *passwordLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneLbl.frame) + 20 + (50 - 21) / 2, 60, 21)];
        passwordLbl.text = @"密码";
        [self.view addSubview:passwordLbl];
        // passwordTxt
        passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLbl.frame), CGRectGetMaxY(phoneLbl.frame) + 20, SCREEN_WIDTH - 30, 50)];
        passwordTxt.delegate = self;
        passwordTxt.placeholder = @"请填写密码";
        [passwordTxt addTarget:self action:@selector(textFieldChangeEvent:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:passwordTxt];
    }else{
        // phoneLbl
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, Header_Height + 10 + (50 - 21) / 2, 60, 21)];
        phoneLbl.text = @"手机号";
        [self.view addSubview:phoneLbl];
        // phoneTxt
        phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), Header_Height + 10, SCREEN_WIDTH - CGRectGetMaxX(phoneLbl.frame) - 15, 50)];
        phoneTxt.delegate = self;
        phoneTxt.placeholder = @"请填写手机号";
        [phoneTxt addTarget:self action:@selector(textFieldChangeEvent:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:phoneTxt];
        // lineView1
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(phoneTxt.frame), SCREEN_WIDTH - 15, 0.5)];
        lineView1.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:lineView1];
        
        // passwordLbl
        UILabel *passwordLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView1.frame) + (50 - 21) / 2, 60, 21)];
        passwordLbl.text = @"密码";
        [self.view addSubview:passwordLbl];
        // passwordTxt
        passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(passwordLbl.frame), CGRectGetMaxY(lineView1.frame), SCREEN_WIDTH - 30, 50)];
        passwordTxt.delegate = self;
        passwordTxt.secureTextEntry = true;
        passwordTxt.placeholder = @"请填写密码";
        [passwordTxt addTarget:self action:@selector(textFieldChangeEvent:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:passwordTxt];
    }
    
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(passwordTxt.frame), SCREEN_WIDTH - 15, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
    
    // loginBtn
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView2.frame) + 30, SCREEN_WIDTH - 30, 45)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.enabled = false;
    loginBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
    [loginBtn addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    loginBtn.layer.masksToBounds = true;
    loginBtn.layer.cornerRadius = 6;
    
    // loginQuestionBtn
    UIButton *loginQuestionBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, CGRectGetMaxY(loginBtn.frame) + 20, 100, 21)];
    loginQuestionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginQuestionBtn setTitle:@"登录遇到问题？" forState:UIControlStateNormal];
    [loginQuestionBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.47 blue:0.66 alpha:1.00] forState:UIControlStateNormal];
    [loginQuestionBtn addTarget:self action:@selector(loginQuestionEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginQuestionBtn];
    
    // moreBtn
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 55) / 2, SCREEN_HEIGHT - 20 - 21, 55, 21)];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor colorWithRed:0.42 green:0.47 blue:0.66 alpha:1.00] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
}

- (void)loginEvent{
    [self loginRongCloud];
}

- (void)loginRongCloud{
    //登录融云服务器的token。需要您向您的服务器请求，您的服务器调用server api获取token
    //开发初始阶段，您可以先在融云后台API调试中获取
    NSString *token = @"aMarGu0LiLfZOWfn0arm3s932yYPkxRuRpimyIBV2104Bj3ase1ttkNwNp/MFg3t7Gmz+GPVuYNvQNxqZOi1OQ==";
    //连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:@"name1" portrait:@"http://pic.to8to.com/attch/day_160218/20160218_d968438a2434b62ba59dH7q5KEzTS6OH.png"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            CustomTabBarViewController *customTabBarVC = [[CustomTabBarViewController alloc] init];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = customTabBarVC;
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

-(void)loginQuestionEvent{
    
}

-(void)moreEvent{
    [Toolkit actionSheetViewSecond:self andTitle:nil andMsg:nil andCancelButtonTitle:@"取消" andOtherButtonTitle: [NSArray arrayWithObjects:@"注册", @"修改密码", nil] handler:^(int buttonIndex, UIAlertAction *alertView) {
        if (buttonIndex == 1) { // 注册
            RegisterFirstViewController *registerFirstVC = [[RegisterFirstViewController alloc] init];
            registerFirstVC.iFlagType = @"1";
            [self.navigationController pushViewController:registerFirstVC animated:true];
        }else if (buttonIndex == 2){ // 修改密码
            
        }
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldChangeEvent:(UITextField *)textField{
    if (true) {
        if (passwordTxt.text.length > 0) {
            loginBtn.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.10 alpha:1.00];
            loginBtn.enabled = true;
        }else{
            loginBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
            loginBtn.enabled = false;
        }
    }else{
        if (phoneTxt.text.length > 0 && passwordTxt.text.length > 0) {
            loginBtn.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.10 alpha:1.00];
            loginBtn.enabled = true;
        }else{
            loginBtn.backgroundColor = [UIColor colorWithRed:0.65 green:0.87 blue:0.65 alpha:1.00];
            loginBtn.enabled = false;
        }
    }
}

@end
