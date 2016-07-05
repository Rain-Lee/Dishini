//
//  NewFriendsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "AddressLocalViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface NewFriendsViewController ()<UITextFieldDelegate>{
    
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
}

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"新的朋友"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            return 50;
        }else if (indexPath.row == 1){
            return 20;
        }else if (indexPath.row == 2) {
            return 105;
        }else{
            return 20;
        }
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // searchTxt
            searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
            searchTxt.delegate = self;
            searchTxt.placeholder = @"请输入名称";
            [cell.contentView addSubview:searchTxt];
            // searchIv
            UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(searchTxt.frame) - 22) / 2, 35, 22)];
            searchIv.contentMode = UIViewContentModeScaleAspectFit;
            searchIv.image = [UIImage imageNamed:@"search"];
            searchTxt.leftView = searchIv;
            searchTxt.leftViewMode = UITextFieldViewModeAlways;
        }else if(indexPath.row == 1){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue: 0.96 alpha:1.0];
        }else if (indexPath.row == 2) {
            // phoneIv
            UIImageView *phoneIv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 40) / 2, 20, 40, 35)];
            phoneIv.contentMode = UIViewContentModeScaleAspectFit;
            phoneIv.image = [UIImage imageNamed:@"tel"];
            [cell.contentView addSubview:phoneIv];
            // detailLbl
            UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneIv.frame) + 10, SCREEN_WIDTH, 21)];
            detailLbl.textColor = [UIColor grayColor];
            detailLbl.textAlignment = NSTextAlignmentCenter;
            detailLbl.text = @"添加手机联系人";
            [cell.contentView addSubview:detailLbl];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue: 0.96 alpha:1.0];
        }
    }else{
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        photoIv.image = [UIImage imageNamed:@"default_photo"];
        [cell.contentView addSubview:photoIv];
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 4, 200, 21)];
        nameLbl.text = @"用户昵称";
        [cell.contentView addSubview:nameLbl];
        // detailLbl
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLbl.frame), CGRectGetMaxY(nameLbl.frame) + 4, 200, 21)];
        detailLbl.text = @"备注信息";
        detailLbl.font = [UIFont systemFontOfSize:16];
        detailLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:detailLbl];
        if (indexPath.row == 0) {
            // 已接受
            UIButton *stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 55, (CGRectGetHeight(cell.frame) - 30) / 2, 55, 30)];
            [stateBtn setTitle:@"已添加" forState:UIControlStateNormal];
            [stateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            stateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            stateBtn.layer.masksToBounds = true;
            stateBtn.layer.cornerRadius = 6;
            [cell.contentView addSubview:stateBtn];
        }else{
            // 未接受
            UIButton *stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 55, (CGRectGetHeight(cell.frame) - 30) / 2, 55, 30)];
            [stateBtn setTitle:@"接受" forState:UIControlStateNormal];
            [stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            stateBtn.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.10 alpha:1.0];
            stateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            stateBtn.layer.masksToBounds = true;
            stateBtn.layer.cornerRadius = 6;
            [cell.contentView addSubview:stateBtn];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = false;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 2){
            AddressLocalViewController *addressLocalVC = [[AddressLocalViewController alloc] init];
            addressLocalVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:addressLocalVC animated:true];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
