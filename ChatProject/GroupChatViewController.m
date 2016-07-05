//
//  GroupChatViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/29.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GroupChatViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface GroupChatViewController ()<UITextFieldDelegate>{
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
}

@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"群聊"];
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
        return 1;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 60;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    if (indexPath.section == 0){
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
    }else{
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(cell.frame) - 40) / 2, 40, 40)];
        photoIv.image = [UIImage imageNamed:@"default_photo"];
        [cell.contentView addSubview:photoIv];
        
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 5, 0, 200, CGRectGetHeight(cell.frame))];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = @"item";
        [cell.contentView addSubview:nameLbl];
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
    return 12;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}

@end
