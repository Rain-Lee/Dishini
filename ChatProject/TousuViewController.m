//
//  TousuViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/13.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "TousuViewController.h"

@interface TousuViewController ()

@property (nonatomic, strong) UITextView *contentTv;

@end

@implementation TousuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"投诉"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)initView{
    [self.view addSubview:self.contentTv];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([self.contentTv.text isEqual:@""]) {
        [Toolkit showErrorWithStatus:@"内容不能为空"];
        return;
    }
    
    [Toolkit showWithStatus:@"保存中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"saveDataCallBack:"];
    [dataProvider reportUser:[Toolkit getUserID] andTeamid:_groupId andContent:self.contentTv.text];
}

-(void)saveDataCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showSuccessWithStatus:@"投诉成功"];
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [Toolkit showErrorWithStatus:dict[@"error"]];
    }
}

-(UITextView *)contentTv{
    if (!_contentTv) {
        _contentTv = [[UITextView alloc] initWithFrame:CGRectMake(12, Header_Height + 10, SCREEN_WIDTH - 12 * 2, SCREEN_HEIGHT - Header_Height - 10)];
        _contentTv.font = [UIFont systemFontOfSize:16];
        [_contentTv becomeFirstResponder];
    }
    return _contentTv;
}

@end
