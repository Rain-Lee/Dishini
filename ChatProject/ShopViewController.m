//
//  ShopViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ShopViewController.h"

@interface ShopViewController ()<UIWebViewDelegate>

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"商城"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_shopUrl]]];
    [self.view addSubview:webView];
}

@end
