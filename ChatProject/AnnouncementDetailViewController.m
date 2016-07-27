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
    
    [self setNavtitle:_titleStr];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    UITextView *contentTv = [[UITextView alloc] initWithFrame:CGRectMake(10, Header_Height + 20, SCREEN_WIDTH - 20, SCREEN_HEIGHT - Header_Height - 20)];
    contentTv.font = [UIFont systemFontOfSize:15];
    contentTv.textColor = [UIColor darkGrayColor];
    contentTv.text = _contentStr;
    [self.view addSubview:contentTv];
}

@end
