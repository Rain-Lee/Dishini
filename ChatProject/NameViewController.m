//
//  NameViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()<UITextFieldDelegate>{
    UITextField *nameTxt;
}

@end

@implementation NameViewController

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
    [dataProvider editUserInfo:[Toolkit getStringValueByKey:@"Id"] andNickName:nameTxt.text andSex:[Toolkit getStringValueByKey:@"SexId"] andHomeAreaId:@"0" andDescription:[Toolkit getStringValueByKey:@"Sign"]];
}

-(void)editUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        
        [Toolkit setUserDefaultValue:nameTxt.text andKey:@"NickName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
        
        if ([self.delegate respondsToSelector:@selector(getName:)]) {
            [self.delegate getName:nameTxt.text];
        }
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
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
    [cusView addSubview:nameTxt];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
