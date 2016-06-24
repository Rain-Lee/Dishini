//
//  NewFriendsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "NewFriendsViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface NewFriendsViewController ()<UISearchResultsUpdating,UISearchControllerDelegate>{
    
    // view
    UITableView *mTableView;
    UISearchController *resultSearchController;
}

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"新的朋友"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
    
    [self getSearchController];
}

-(void)getSearchController{
    // 实例化UISearchController，并且设置搜索控制器为本身TableView
    //resultSearchController = UISearchController(searchResultsController: nil)
    resultSearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    //设置UISearchControllerDelegate delegate
    resultSearchController.delegate = self;
    
    // 设置更新搜索结果的对象为self
    resultSearchController.searchResultsUpdater = self;
    
    // 设置UISearchController是否在编辑的时候隐藏NavigationBar，默认为true
    resultSearchController.hidesNavigationBarDuringPresentation = false;
    
    // 设置UISearchController是否在编辑的时候隐藏背景色，默认为true
    resultSearchController.dimsBackgroundDuringPresentation = false;
    
    // 设置UISearchController搜索栏的UISearchBarStyle为Prominent
    resultSearchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    resultSearchController.searchBar.placeholder = @"微信号/手机号";
    
    // 设置UISearchController搜索栏的Size是自适应
    [resultSearchController.searchBar sizeToFit];
    
    mTableView.tableHeaderView = resultSearchController.searchBar;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 105;
        }else{
            return 25;
        }
    }else{
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue: 0.93 alpha:1.0];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
