//
//  InputAddressViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "InputAddressViewController.h"

@interface InputAddressViewController ()<UITextFieldDelegate>{
    UITextField *addressTxt;
}

@end

@implementation InputAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setNavtitle:@"地址"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [addressTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"editUserInfoCallBack:"];
    [dataProvider editUserInfo:[Toolkit getStringValueByKey:@"Id"] andNickName:[Toolkit getStringValueByKey:@"NickName"] andSex:[Toolkit getStringValueByKey:@"SexId"] andHomeAreaId:addressTxt.text andDescription:[Toolkit getStringValueByKey:@"Sign"]];
}

-(void)editUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        
        [Toolkit setUserDefaultValue:addressTxt.text andKey:@"Address"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
        
        if ([self.delegate respondsToSelector:@selector(getAddress:)]) {
            [self.delegate getAddress:addressTxt.text];
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
    // addressTxt
    addressTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
    addressTxt.delegate = self;
    addressTxt.placeholder = @"请输入地址";
    addressTxt.backgroundColor = [UIColor whiteColor];
    addressTxt.text = _addressStr;
    [cusView addSubview:addressTxt];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
