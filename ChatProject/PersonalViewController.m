//
//  PersonalViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "PersonalViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface PersonalViewController (){
    UITableView *mTableView;
}

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"个人信息"];
    [self addLeftButton:@"left"];
    
    [self initView];
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
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 5){
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
        // photoLbl
        UILabel *photoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, (CGRectGetMaxY(cell.frame) - 21) / 2, 40, 21)];
        photoLbl.text = @"头像";
        [cell.contentView addSubview:photoLbl];
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 50, 10, 50, 50)];
        photoIv.image = [UIImage imageNamed:@"default_photo"];
        [cell.contentView addSubview:photoIv];
    }else if (indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = @"名字";
        [cell.contentView addSubview:nameLbl];
        // nameShowLbl
        UILabel *nameShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        nameShowLbl.font = [UIFont systemFontOfSize:16];
        nameShowLbl.text = @"Hello world";
        nameShowLbl.textAlignment = NSTextAlignmentRight;
        nameShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:nameShowLbl];
    }else if (indexPath.row == 2){
        // wechatNoLbl
        UILabel *wechatNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        wechatNoLbl.textAlignment = NSTextAlignmentLeft;
        wechatNoLbl.text = @"微信号";
        [cell.contentView addSubview:wechatNoLbl];
        // wechatNoShowLbl
        UILabel *wechatNoShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 200, 0, 200, 45)];
        wechatNoShowLbl.font = [UIFont systemFontOfSize:16];
        wechatNoShowLbl.text = @"ddaddfa";
        wechatNoShowLbl.textAlignment = NSTextAlignmentRight;
        wechatNoShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:wechatNoShowLbl];
    }else if (indexPath.row == 3){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // qrCodeLbl
        UILabel *qrCodeLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        qrCodeLbl.textAlignment = NSTextAlignmentLeft;
        qrCodeLbl.text = @"我的二维码";
        [cell.contentView addSubview:qrCodeLbl];
    }else if (indexPath.row == 4){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // addressLbl
        UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        addressLbl.textAlignment = NSTextAlignmentLeft;
        addressLbl.font = [UIFont systemFontOfSize:16];
        addressLbl.text = @"我的地址";
        [cell.contentView addSubview:addressLbl];
    }else if(indexPath.row == 5){
        cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    }else if (indexPath.row == 6){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // sexLbl
        UILabel *sexLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        sexLbl.textAlignment = NSTextAlignmentLeft;
        sexLbl.text = @"性别";
        [cell.contentView addSubview:sexLbl];
        // sexShowLbl
        UILabel *sexShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        sexShowLbl.font = [UIFont systemFontOfSize:16];
        sexShowLbl.text = @"男";
        sexShowLbl.textAlignment = NSTextAlignmentRight;
        sexShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:sexShowLbl];
    }else if (indexPath.row == 7){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // cityLbl
        UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        cityLbl.textAlignment = NSTextAlignmentLeft;
        cityLbl.text = @"地区";
        [cell.contentView addSubview:cityLbl];
        // cityShowLbl
        UILabel *cityShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        cityShowLbl.font = [UIFont systemFontOfSize:16];
        cityShowLbl.text = @"山东 临沂";
        cityShowLbl.textAlignment = NSTextAlignmentRight;
        cityShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:cityShowLbl];
    }else if (indexPath.row == 8){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // signLbl
        UILabel *signLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 50)];
        signLbl.textAlignment = NSTextAlignmentLeft;
        signLbl.text = @"个性签名";
        [cell.contentView addSubview:signLbl];
        // signShowLbl
        UILabel *signShowLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 200, 0, 200, 50)];
        signShowLbl.text = @"12333ee";
        signShowLbl.numberOfLines = 0;
        signShowLbl.font = [UIFont systemFontOfSize:16];
        signShowLbl.textAlignment = NSTextAlignmentRight;
        signShowLbl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:signShowLbl];
    }
    else{
        cell.textLabel.text = @"test";
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
}

@end
