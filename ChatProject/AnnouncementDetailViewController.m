//
//  AnnouncementDetailViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AnnouncementDetailViewController.h"

@interface AnnouncementDetailViewController ()

@end

@implementation AnnouncementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"公告"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, Header_Height + 15, SCREEN_WIDTH, 21)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = _titleStr;
    [self.view addSubview:titleLbl];
    // lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLbl.frame) + 10, SCREEN_WIDTH - 30, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.78 green:0.91 blue:0.76 alpha:1.00];
    [self.view addSubview:lineView];
    // contentTv
    UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, SCREEN_WIDTH - 20, SCREEN_HEIGHT - Header_Height - 20)];
    contentTv.font = [UIFont systemFontOfSize:15];
    contentTv.textColor = [UIColor darkGrayColor];
    contentTv.text = _contentStr;
    [self.view addSubview:contentTv];
}

@end
