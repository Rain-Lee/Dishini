//
//  GroupNameViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GroupNameViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface GroupNameViewController ()<UITextFieldDelegate>{
    UITextField *nameTxt;
}

@end

@implementation GroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setNavtitle:@"名字"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [nameTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"editUserInfoCallBack:"];
    [dataProvider editGroup:_groupId andName:nameTxt.text andUserId:[Toolkit getStringValueByKey:@"Id"] andImagePath:@""];
}

-(void)editUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        if ([self.delegate respondsToSelector:@selector(getName:)]) {
            [self.delegate getName:nameTxt.text];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataNotification" object:nil];
        RCGroup *group = [[RCIM sharedRCIM] getGroupInfoCache:_groupId];
        group.groupName = nameTxt.text;
        [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:_groupId];
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"修改群组名称失败" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)initView{
    // cusView
    UIView *cusView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 20, SCREEN_WIDTH, 44)];
    cusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cusView];
    // nameTxt
    nameTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
    nameTxt.delegate = self;
    nameTxt.placeholder = @"请输入名称";
    nameTxt.backgroundColor = [UIColor whiteColor];
    nameTxt.text = _nameStr;
    [nameTxt addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [cusView addSubview:nameTxt];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldChange:(UITextField *)textField{
    if (nameTxt.text.length > 13) {
        nameTxt.text = [nameTxt.text substringToIndex:13];
    }
}

@end
