//
//  GroupGonggaoViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/8.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GroupGonggaoViewController.h"

@interface GroupGonggaoViewController ()

@property (nonatomic, strong) UITextView *contentTv;

@end

@implementation GroupGonggaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"群公告"];
    [self addLeftButton:@"left"];
    if ([_isManager isEqual:@"1"]) {
        [self addRightbuttontitle:@"保存"];
    }
    
    [self initView];
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
    [dataProvider saveGroupInfo:_groupId andContent:self.contentTv.text];
}

-(void)saveDataCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [self.view endEditing:true];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initChatListData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initChatRoomData" object:nil];
        [Toolkit showSuccessWithStatus:@"保存成功"];
        
        [self initData];
    }else{
        [Toolkit showErrorWithStatus:dict[@"error"]];
    }
}

-(void)initData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDataCallBack:"];
    [dataProvider getGroupInfoById:_groupId];
}

-(void)getDataCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        self.contentTv.text = dict[@"data"][@"TeamAnnouncement"];
    }
}

-(void)initView{
    [self.view addSubview:self.contentTv];
    [self initData];
}

-(UITextView *)contentTv{
    if (!_contentTv) {
        _contentTv = [[UITextView alloc] initWithFrame:CGRectMake(12, Header_Height + 10, SCREEN_WIDTH - 12 * 2, SCREEN_HEIGHT - Header_Height - 10)];
        _contentTv.font = [UIFont systemFontOfSize:16];
        if ([_isManager isEqual:@"1"]) {
            _contentTv.editable = true;
        }else{
            _contentTv.editable = false;
        }
    }
    return _contentTv;
}

@end
