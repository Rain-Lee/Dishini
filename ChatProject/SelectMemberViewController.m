//
//  SelectMemberViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/13.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "SelectMemberViewController.h"
#import "MJRefresh.h"
#import "ChineseString.h"
#import "GroupChatViewController.h"
#import "ChatRoomViewController.h"
#import "UIImageView+WebCache.h"

#define CellIdentifier @"CellIdentifier"

@interface SelectMemberViewController ()<UITextFieldDelegate>{
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

@implementation SelectMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"选择联系人"];
    [self addLeftButton:@"left"];
    if ([_iFlag isEqual:@"1"]) {
        // jia
        [self addRightbuttontitle:@"确定"];
    }else{
        // jian
        [self addRightbuttontitle:@"删除"];
    }
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [searchTxt resignFirstResponder];
}

-(void)clickRightButton:(UIButton *)sender{
    if ([_iFlag isEqual:@"1"]) {
        // jia
        if (selectFriends.count > 0) {
            NSString *selectFriendStr = @"";
            for (NSString *item in selectFriends) {
                selectFriendStr = [NSString stringWithFormat:@"%@A%@",selectFriendStr,item];
            }
            selectFriendStr = [selectFriendStr substringFromIndex:1];
            [Toolkit showWithStatus:@"加载中..."];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"yaoqingCallBack:"];
            [dataProvider yaoQing:selectFriendStr andTeamId:_groupId];
        }
    }else{
        // jian
        if (selectFriends.count > 0) {
            NSString *selectFriendStr = @"";
            for (NSString *item in selectFriends) {
                selectFriendStr = [NSString stringWithFormat:@"%@A%@",selectFriendStr,item];
            }
            selectFriendStr = [selectFriendStr substringFromIndex:1];
            [Toolkit showWithStatus:@"加载中..."];
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"yaoqingCallBack:"];
            [dataProvider tiChu:selectFriendStr andTeamId:_groupId];
        }
    }
}

-(void)yaoqingCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        if ([self.delegate respondsToSelector:@selector(selectMemberRefreshData)]) {
            [self.delegate selectMemberRefreshData];
        }
        [self.navigationController popViewControllerAnimated:true];
    }else{
        [Toolkit showErrorWithStatus:dict[@"data"]];
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
    if ([_iFlag isEqual:@"1"]) {
        [dataProvider getFriends:[Toolkit getStringValueByKey:@"Id"]];
    }else{
        [dataProvider getGroupMember:_groupId andUserId:[Toolkit getStringValueByKey:@"Id"]];
    }
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
            if ([_iFlag isEqual:@"1"]) {
                tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArrayNew[i][@"Value"]];
            }else{
                tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArrayNew[i]];
            }
            
            if ([[Toolkit judgeIsNull:tempDict[@"RemarkName"]] isEqual:@""]) {
                tempDict[@"RemarkName"] = tempDict[@"NicName"];
            }
            [oFriendArray addObject:tempDict];
        }
        
        if ([_iFlag isEqual:@"1"]) {
            NSMutableArray *oFriendArrayCopy = [[NSMutableArray alloc] init];
            for (int i = 0; i < oFriendArray.count; i++) {
                if (![_idList containsObject:oFriendArray[i][@"Key"]]) {
                    [oFriendArrayCopy addObject:oFriendArray[i]];
                }
            }
            oFriendArray = oFriendArrayCopy;
        }else{
            NSMutableArray *oFriendArrayCopy = [[NSMutableArray alloc] init];
            for (int i = 0; i < oFriendArray.count; i++) {
                if (![[Toolkit getStringValueByKey:@"Id"] isEqual:[Toolkit judgeIsNull:oFriendArray[i][@"MemnerId"]]]) {
                    [oFriendArrayCopy addObject:oFriendArray[i]];
                }
            }
            oFriendArray = oFriendArrayCopy;
        }
        NSMutableArray * itemmutablearray=[[NSMutableArray alloc] init];
        for (int i=0; i<oFriendArray.count; i++) {
            if ([_iFlag isEqual:@"1"]){
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i]];
                [tempDict setObject:oFriendArray[i][@"Key"] forKey:@"Key"];
                [itemmutablearray addObject:tempDict];
            }else{
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:oFriendArray[i]];
                [tempDict setObject:oFriendArray[i][@"Id"] forKey:@"Key"];
                [itemmutablearray addObject:tempDict];
            }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + firstLetterArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
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
    if (indexPath.section > 0){
        if (selectFriends == nil) {
            selectFriends = [[NSMutableArray alloc] init];
        }
        if ([_iFlag isEqual:@"1"]) {
            NSString *friendId = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID;
            if ([selectFriends containsObject:friendId]) {
                [selectFriends removeObject:friendId];
            }else{
                [selectFriends addObject:friendId];
            }
        }else{
            NSString *friendId = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID;
            if ([selectFriends containsObject:friendId]) {
                [selectFriends removeObject:friendId];
            }else{
                [selectFriends addObject:friendId];
            }
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
