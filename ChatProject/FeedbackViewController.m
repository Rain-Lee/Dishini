//
//  FeedbackViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/29.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>{
    UITextField *titleTxt;
    UITextView *contentTv;
    UILabel *placeholderLbl;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    
    [self setNavtitle:@"意见反馈"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"提交"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [titleTxt resignFirstResponder];
    [contentTv resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([titleTxt.text isEqual:@""] || [contentTv.text isEqual:@""]) {
        [Toolkit showInfoWithStatus:@"请先完善信息"];
        return;
    }
    
    [Toolkit showWithStatus:@"加载中"];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"FeedbackCallBack:"];
    [dataProvider updateSuggestion:[Toolkit getStringValueByKey:@"Id"] andusername:[Toolkit getStringValueByKey:@"NickName"] andtitle:titleTxt.text andcontent:contentTv.text andpublishtime:[Toolkit getCurrentDate] anduserphone:[Toolkit getStringValueByKey:@"Phone"]];
}

-(void)FeedbackCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showSuccessWithStatus:@"提示成功"];
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [Toolkit showErrorWithStatus:@"提交失败"];
    }
}

-(void)initView{
    // titleTxt
    titleTxt = [[UITextField alloc] initWithFrame:CGRectMake(10, Header_Height + 20, SCREEN_WIDTH - 20, 44)];
    titleTxt.placeholder = @"请输入标题";
    titleTxt.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleTxt];
    // contentTv
    contentTv = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleTxt.frame) + 10, SCREEN_WIDTH - 20, SCREEN_WIDTH * 0.6)];
    contentTv.delegate = self;
    contentTv.layer.masksToBounds = true;
    contentTv.layer.cornerRadius = 5;
    contentTv.layer.borderWidth = 0.5;
    contentTv.font = [UIFont systemFontOfSize:15];
    contentTv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:contentTv];
    // placeholderLbl
    placeholderLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 200, 15)];
    placeholderLbl.text = @"请输入问题或建议";
    placeholderLbl.textColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    placeholderLbl.font = [UIFont systemFontOfSize:15];
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
