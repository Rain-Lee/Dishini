//
//  ContactsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "MJRefresh.h"
#import "ChineseString.h"
#import "NewFriendsViewController.h"
#import "LaunchGroupChatViewController.h"
#import "GroupChatViewController.h"
#import "DetailsViewController.h"

#define ContactsCell @"ContactsTableViewCell"

@interface ContactsViewController (){
    
    // view
    UITableView *mTableView;
    
    // data
    NSMutableArray *firstLetterArray;
    NSMutableArray *contactsData;
    NSMutableArray *letterResultArray;
    
}

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"通讯录"];
    
    [self initView];
}

- (void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerNib:[UINib nibWithNibName:ContactsCell bundle:nil] forCellReuseIdentifier:ContactsCell];
    [self.view addSubview:mTableView];
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mTableView.header beginRefreshing];
}

- (void)refreshData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendsCallBack:"];
    [dataProvider getFriends:[Toolkit getStringValueByKey:@"Id"]];
}

- (void)getFriendsCallBack:(id)dict{
    contactsData = [[NSMutableArray alloc] init];
    firstLetterArray = [[NSMutableArray alloc] init];
    letterResultArray = [[NSMutableArray alloc] init];
    if ([dict[@"code"] intValue] == 200) {
        contactsData = dict[@"data"];
        NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
        for (int i=0; i<contactsData.count; i++) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:contactsData[i][@"Value"]];
            [tempDict setObject:contactsData[i][@"Key"] forKey:@"Key"];
            [itemmutablearray addObject:tempDict];
        }
        firstLetterArray = [ChineseString mIndexArray:[itemmutablearray valueForKey:@"RemarkName"]];
        letterResultArray = [ChineseString mLetterSortArray:itemmutablearray];
        [mTableView reloadData];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
    [mTableView.header endRefreshing];
}

// UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + firstLetterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return [letterResultArray[section - 1] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ContactsCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.photoIv.image = [UIImage imageNamed:@"32"];
            cell.nameLbl.text = @"添加好友";
        }else if (indexPath.row == 1){
            cell.photoIv.image = [UIImage imageNamed:@"33"];
            cell.nameLbl.text = @"发起群聊";
        }else{
            cell.photoIv.image = [UIImage imageNamed:@"users32"];
            cell.nameLbl.text = @"群聊";
        }
    }else{
        cell.photoIv.image = [UIImage imageNamed:@"default_photo"];
        cell.nameLbl.text = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).string;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 20;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return firstLetterArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return firstLetterArray[section - 1];
}

// UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NewFriendsViewController *newFriendVC = [[NewFriendsViewController alloc] init];
            newFriendVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:newFriendVC animated:true];
        }else if (indexPath.row == 1){
            LaunchGroupChatViewController *launchGroupChatVC = [[LaunchGroupChatViewController alloc] init];
            launchGroupChatVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:launchGroupChatVC animated:true];
        }else if (indexPath.row == 2){
            GroupChatViewController *groupChatVC = [[GroupChatViewController alloc] init];
            groupChatVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:groupChatVC animated:true];
        }
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = true;
        detailsVC.iFlag = @"1";
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

@end
