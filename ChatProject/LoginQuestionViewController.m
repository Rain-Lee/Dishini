//
//  LoginQuestionViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/24.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LoginQuestionViewController.h"
#import "RegisterFirstViewController.h"

@interface LoginQuestionViewController ()

@end

@implementation LoginQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"登陆遇到问题"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, Header_Height + 125, SCREEN_WIDTH - 40, 55)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"你可以通过手机号+短信验证码登陆迪士尼"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.02 green:0.75 blue:0.00 alpha:1.00] range:NSMakeRange(5, 9)];
    titleLbl.attributedText = str;
    titleLbl.numberOfLines = 0;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:titleLbl];
    
    // OkBtn
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLbl.frame) + 20, SCREEN_WIDTH - 30, 45)];
    commentBtn.backgroundColor = [UIColor colorWithRed:0.02 green:0.75 blue:0.00 alpha:1.00];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn setTitle:@"用短信验证码登陆" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentEvent) forControlEvents:UIControlEventTouchUpInside];
    commentBtn.layer.masksToBounds = true;
    commentBtn.layer.cornerRadius = 6;
    [self.view addSubview:commentBtn];
}

-(void)commentEvent{
    RegisterFirstViewController * registerFirstVC = [[RegisterFirstViewController alloc] init];
    registerFirstVC.iFlagType = @"2";
    [self.navigationController pushViewController:registerFirstVC animated:true];
}

@end
