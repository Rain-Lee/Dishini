//
//  DetailsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DetailsViewController.h"
#import "DataSettingViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface DetailsViewController (){
    UITableView *mTableView;
}

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"详细资料"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

#pragma mark - 自定义方法
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
    [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgBtn addTarget:self action:@selector(sendMsgEvent) forControlEvents:UIControlEventTouchUpInside];
    sendMsgBtn.layer.masksToBounds = true;
    sendMsgBtn.layer.cornerRadius = 6;
    [footerView addSubview:sendMsgBtn];
}

-(void)sendMsgEvent{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        return 20;
    }else if (indexPath.row == 5){
        return 80;
    }else{
        return 50;
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
        photoIv.image = [UIImage imageNamed:@"default_photo"];
        [cell.contentView addSubview:photoIv];
        // nickNameLbl
        UILabel *nickNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 6, 200, 21)];
        nickNameLbl.text = @"用户昵称";
        [cell.contentView addSubview:nickNameLbl];
        // wechatNoLbl
        UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nickNameLbl.frame), CGRectGetMaxY(nickNameLbl.frame) + 5, 200, 21)];
        wechatNoLbl.font = [UIFont systemFontOfSize:16];
        wechatNoLbl.text = @"微信号：abc123";
        [cell.contentView addSubview:wechatNoLbl];
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"设置备注和标签";
        titleLbl.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:titleLbl];
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
    }else if (indexPath.row == 6){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // moreLbl
        UILabel *moreLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, CGRectGetHeight(cell.frame))];
        moreLbl.text = @"更多";
        [cell.contentView addSubview:moreLbl];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6){
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
        DataSettingViewController *dataSettingVC = [[DataSettingViewController alloc] init];
        [self.navigationController pushViewController:dataSettingVC animated:true];
    }
}

@end
