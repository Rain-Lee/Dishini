//
//  SignViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SignViewController.h"

@interface SignViewController ()<UITextViewDelegate>{
    UITextView *contentTv;
    UILabel *placeholderLbl;
}

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setNavtitle:@"个性签名"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"完成"];
    
    [self initView];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(getSign:)]) {
        [self.delegate getSign:contentTv.text];
    }
    [self.navigationController popViewControllerAnimated:true];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [contentTv resignFirstResponder];
}

-(void)initView{
    // cusView
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 20, SCREEN_WIDTH, SCREEN_WIDTH * 0.4)];
    cusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cusView];
    // contentTv
    contentTv = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, SCREEN_WIDTH * 0.4)];
    contentTv.delegate = self;
    contentTv.text = _signStr;
    contentTv.font = [UIFont systemFontOfSize:15];
    contentTv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [cusView addSubview:contentTv];
    // placeholderLbl
    placeholderLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 15)];
    placeholderLbl.text = @"请输入个性签名";
    placeholderLbl.textColor = [UIColor grayColor];
    placeholderLbl.font = [UIFont systemFontOfSize:15];
    if (_signStr == nil || [_signStr isEqual:@""]) {
        placeholderLbl.hidden = false;
    }else{
        placeholderLbl.hidden = true;
    }
    [contentTv addSubview:placeholderLbl];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([contentTv.text isEqual:@""]) {
        placeholderLbl.hidden = false;
    }else{
        placeholderLbl.hidden = true;
    }
}

@end
