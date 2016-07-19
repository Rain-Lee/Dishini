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
#import "UIImageView+WebCache.h"

#define CellIdentifier @"CellIdentifier"

@interface DetailsViewController ()<RemarksDelegate, DataSettingDelegate>{
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
    
    [self initData];
}

-(void)clickRightButton:(UIButton *)sender{
    if (isFriend) {
        DataSettingViewController *dataSettingVC = [[DataSettingViewController alloc] init];
        dataSettingVC.delegate = self;
        dataSettingVC.userId = userInfoDict[@"Id"];
        dataSettingVC.remarkValue = [userInfoDict[@"RemarkName"] isEqual:@""] ? userInfoDict[@"NicName"] : userInfoDict[@"RemarkName"];
        dataSettingVC.photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,userInfoDict[@"PhotoPath"]];
        [self.navigationController pushViewController:dataSettingVC animated:true];
    }
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
        @try {
            userInfoDict = [[NSMutableDictionary alloc] init];
            userInfoDict = dict[@"data"];
            if ([_iFlag isEqual:@"1"]) {
                isFriend = [[Toolkit judgeIsNull:userInfoDict[@"IsFriend"]] isEqual:@"1"] ? true : false;
            }else{
                isFriend = [[Toolkit judgeIsNull:userInfoDict[@"IsWuyou"]] isEqual:@"1"] ? true : false;
            }
            if (isFriend) {
                [self addRightButton:@"moreNoword"];
            }
            [self initView];
        } @catch (NSException *exception) {
            [self.navigationController popViewControllerAnimated:true];
            [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"data"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        } @finally {
            
        }
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
        chatRoomVC.iFlag = @"1";
        chatRoomVC.conversationType = ConversationType_PRIVATE;
        chatRoomVC.targetId = [NSString stringWithFormat:@"%@",_userId];
        chatRoomVC.title = userInfoDict[@"NicName"];
        [self.navigationController pushViewController:chatRoomVC animated:true];
    }else{
        [Toolkit showWithStatus:@"请稍等..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"addFriendCallBack:"];
        [dataProvider addFriend:[Toolkit getStringValueByKey:@"Id"] andFriendId:userInfoDict[@"Id"]];
    }
}

-(void)addFriendCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [self.navigationController popViewControllerAnimated:true];
        [Toolkit showSuccessWithStatus:@"申请添加好友成功"];
    }
    else{
        [Toolkit showErrorWithStatus:dict[@"data"]];
    }
    [SVProgressHUD dismiss];
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
        
        NSString *nickName = userInfoDict[@"NicName"];
        NSString *remarkName = userInfoDict[@"RemarkName"];
        if ([remarkName isEqual:@""] || [nickName isEqual:remarkName]) {
            // nickNameLbl
            NSString *nickNameStr = userInfoDict[@"NicName"];
            CGSize textSize = [nickNameStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16]}];
            UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 10, textSize.width + 2, 21)];
            nickNameLbl.font = [UIFont systemFontOfSize:16];
            nickNameLbl.text = nickNameStr;
            [cell.contentView addSubview:nickNameLbl];
            // sexIv
            UIImageView *sexIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLbl.frame) + 2, CGRectGetMinY(nickNameLbl.frame) + 3, 13, 13)];
            NSString *sexuality = [NSString stringWithFormat:@"%@",userInfoDict[@"Sexuality"]];
            if ([sexuality isEqual:@"1"]) {
                sexIv.image = [UIImage imageNamed:@"bule-boy"];
            }else if ([sexuality isEqual:@"2"]){
                sexIv.image = [UIImage imageNamed:@"red-girl"];
            }
            [cell.contentView addSubview:sexIv];
            // wechatNoLbl
            UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLbl.frame), CGRectGetMaxY(nickNameLbl.frame) + 2, 200, 21)];
            wechatNoLbl.font = [UIFont systemFontOfSize:16];
            wechatNoLbl.text = [NSString stringWithFormat:@"IPIC:%@",userInfoDict[@"Phone"]];
            [cell.contentView addSubview:wechatNoLbl];
        }else{
            // remarkNameLbl
            NSString *remarkStr = userInfoDict[@"RemarkName"];
            CGSize textSize = [remarkStr sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]}];
            UILabel *remarkNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 1, textSize.width + 2, 21)];
            remarkNameLbl.font = [UIFont systemFontOfSize:14];
            remarkNameLbl.text = remarkStr;
            [cell.contentView addSubview:remarkNameLbl];
            // sexIv
            UIImageView *sexIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remarkNameLbl.frame) + 2, CGRectGetMinY(remarkNameLbl.frame) + 5, 12, 12)];
            NSString *sexuality = [NSString stringWithFormat:@"%@",userInfoDict[@"Sexuality"]];
            if ([sexuality isEqual:@"1"]) {
                sexIv.image = [UIImage imageNamed:@"bule-boy"];
            }else if ([sexuality isEqual:@"2"]){
                sexIv.image = [UIImage imageNamed:@"red-girl"];
            }
            [cell.contentView addSubview:sexIv];
            // wechatNoLbl
            UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(remarkNameLbl.frame), CGRectGetMaxY(remarkNameLbl.frame) + 3, 200, 21)];
            wechatNoLbl.font = [UIFont systemFontOfSize:12];
            wechatNoLbl.text = [NSString stringWithFormat:@"IPIC:%@",userInfoDict[@"Phone"]];
            wechatNoLbl.textColor = [UIColor grayColor];
            [cell.contentView addSubview:wechatNoLbl];
            // nickNameLbl
            UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMaxY(wechatNoLbl.frame) + 1, 200, 21)];
            nickNameLbl.font = [UIFont systemFontOfSize:12];
            nickNameLbl.textColor = [UIColor grayColor];
            nickNameLbl.text = [NSString stringWithFormat:@"昵称：%@",userInfoDict[@"NicName"]];
            [cell.contentView addSubview:nickNameLbl];
        }
        
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 2){
        if (isFriend) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // titleLbl
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, CGRectGetHeight(cell.frame))];
            titleLbl.text = @"设置备注名称";
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
        if ([_iFlag isEqual:@"1"]) {
            addressShowLbl.text = userInfoDict[@"HomeAddress"];
        }else{
            addressShowLbl.text = userInfoDict[@"ActivityAddress"];
        }
        if ([addressShowLbl.text isEqual:@"0"]) {
            addressShowLbl.text = @"";
        }
        addressShowLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:addressShowLbl];
    }else if (indexPath.row == 5){
        if (isFriend) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // photosLbl
            UILabel *photosLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, CGRectGetHeight(cell.frame))];
            photosLbl.textAlignment = NSTextAlignmentLeft;
            photosLbl.text = @"个人相册";
            [cell.contentView addSubview:photosLbl];
            NSArray *picList = userInfoDict[@"PicList"];
            for (int i = 0; i < picList.count; i++) {
                // photoIv
                UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photosLbl.frame) + (60 + 5) * i, 10, 60, 60)];
                NSString *imagePath = [NSString stringWithFormat:@"%@%@",Kimg_path,picList[i][@"ImagePath"]];
                [photoIv sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"default_photo"]];
                [cell.contentView addSubview:photoIv];
            }
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
        remarksVC.delegate = self;
        remarksVC.userId = userInfoDict[@"Id"];
        remarksVC.remarkValue = [userInfoDict[@"RemarkName"] isEqual:@""] ? userInfoDict[@"NicName"] : userInfoDict[@"RemarkName"];
        [self.navigationController pushViewController:remarksVC animated:TRUE];
    }else if (indexPath.row == 5){
        UserMomentsViewController *userMomentsVC = [[UserMomentsViewController alloc] init];
        userMomentsVC.nickName = [userInfoDict[@"RemarkName"] isEqual:@""] ? userInfoDict[@"NicName"] : userInfoDict[@"RemarkName"];
        userMomentsVC.userId = userInfoDict[@"Id"];
        [self.navigationController pushViewController:userMomentsVC animated:YES];
    }
}

-(void)changeRemarkRefreshData{
    [self initData];
}

-(void)dataSettingRefreshData{
    [self initData];
}

@end
