//
//  OnlineChongzhiViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/7.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "OnlineChongzhiViewController.h"

@interface OnlineChongzhiViewController (){
    BOOL isSelectSecond;
    UIView *menuView;
    UIScrollView *mScrollView;
}

@end

@implementation OnlineChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"在线充值"];
    [self addLeftButton:@"left"];
    
    isSelectSecond = false;
    
    [self initMenuView];
    [self initView];
}

-(void)initMenuView{
    // menuView
    if (menuView != nil) {
        [menuView removeFromSuperview];
    }
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 44 + 0.5)];
    [self.view addSubview:menuView];
    // titleBtn1
    UIButton *titleBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 0.5) / 2, menuView.frame.size.height - 0.5)];
    [titleBtn1 setTitleColor:isSelectSecond ? [UIColor lightGrayColor] : [UIColor blackColor] forState:UIControlStateNormal];
    [titleBtn1 setTitle:@"给米老鼠充值" forState:UIControlStateNormal];
    titleBtn1.tag = 0;
    [titleBtn1 addTarget:self action:@selector(clickMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:titleBtn1];
    
    // lineView1
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn1.frame), 8, 0.5, menuView.frame.size.height - 0.5 - 8 * 2)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:lineView1];
    
    // titleBtn2
    UIButton *titleBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView1.frame), 0, (SCREEN_WIDTH - 0.5) / 2, menuView.frame.size.height - 0.5)];
    [titleBtn2 setTitleColor:isSelectSecond ? [UIColor blackColor] : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleBtn2 setTitle:@"给唐老鸭充值" forState:UIControlStateNormal];
    titleBtn2.tag = 1;
    [titleBtn2 addTarget:self action:@selector(clickMenuEvent:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:titleBtn2];
    
    // lineView2
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 0.5)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [menuView addSubview:lineView2];
}

-(void)clickMenuEvent:(UIButton *)sender{
    isSelectSecond = sender.tag == 1 ? true : false;
    
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
    [zhifubaoBtn setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    UILongPressGestureRecognizer *longGesture1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zhifubaoEvent)];
    [zhifubaoBtn addGestureRecognizer:longGesture1];
    [mScrollView addSubview:zhifubaoBtn];
    // titleLbl1
    UILabel *titleLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zhifubaoBtn.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl1.textAlignment = NSTextAlignmentCenter;
    titleLbl1.text = isSelectSecond ? @"米老鼠支付宝账号" : @"唐老鸭";
    [mScrollView addSubview:titleLbl1];
    // titleLbl2
    UILabel *titleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl1.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl2.textAlignment = NSTextAlignmentCenter;
    titleLbl2.text = @"长按二维码转入支付宝支付";
    [mScrollView addSubview:titleLbl2];
    
    // weixinBtn
    UIButton *weixinBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, CGRectGetMaxY(titleLbl2.frame) + 20, 200, 200)];
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    weixinBtn.adjustsImageWhenHighlighted = false;
    UILongPressGestureRecognizer *longGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(weixinEvent)];
    [weixinBtn addGestureRecognizer:longGesture2];
    [mScrollView addSubview:weixinBtn];
    // titleLbl3
    UILabel *titleLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weixinBtn.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl3.textAlignment = NSTextAlignmentCenter;
    titleLbl3.text = @"米老鼠微信账号";
    [mScrollView addSubview:titleLbl3];
    // titleLbl4
    UILabel *titleLbl4 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl3.frame) + 10, SCREEN_WIDTH, 21)];
    titleLbl4.textAlignment = NSTextAlignmentCenter;
    titleLbl4.text = @"长按二维码转入微信支付";
    [mScrollView addSubview:titleLbl4];
}

-(void)zhifubaoEvent{
    [self readQRCodeFromImage:[UIImage imageNamed:@"erweima"] myQRCode:^(NSString *qrString, NSError *error) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:qrString];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }];
}

-(void)weixinEvent{
    [self readQRCodeFromImage:[UIImage imageNamed:@"erweima"] myQRCode:^(NSString *qrString, NSError *error) {
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
        return;
    }
    
}

@end
