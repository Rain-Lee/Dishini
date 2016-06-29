//
//  DataSettingViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "DataSettingViewController.h"
#import "RemarksViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface DataSettingViewController (){
    UITableView *mTableView;
}

@end

@implementation DataSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"资料设置"];
    [self addLeftButton:@"left"];
    
    [self initView];
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
    sendMsgBtn.backgroundColor = [UIColor colorWithRed:0.90 green:0.27 blue:0.25 alpha:1.00];
    [sendMsgBtn setTitle:@"删除" forState:UIControlStateNormal];
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
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 20;
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, CGRectGetHeight(cell.frame))];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.text = @"设置备注及标签";
        [cell.contentView addSubview:titleLbl];
        // detailLbl
        UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 100, 0, 100, CGRectGetHeight(cell.frame))];
        detailLbl.textAlignment = NSTextAlignmentRight;
        detailLbl.font = [UIFont systemFontOfSize:16];
        detailLbl.text = @"用户昵称";
        [cell.contentView addSubview:detailLbl];
    }else if (indexPath.row == 1){
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // titleLbl
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, CGRectGetHeight(cell.frame))];
        titleLbl.textAlignment = NSTextAlignmentLeft;
        titleLbl.text = @"把他推荐给朋友";
        [cell.contentView addSubview:titleLbl];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        RemarksViewController *remarksVC = [[RemarksViewController alloc] init];
        [self.navigationController pushViewController:remarksVC animated:TRUE];
    }
}

@end
