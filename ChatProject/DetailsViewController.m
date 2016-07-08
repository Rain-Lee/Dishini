//
//  DetailsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DetailsViewController.h"
#import "DataSettingViewController.h"
#import "UserMomentsViewController.h"
#import "ChatRoomViewController.h"
#import "RemarksViewController.h"
#import "DataSettingViewController.h"
#import "UIImageView+WebCache.h"

#define CellIdentifier @"CellIdentifier"

@interface DetailsViewController (){
    // view
    UITableView *mTableView;
    
    // data
    NSMutableDictionary *userInfoDict;
    BOOL isFriend;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"详细资料"];
    [self addLeftButton:@"left"];
    [self addRightButton:@"moreNoword"];
    
    [self initData];
}

-(void)clickRightButton:(UIButton *)sender{
    DataSettingViewController *dataSettingVC = [[DataSettingViewController alloc] init];
    [self.navigationController pushViewController:dataSettingVC animated:true];
}

#pragma mark - 自定义方法
-(void)initData{
    [Toolkit showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getUeserInfoCallBack:"];
    if ([_iFlag isEqual:@"1"]) {
        [dataProvider getUserInfoByUserId:[Toolkit getStringValueByKey:@"Id"] andFriendId:_userId];
    }else{
        [dataProvider searchFriendByPhone:_userId andPhone:_phone];
    }
}

-(void)getUeserInfoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        userInfoDict = [[NSMutableDictionary alloc] init];
        userInfoDict = dict[@"data"];
        isFriend = [userInfoDict[@"IsWuyou"] isEqual:@"1"] ? true : false;
        [self initView];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
    // footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    mTableView.tableFooterView = footerView;
    // sendMsgBtn
    UIButton *sendMsgBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH - 30, 44)];
    sendMsgBtn.backgroundColor = [UIColor colorWithRed:0.02 green:0.75 blue:0.00 alpha:1.00];
    if (isFriend) {
        sendMsgBtn.tag = 1;
        [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    }else{
        sendMsgBtn.tag = 2;
        [sendMsgBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgBtn addTarget:self action:@selector(sendMsgEvent:) forControlEvents:UIControlEventTouchUpInside];
    sendMsgBtn.layer.masksToBounds = true;
    sendMsgBtn.layer.cornerRadius = 6;
    [footerView addSubview:sendMsgBtn];
}

-(void)sendMsgEvent:(UIButton *)sender{
    if (sender.tag == 1) {
        ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
        chatRoomVC.conversationType = ConversationType_PRIVATE;
        chatRoomVC.targetId = _userId;
        chatRoomVC.title = userInfoDict[@"NicName"];
        [self.navigationController pushViewController:chatRoomVC animated:true];
    }else{
        if ([[Toolkit getStringValueByKey:@"Phone"] isEqual:_phone]){
            [Toolkit showInfoWithStatus:@"不能添加自己"];
            return;
        }
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendCallBack:"];
        [dataProvider addFriend:@"2015" andFriendId:@"2013"];
    }
}

-(void)addFriendCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [self.navigationController popToRootViewControllerAnimated:true];
        [Toolkit showSuccessWithStatus:@"申请添加好友成功"];
    }
    else{
        [Toolkit showErrorWithStatus:@"申请添加好友失败"];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        if (indexPath.row == 1){
            if (isFriend) {
                return 20;
            }else{
                return 0;
            }
        }else{
            return 20;
        }
    }else if (indexPath.row == 5){
        if (isFriend) {
            return 80;
        }else{
            return 0;
        }
    }else{
        if (indexPath.row == 2) {
            if (!isFriend) {
                return 0;
            }else{
                return 50;
            }
        }else{
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,userInfoDict[@"PhotoPath"]];
        [photoIv sd_setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:[UIImage imageNamed:@"default_photo"]];
        [cell.contentView addSubview:photoIv];
        // nickNameLbl
        UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 6, 200, 21)];
        nickNameLbl.text = userInfoDict[@"NicName"];
        [cell.contentView addSubview:nickNameLbl];
        // wechatNoLbl
        UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLbl.frame), CGRectGetMaxY(nickNameLbl.frame) + 5, 200, 21)];
        wechatNoLbl.font = [UIFont systemFontOfSize:16];
        wechatNoLbl.text = [NSString stringWithFormat:@"IPIC:%@",userInfoDict[@"Phone"]];
        [cell.contentView addSubview:wechatNoLbl];
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 2){
        if (isFriend) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // titleLbl
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, CGRectGetHeight(cell.frame))];
            titleLbl.text = @"设置备注和标签";
            titleLbl.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:titleLbl];
        }
    }else if (indexPath.row == 3){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 4){
        // addressLbl
        UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, CGRectGetHeight(cell.frame))];
        addressLbl.textAlignment = NSTextAlignmentLeft;
        addressLbl.text = @"地区";
        [cell.contentView addSubview:addressLbl];
        // addressShowLbl
        UILabel *addressShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressLbl.frame), 0, 200, CGRectGetHeight(cell.frame))];
        addressShowLbl.text = @"山东 临沂";
        addressShowLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:addressShowLbl];
    }else if (indexPath.row == 5){
        if (isFriend) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // photosLbl
            UILabel *photosLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, CGRectGetHeight(cell.frame))];
            photosLbl.textAlignment = NSTextAlignmentLeft;
            photosLbl.text = @"地区";
            [cell.contentView addSubview:photosLbl];
            // photoIv1
            UIImageView *photoIv1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photosLbl.frame), 10, 60, 60)];
            photoIv1.image = [UIImage imageNamed:@"default_photo"];
            [cell.contentView addSubview:photoIv1];
            // photoIv2
            UIImageView *photoIv2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv1.frame) + 5, 10, 60, 60)];
            photoIv2.image = [UIImage imageNamed:@"default_photo"];
            [cell.contentView addSubview:photoIv2];
            // photoIv3
            UIImageView *photoIv3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv2.frame) + 5, 10, 60, 60)];
            photoIv3.image = [UIImage imageNamed:@"default_photo"];
            [cell.contentView addSubview:photoIv3];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3){
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 2) {
        RemarksViewController *remarksVC = [[RemarksViewController alloc] init];
        [self.navigationController pushViewController:remarksVC animated:TRUE];
    }else if (indexPath.row == 5){
        UserMomentsViewController *userMomentsVC = [[UserMomentsViewController alloc] init];
        userMomentsVC.nickName = @"nickName";
        userMomentsVC.userId = _userId;
        [self.navigationController pushViewController:userMomentsVC animated:YES];
    }
}

@end
