//
//  NewFriendsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "AddressLocalViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "DetailsViewController.h"
#import "PersonalViewController.h"
#import <RongIMKit/RongIMKit.h>

#define CellIdentifier @"CellIdentifier"

@interface NewFriendsViewController ()<UITextFieldDelegate>{
    
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
    UIView *bgView;
    
    // data
    NSMutableArray *userDataArray;
    int index;
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
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mTableView.header beginRefreshing];
    
    mTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height + 70, SCREEN_WIDTH, SCREEN_HEIGHT - (Header_Height + 70))];
    bgView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:0.60];
    bgView.hidden = true;
    [self.view addSubview:bgView];
}

-(void)refreshData{
    index = 0;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendsCallBack:"];
    [dataProvider selectApplyList:@"0" andMaximumRows:@"20" andUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getFriendsCallBack:(id)dict{
    NSLog(@"%@",dict);
    [mTableView.header endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        userDataArray = [[NSMutableArray alloc] init];
        userDataArray = dict[@"data"];
        
        if (userDataArray.count == [dict[@"recordcount"] intValue]){
            // 所有数据加载完毕，没有更多的数据了
            mTableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            // mj_footer设置为:普通闲置状态(Idle)
            mTableView.footer.state = MJRefreshStateIdle;
        }
    }
    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)loadMore{
    index++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"loadMoreCallBack:"];
    [dataProvider selectApplyList:[NSString stringWithFormat:@"%d",index * 20] andMaximumRows:@"20" andUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)loadMoreCallBack:(id)dict{
    // 结束刷新
    [mTableView.footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [userDataArray addObject:item];
        }
        if (userDataArray.count == [dict[@"recordcount"] intValue]){
            // 所有数据加载完毕，没有更多的数据了
            mTableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            // mj_footer设置为:普通闲置状态(Idle)
            mTableView.footer.state = MJRefreshStateIdle;
        }
        [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)stateBtnEvent:(UIButton *)sender{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    NSLog(@"%@",userDataArray);
    [dataProvider setDelegateObject:self setBackFunctionName:@"stateBtnCallBack:"];
    [dataProvider agreeFriendAndSaveFriend:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}

-(void)stateBtnCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mRefreshData" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getFriendFunc" object:nil];
        [self.navigationController popToRootViewControllerAnimated:true];
        
        RCTextMessage *txtMessage = [RCTextMessage messageWithContent:@"添加好友成功"];
        txtMessage.extra = @"jieshou";
        [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:@"" content:txtMessage pushContent:nil pushData:nil success:nil error:nil];
        
        [Toolkit showSuccessWithStatus:@"操作成功"];
    }else{
        [Toolkit showErrorWithStatus:dict[@"error"]];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return userDataArray.count;
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
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // searchTxt
            searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
            searchTxt.delegate = self;
            searchTxt.keyboardType = UIKeyboardTypePhonePad;
            searchTxt.returnKeyType = UIReturnKeySearch;
            searchTxt.placeholder = @"请输入手机号";
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
        NSDictionary *valueDict = userDataArray[indexPath.row][@"Value"];
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,[valueDict valueForKey:@"PhotoPath"]];
        [photoIv sd_setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:[UIImage imageNamed:@"default_photo"]];
        [cell.contentView addSubview:photoIv];
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, 0, 200, CGRectGetHeight(cell.frame))];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = valueDict[@"NicName"];
        [cell.contentView addSubview:nameLbl];
//        // detailLbl
//        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLbl.frame), CGRectGetMaxY(nameLbl.frame) + 4, 200, 21)];
//        detailLbl.text = @"备注信息";
//        detailLbl.font = [UIFont systemFontOfSize:16];
//        detailLbl.textColor = [UIColor grayColor];
//        [cell.contentView addSubview:detailLbl];
        if (false) {
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
            stateBtn.tag = [valueDict[@"Id"] intValue];
            [stateBtn addTarget:self action:@selector(stateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)textFieldDidEndEditing:(UITextField *)textField{
    bgView.hidden = true;
    if ([textField.text isEqual:@""]) {
        return;
    }
    if ([[Toolkit getStringValueByKey:@"Phone"] isEqual:searchTxt.text]){
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:true];
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.iFlag = @"2";
        detailsVC.userId = [Toolkit getStringValueByKey:@"Id"];
        detailsVC.phone = searchTxt.text;
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    bgView.hidden = false;
    return true;
}

@end
