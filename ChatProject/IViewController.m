//
//  IViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "IViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PersonalViewController.h"
#import "AnnouncementViewController.h"
#import "FeedbackViewController.h"
#import "UIImageView+WebCache.h"

#define CellIdentifier @"CellIdentifier"

@interface IViewController (){
    UITableView *mTableView;
}

@end

@implementation IViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"我的"];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"updateData" object:nil];
}

#pragma mark - 自定义方法
-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    mTableView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
}

-(void)updateData{
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 8){
        return 20;
    }else{
        return 55;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
        [photoIv sd_setImageWithURL:[NSURL URLWithString:[Toolkit getStringValueByKey:@"PhotoPath"]] placeholderImage:[UIImage imageNamed:@"default_photo"]];
        [cell.contentView addSubview:photoIv];
        photoIv.layer.masksToBounds = true;
        photoIv.layer.cornerRadius = 6;
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 10, CGRectGetMinY(photoIv.frame) + 5, 200, 21)];
        nameLbl.text = [Toolkit getStringValueByKey:@"NickName"];
        [cell.contentView addSubview:nameLbl];
        // detailLbl
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLbl.frame), CGRectGetMaxY(nameLbl.frame) + 8, 200, 21)];
        detailLbl.text = [NSString stringWithFormat:@"IPIC:%@",[Toolkit getStringValueByKey:@"Phone"]];
        detailLbl.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:detailLbl];
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }else if (indexPath.row == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleIv
        UIImageView *titleIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 23) / 2, 23, 23)];
        titleIv.image = [UIImage imageNamed:@"6"];
        [cell.contentView addSubview:titleIv];
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleIv.frame) + 15, 0, 200, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"商城";
        [cell.contentView addSubview:titleLbl];
    }else if (indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleIv
        UIImageView *titleIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 23) / 2, 23, 23)];
        titleIv.image = [UIImage imageNamed:@"gonggao"];
        [cell.contentView addSubview:titleIv];
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleIv.frame) + 15, 0, 200, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"公告";
        [cell.contentView addSubview:titleLbl];
    }else if (indexPath.row == 4){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }else if (indexPath.row == 5){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleIv
        UIImageView *titleIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 23) / 2, 23, 23)];
        titleIv.image = [UIImage imageNamed:@"3"];
        [cell.contentView addSubview:titleIv];
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleIv.frame) + 15, 0, 200, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"关于我们";
        [cell.contentView addSubview:titleLbl];
    }else if (indexPath.row == 6){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleIv
        UIImageView *titleIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 23) / 2, 23, 23)];
        titleIv.image = [UIImage imageNamed:@"4"];
        [cell.contentView addSubview:titleIv];
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleIv.frame) + 15, 0, 200, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"意见反馈";
        [cell.contentView addSubview:titleLbl];
    }else if (indexPath.row == 7){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleIv
        UIImageView *titleIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 23) / 2, 23, 23)];
        titleIv.image = [UIImage imageNamed:@"8"];
        [cell.contentView addSubview:titleIv];
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleIv.frame) + 15, 0, 200, CGRectGetHeight(cell.frame))];
        titleLbl.text = @"客服";
        [cell.contentView addSubview:titleLbl];
    }else if (indexPath.row == 8){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }else if (indexPath.row == 9){
        cell.backgroundColor = [UIColor whiteColor];
        // logOutBtn
        UIButton *logOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(cell.frame) - 21) / 2, SCREEN_WIDTH, 21)];
        [logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        logOutBtn.userInteractionEnabled = false;
        [cell.contentView addSubview:logOutBtn];
    }else if (indexPath.row == 10){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 ){
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = false;
        }
    }else if (indexPath.row == 10){
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
        }
        
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            cell.preservesSuperviewLayoutMargins = false;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        personalVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:personalVC animated:true];
    }else if (indexPath.row == 3){
        AnnouncementViewController *announcementVC = [[AnnouncementViewController alloc] init];
        announcementVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:announcementVC animated:true];
    }else if (indexPath.row == 6){
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        feedbackVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:feedbackVC animated:true];
    }else if (indexPath.row == 7){
        [Toolkit makeCall:@"12345678910"];
    }else if (indexPath.row == 9) {
        [Toolkit actionSheetViewFirst:self andTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" andMsg:nil andCancelButtonTitle:@"取消" andOtherButtonTitle:@"退出登录" handler:^(int buttonIndex, UIAlertAction *alertView) {
            if (buttonIndex == 1) {
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
                navLoginVC.navigationBar.hidden = true;
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                appDelegate.window.rootViewController = navLoginVC;
            }
        }];
    }
}

@end
