//
//  ChangePwdViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

#define CellIdentifier @"CellIdentifier"

@interface ChangePwdViewController ()<UITextFieldDelegate>{
    // view
    UITableView *mTableView;
    
    UITextField *phoneTxt;
    UITextField *oldPwdTxt;
    UITextField *newPwdTxt;
    UITextField *reNewPwdTxt;
}

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"修改密码"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [phoneTxt resignFirstResponder];
    [oldPwdTxt resignFirstResponder];
    [newPwdTxt resignFirstResponder];
    [reNewPwdTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([phoneTxt.text isEqual:@""] || [oldPwdTxt.text isEqual:@""] || [newPwdTxt.text isEqual:@""] || [reNewPwdTxt.text isEqual:@""]) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"请完善信息" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        return;
    }
    if (![newPwdTxt.text isEqual:reNewPwdTxt.text]) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"两次新密码输入不一致" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        return;
    }
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"saveCallBack:"];
    [dataProvider changePwd:phoneTxt.text andOldPwd:oldPwdTxt.text andPassword:newPwdTxt.text];
}

-(void)saveCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navLoginVC.navigationBar.hidden = true;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = navLoginVC;
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"data"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

#pragma mark - 自定义方法
-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        // phoneLbl
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(cell.frame))];
        phoneLbl.text = @"手机号";
        phoneLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:phoneLbl];
        // phoneTxt
        phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneLbl.frame), 0, 200, CGRectGetHeight(cell.frame))];
        phoneTxt.keyboardType = UIKeyboardTypePhonePad;
        phoneTxt.placeholder = @"请输入手机号";
        [cell.contentView addSubview:phoneTxt];
        if ([Toolkit isExitAccount]) {
            phoneTxt.text = [Toolkit getStringValueByKey:@"Phone"];
            phoneTxt.enabled = false;
            phoneTxt.textColor = [UIColor grayColor];
            phoneLbl.textColor = [UIColor grayColor];
        }
    }else if (indexPath.row == 1) {
        // oldPwdLbl
        UILabel *oldPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(cell.frame))];
        oldPwdLbl.text = @"原密码";
        oldPwdLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:oldPwdLbl];
        // oldPwdTxt
        oldPwdTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oldPwdLbl.frame), 0, 200, CGRectGetHeight(cell.frame))];
        oldPwdTxt.secureTextEntry = true;
        oldPwdTxt.placeholder = @"请输入原密码";
        [cell.contentView addSubview:oldPwdTxt];
    }else if (indexPath.row == 2){
        // newPwdLbl
        UILabel *newPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(cell.frame))];
        newPwdLbl.text = @"新密码";
        newPwdLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:newPwdLbl];
        // pwdTxt
        newPwdTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newPwdLbl.frame), 0, 200, CGRectGetHeight(cell.frame))];
        newPwdTxt.secureTextEntry = true;
        newPwdTxt.placeholder = @"请输入新密码";
        [cell.contentView addSubview:newPwdTxt];
    }else if (indexPath.row == 3){
        // reNewPwdLbl
        UILabel *reNewPwdLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(cell.frame))];
        reNewPwdLbl.text = @"再次输入";
        reNewPwdLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:reNewPwdLbl];
        // reNewPwdTxt
        reNewPwdTxt = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reNewPwdLbl.frame), 0, 200, CGRectGetHeight(cell.frame))];
        reNewPwdTxt.secureTextEntry = true;
        reNewPwdTxt.placeholder = @"请再次输入新密码";
        [cell.contentView addSubview:reNewPwdTxt];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
