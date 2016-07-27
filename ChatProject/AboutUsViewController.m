//
//  AboutUsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController (){
    // view
    // data
    NSString *aboutUsStr;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"关于我们"];
    [self addLeftButton:@"left"];
    
    [self initData];
}

-(void)initData{
    [Toolkit showWithStatus:@"加载中"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"aboutUsCallBack:"];
    [dataProvider aboutUs];
}

-(void)aboutUsCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        aboutUsStr = dict[@"data"][@"AboutUs"];
        [self initView];
    }
}

-(void)initView{
    UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(10, Header_Height + 20, SCREEN_WIDTH - 20, SCREEN_HEIGHT - Header_Height - 20)];
    contentTv.font = [UIFont systemFontOfSize:15];
    contentTv.textColor = [UIColor darkGrayColor];
    contentTv.text = aboutUsStr;
    [self.view addSubview:contentTv];
}

@end
