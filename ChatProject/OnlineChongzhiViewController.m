//
//  OnlineChongzhiViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OnlineChongzhiViewController.h"
#import "UIButton+WebCache.h"

@interface OnlineChongzhiViewController (){
    NSInteger isSelectSecond;
    UIView *menuView;
    UIScrollView *mScrollView;
    
    NSDictionary *dataDict;
}

@end

@implementation OnlineChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"在线充值"];
    [self addLeftButton:@"left"];
    
    isSelectSecond = 0;
    
    [self initData];
}

-(void)initData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getQrCode:"];
    [dataProvider getQrCode];
}

-(void)getQrCode:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        dataDict = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        
        [self initMenuView];
        [self initView];
    }
}

-(void)initMenuView{
    // menuView
    if (menuView != nil) {
        [menuView removeFromSuperview];
    }
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44 + 0.5)];
    [self.view addSubview:menuView];
    // titleBtn1
    UIButton *titleBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 0.5 * 2) / 3, menuView.frame.size.height - 0.5)];
    [titleBtn1 setTitleColor:isSelectSecond == 0 ? [UIColor darkGrayColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleBtn1 setTitle:dataDict[@"Namea"] forState:UIControlStateNormal];
    titleBtn1.titleLabel.font = [UIFont systemFontOfSize:16];
    titleBtn1.tag = 0;
    [titleBtn1 addTarget:self action:@selector(clickMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:titleBtn1];
    
    // lineView1
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn1.frame), 8, 0.5, menuView.frame.size.height - 0.5 - 8 * 2)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:lineView1];
    
    // titleBtn2
    UIButton *titleBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 0, (SCREEN_WIDTH - 0.5 * 2) / 3, menuView.frame.size.height - 0.5)];
    [titleBtn2 setTitleColor:isSelectSecond == 1 ? [UIColor darkGrayColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleBtn2 setTitle:dataDict[@"Nameb"] forState:UIControlStateNormal];
    titleBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
    titleBtn2.tag = 1;
    [titleBtn2 addTarget:self action:@selector(clickMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:titleBtn2];
    
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn2.frame), 8, 0.5, menuView.frame.size.height - 0.5 - 8 * 2)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:lineView2];
    
    // titleBtn3
    UIButton *titleBtn3 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame), 0, (SCREEN_WIDTH - 0.5 * 2) / 3, menuView.frame.size.height - 0.5)];
    [titleBtn3 setTitleColor:isSelectSecond == 2 ? [UIColor darkGrayColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleBtn3 setTitle:dataDict[@"Namec"] forState:UIControlStateNormal];
    titleBtn3.titleLabel.font = [UIFont systemFontOfSize:16];
    titleBtn3.tag = 2;
    [titleBtn3 addTarget:self action:@selector(clickMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:titleBtn3];
    
    // lineView3
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:lineView3];
}

-(void)clickMenuEvent:(UIButton *)sender{
    isSelectSecond = sender.tag;
    
    [self initMenuView];
    [self initView];
}

-(void)initView{
    // mScrollView
    if (mScrollView != nil) {
        [mScrollView removeFromSuperview];
    }
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Header_Height + 44 + 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 44 - 0.5)];
    mScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
    [self.view addSubview:mScrollView];
    // zhifubaoBtn
    UIButton *zhifubaoBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, 10, 200, 200)];
    zhifubaoBtn.adjustsImageWhenHighlighted = false;
    UILongPressGestureRecognizer *longGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zhifubaoEvent)];
    [zhifubaoBtn addGestureRecognizer:longGesture1];
    [mScrollView addSubview:zhifubaoBtn];
    // titleLbl1
    UILabel *titleLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zhifubaoBtn.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl1.textAlignment = NSTextAlignmentCenter;
    if (isSelectSecond == 0) {
        titleLbl1.text = @"支付宝二维码一";
        [zhifubaoBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picd"]]]  forState:UIControlStateNormal];
    }else if (isSelectSecond == 1){
        titleLbl1.text = @"支付宝二维码二";
        [zhifubaoBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picf"]]]  forState:UIControlStateNormal];
    }else{
        titleLbl1.text = @"支付宝二维码三";
        [zhifubaoBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Pich"]]]  forState:UIControlStateNormal];
    }
    [mScrollView addSubview:titleLbl1];
    // titleLbl2
    UILabel *titleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl1.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl2.textAlignment = NSTextAlignmentCenter;
    titleLbl2.text = @"长按二维码转入支付宝支付";
    [mScrollView addSubview:titleLbl2];
    
    // weixinBtn
    UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, CGRectGetMaxY(titleLbl2.frame) + 20, 200, 200)];
    weixinBtn.adjustsImageWhenHighlighted = false;
    UILongPressGestureRecognizer *longGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(weixinEvent)];
    [weixinBtn addGestureRecognizer:longGesture2];
    [mScrollView addSubview:weixinBtn];
    // titleLbl3
    UILabel *titleLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl3.textAlignment = NSTextAlignmentCenter;
    if (isSelectSecond == 0) {
        titleLbl3.text = @"微信二维码一";
        [weixinBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picc"]]]  forState:UIControlStateNormal];
    }else if (isSelectSecond == 1){
        titleLbl3.text = @"微信二维码二";
        [weixinBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Pice"]]]  forState:UIControlStateNormal];
    }else{
        titleLbl3.text = @"微信二维码三";
        [weixinBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picg"]]]  forState:UIControlStateNormal];
    }
    [mScrollView addSubview:titleLbl3];
    // titleLbl4
    UILabel *titleLbl4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl3.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl4.textAlignment = NSTextAlignmentCenter;
    titleLbl4.text = @"长按二维码转入微信支付";
    [mScrollView addSubview:titleLbl4];
}

-(void)zhifubaoEvent{
    NSString *imageStr;
    if (isSelectSecond == 0){
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picd"]];
    }else if (isSelectSecond == 1){
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picf"]];
    }else{
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Pich"]];
    }
    UIImage *tempImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
    [self readQRCodeFromImage:tempImg myQRCode:^(NSString *qrString, NSError *error) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:qrString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }];
}

-(void)weixinEvent{
    NSString *imageStr;
    if (isSelectSecond == 0){
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picc"]];
    }else if (isSelectSecond == 1){
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Pice"]];
    }else{
        imageStr = [NSString stringWithFormat:@"%@%@",Kimg_path,dataDict[@"Picg"]];
    }
    UIImage *tempImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageStr]]];
    [self readQRCodeFromImage:tempImg myQRCode:^(NSString *qrString, NSError *error) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:qrString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }];
}

/**
 *  从照片中直接识别二维码
 *  @param qrCodeImage 带二维码的图片
 *  @param myQRCode    二维码包含的内容
 */
- (void)readQRCodeFromImage:(UIImage *)qrCodeImage myQRCode:(void(^)(NSString *qrString,NSError *error))myQRCode;{
    
    UIImage * srcImage = qrCodeImage;
    if (nil == srcImage) {
        myQRCode(nil,[NSError errorWithDomain:@"未传入图片" code:0 userInfo:nil]);
        return;
    }
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    if (features.count) {
        CIQRCodeFeature *feature = [features firstObject];
        
        NSString *result = feature.messageString;
        
        myQRCode(result,nil);
    }
    else{
        myQRCode(nil,[NSError errorWithDomain:@"未能识别出二维码" code:0 userInfo:nil]);
        [Toolkit showErrorWithStatus:@"未能识别出二维码"];
    }
    
}

@end
