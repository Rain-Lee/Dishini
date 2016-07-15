//
//  SelectFriendOrGroupViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/14.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SelectFriendOrGroupViewController.h"
#import "MJRefresh.h"
#import "ChineseString.h"
#import "ContactsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ChatRoomViewController.h"
#import "LaunchGroupChatViewController.h"
#import "GroupChatViewController.h"

#define SelectFriendOrGroupTableViewCell @"SelectFriendOrGroupTableViewCell"
#define CellIdentifier @"CellIdentifier"

@interface SelectFriendOrGroupViewController ()<UITextFieldDelegate>{
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
    
    // data
    NSMutableArray *firstLetterArray;
    NSMutableArray *letterResultArray;
    NSString *filterValue;
    NSMutableArray *friendArray;
    NSMutableArray *oFriendArray;
}

@end

@implementation SelectFriendOrGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"选择联系人"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

- (void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerNib:[UINib nibWithNibName:SelectFriendOrGroupTableViewCell bundle:nil] forCellReuseIdentifier:SelectFriendOrGroupTableViewCell];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mTableView.header beginRefreshing];
}

- (void)refreshData{
    filterValue = @"";
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendsCallBack:"];
    [dataProvider getFriends:[Toolkit getStringValueByKey:@"Id"]];
}

- (void)getFriendsCallBack:(id)dict{
    oFriendArray = [[NSMutableArray alloc] init];
    firstLetterArray = [[NSMutableArray alloc] init];
    letterResultArray = [[NSMutableArray alloc] init];
    if ([dict[@"code"] intValue] == 200) {
        NSMutableArray *oFriendArrayNew = [[NSMutableArray alloc] init];
        oFriendArrayNew = dict[@"data"];
        for (int i = 0; i < oFriendArrayNew.count; i++) {
            NSMutableDictionary *tempDict;
            tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArrayNew[i][@"Value"]];
            
            if ([[Toolkit judgeIsNull:tempDict[@"RemarkName"]] isEqual:@""]) {
                tempDict[@"RemarkName"] = tempDict[@"NicName"];
            }
            [oFriendArray addObject:tempDict];
        }
        NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
        for (int i=0; i<oFriendArray.count; i++) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i]];
            [tempDict setObject:oFriendArray[i][@"Key"] forKey:@"Key"];
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

-(void)mReloadData:(NSString *)filterStr{
    filterValue = filterStr;
    NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
    if ([filterStr isEqual:@""]) {
        friendArray = [[NSMutableArray alloc] initWithArray:oFriendArray];
        for (int i=0; i<friendArray.count; i++) {
            [itemmutablearray addObject:friendArray[i]];
        }
    }else{
        for (int i = 0; i < oFriendArray.count; i++) {
            NSString *itemName = oFriendArray[i][@"RemarkName"];
            if ([itemName isEqual:@""]) {
                itemName = oFriendArray[i][@"NicName"];
            }
            if ([itemName containsString:filterStr]) {
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i]];
                [itemmutablearray addObject:tempDict];
            }
        }
    }
    @try {
        firstLetterArray = [ChineseString IndexArray:[itemmutablearray valueForKey:@"RemarkName"]];
        letterResultArray = [ChineseString mLetterSortArray:itemmutablearray];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    [mTableView reloadData];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *itemView in cell.contentView.subviews) {
            [itemView removeFromSuperview];
        }
        // searchTxt
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
        searchTxt.delegate = self;
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.placeholder = @"请输入名称";
        searchTxt.text = filterValue;
        [cell.contentView addSubview:searchTxt];
        // searchIv
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(searchTxt.frame) - 22) / 2, 35, 22)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        
        return cell;
    }else{
        ContactsTableViewCell *cell = (ContactsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SelectFriendOrGroupTableViewCell forIndexPath:indexPath];
        if (indexPath.section == 0) {
            if (indexPath.row == 1){
                cell.photoIv.image = [UIImage imageNamed:@"33"];
                cell.nameLbl.text = @"发起群聊";
            }else{
                cell.photoIv.image = [UIImage imageNamed:@"users32"];
                cell.nameLbl.text = @"群聊";
            }
        }else{
            NSLog(@"%@",letterResultArray);
            NSString *imagePhoto = [NSString stringWithFormat:@"%@%@",Kimg_path,((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).photoImg];
            [cell.photoIv sd_setImageWithURL:[NSURL URLWithString:imagePhoto] placeholderImage:[UIImage imageNamed:@"default_photo"]];
            cell.nameLbl.text = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).string;
        }
        return cell;
    }
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
        if (indexPath.row == 0){
            
        }else if (indexPath.row == 1) {
            LaunchGroupChatViewController *launchGroupChatVC = [[LaunchGroupChatViewController alloc] init];
            launchGroupChatVC.hidesBottomBarWhenPushed = true;
            launchGroupChatVC.iFlag = @"2";
            [self.navigationController pushViewController:launchGroupChatVC animated:true];
        }else{
            GroupChatViewController *groupChatVC = [[GroupChatViewController alloc] init];
            groupChatVC.iFlag = @"2";
            [self.navigationController pushViewController:groupChatVC animated:true];
        }
    }else{
        ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
        chatRoomVC.iFlag = @"2";
        chatRoomVC.conversationType = ConversationType_PRIVATE;
        chatRoomVC.targetId = [NSString stringWithFormat:@"%@",((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID];
        chatRoomVC.title = [NSString stringWithFormat:@"%@",((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).string];
        [self.navigationController pushViewController:chatRoomVC animated:true];
    }
}

@end
