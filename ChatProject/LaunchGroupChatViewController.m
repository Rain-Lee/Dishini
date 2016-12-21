//
//  LaunchGroupChatViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/29.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "LaunchGroupChatViewController.h"
#import "MJRefresh.h"
#import "ChineseString.h"
#import "GroupChatViewController.h"
#import "UIImageView+WebCache.h"
#import "CreateGroupViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface LaunchGroupChatViewController ()<UITextFieldDelegate>{
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
    
    // data
    NSMutableArray *oFriendArray;
    NSMutableArray *friendArray;
    NSMutableArray *firstLetterArray;
    NSMutableArray *letterResultArray;
    NSMutableArray *selectFriends;
    NSMutableArray *filterGroupData;
    NSString *filterValue;
}

@end

@implementation LaunchGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"选择联系人"];
    [self addLeftButton:@"left"];
    [self addRightbuttontitle:@"下一步"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    if (selectFriends.count > 0) {
        NSString *selectFriendStr = [Toolkit getStringValueByKey:@"Id"];
        for (NSString *item in selectFriends) {
            selectFriendStr = [NSString stringWithFormat:@"%@A%@",selectFriendStr,item];
        }
        
        CreateGroupViewController *createGroupVC = [[CreateGroupViewController alloc] init];
        createGroupVC.iFlag = _iFlag;
        createGroupVC.selectFriendStr = selectFriendStr;
        [self.navigationController pushViewController:createGroupVC animated:true];
    }
}

-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    mTableView.sectionIndexBackgroundColor = [UIColor clearColor];
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
        oFriendArray = dict[@"data"];
        NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
        for (int i=0; i<oFriendArray.count; i++) {
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i][@"Value"]];
            [tempDict setObject:oFriendArray[i][@"Key"] forKey:@"Key"];
            if ([[Toolkit judgeIsNull:tempDict[@"RemarkName"]] isEqual:@""]) {
                tempDict[@"RemarkName"] = tempDict[@"NicName"];
            }
            [itemmutablearray addObject:tempDict];
        }
        firstLetterArray = [ChineseString mIndexArray:[itemmutablearray valueForKey:@"RemarkName"]];
        letterResultArray = [ChineseString mLetterSortArray:itemmutablearray];
        [mTableView reloadData];
    }
    [mTableView.header endRefreshing];
}

-(void)mReloadData:(NSString *)filterStr{
    filterValue = filterStr;
    NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
    if ([filterStr isEqual:@""]) {
        friendArray = [[NSMutableArray alloc] initWithArray:oFriendArray];
        for (int i=0; i<friendArray.count; i++) {
            [itemmutablearray addObject:friendArray[i][@"Value"]];
        }
    }else{
        for (int i = 0; i < oFriendArray.count; i++) {
            NSString *itemName = oFriendArray[i][@"Value"][@"RemarkName"];
            if ([itemName isEqual:@""]) {
                itemName = oFriendArray[i][@"Value"][@"NicName"];
            }
            if ([itemName containsString:filterStr]) {
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i][@"Value"]];
                if ([[Toolkit judgeIsNull:tempDict[@"RemarkName"]] isEqual:@""]) {
                    tempDict[@"RemarkName"] = tempDict[@"NicName"];
                }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + firstLetterArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return [letterResultArray[section - 1] count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
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
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // titleLbl
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, CGRectGetHeight(cell.frame))];
            titleLbl.text = @"选择一个群";
            [cell.contentView addSubview:titleLbl];
        }
    }else{
        // checkIv
        UIImageView *checkIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CGRectGetHeight(searchTxt.frame) - 25) / 2, 25, 25)];
        checkIv.contentMode = UIViewContentModeScaleAspectFit;
        NSString *friendId = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID;
        if ([selectFriends containsObject:friendId]) {
            checkIv.image = [UIImage imageNamed:@"ati"];
        }else{
            checkIv.image = [UIImage imageNamed:@"w6"];
        }
        [cell.contentView addSubview:checkIv];
        
        // photoIv
        UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(checkIv.frame) + 7, (CGRectGetHeight(cell.frame) - 40) / 2, 40, 40)];
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).photoImg];
        [photoIv sd_setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:[UIImage imageNamed:@"default_photo"]];
        [cell.contentView addSubview:photoIv];
        
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 5, 0, 200, CGRectGetHeight(cell.frame))];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).string;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0){
        if (indexPath.row == 1) {
            GroupChatViewController *groupChatVC = [[GroupChatViewController alloc] init];
            groupChatVC.iFlag = @"1";
            [self.navigationController pushViewController:groupChatVC animated:true];
        }
    }else{
        if (selectFriends == nil) {
            selectFriends = [[NSMutableArray alloc] init];
        }
        NSString *friendId = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID;
        if ([selectFriends containsObject:friendId]) {
            [selectFriends removeObject:friendId];
        }else{
            [selectFriends addObject:friendId];
        }
        
        [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self mReloadData:searchTxt.text];
    return true;
}

@end
