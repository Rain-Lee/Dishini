//
//  MyErweimaViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/4.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MyErweimaViewController.h"
#import "QRCodeGenerator.h"

@interface MyErweimaViewController ()

@end

@implementation MyErweimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"我的二维码"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    UIImageView * img_erweima=[[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, (SCREEN_HEIGHT - 200) / 2, 200, 200)];
    //    [img_erweima sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"erweimaimg.png"]];
    img_erweima.image=[QRCodeGenerator qrImageForString:[Toolkit getStringValueByKey:@"Id"] imageSize:img_erweima.bounds.size.width];
    [self.view addSubview:img_erweima];
}

@end
