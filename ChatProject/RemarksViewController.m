//
//  RemarksViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "RemarksViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface RemarksViewController (){
    UITableView *mTableView;
}

@end

@implementation RemarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"备注信息"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"保存"];
    
    [self initView];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4) {
        return 40;
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
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        // remarkLbl
        UILabel *remarkLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 21)];
        remarkLbl.textColor = [UIColor grayColor];
        remarkLbl.text = @"备注名";
        [cell.contentView addSubview:remarkLbl];
    }else if (indexPath.row == 1){
        UITextField *remarkTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
        remarkTxt.placeholder = @"添加备注名";
        [cell.contentView addSubview:remarkTxt];
    }else if (indexPath.row == 2){
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        // phoneNoLbl
        UILabel *phoneNoLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 21)];
        phoneNoLbl.textColor = [UIColor grayColor];
        phoneNoLbl.text = @"电话号码";
        [cell.contentView addSubview:phoneNoLbl];
    }else if (indexPath.row == 3){
        UITextField *phoneTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
        phoneTxt.placeholder = @"请输入电话号码";
        [cell.contentView addSubview:phoneTxt];
    }else if (indexPath.row == 4){
        cell.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
        // descriptionLbl
        UILabel *descriptionLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 21)];
        descriptionLbl.textColor = [UIColor grayColor];
        descriptionLbl.text = @"描述";
        [cell.contentView addSubview:descriptionLbl];
    }else if (indexPath.row == 5){
        UITextField *descriptionTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
        descriptionTxt.placeholder = @"请输入备注信息";
        [cell.contentView addSubview:descriptionTxt];
    }
    return cell;
}

@end
