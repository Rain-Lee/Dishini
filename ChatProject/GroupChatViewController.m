//
//  GroupChatViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/29.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GroupChatViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "ChatRoomViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface GroupChatViewController ()<UITextFieldDelegate>{
    // view
    UITableView *mTableView;
    UITextField *searchTxt;
    
    // data
    NSMutableArray *groupData;
    NSMutableArray *filterGroupData;
}

@end

@implementation GroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"群聊"];
    [self addLeftButton:@"left"];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataNotification) name:@"refreshDataNotification" object:nil];
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
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mTableView.header beginRefreshing];
}

-(void)refreshDataNotification{
    [mTableView.header beginRefreshing];
}

- (void)refreshData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGroupCallBack:"];
    [dataProvider selectAllTeamByUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getGroupCallBack:(id)dict{
    [mTableView.header endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        groupData = [[NSMutableArray alloc] init];
        groupData = dict[@"data"];
        filterGroupData = groupData;
        [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return filterGroupData.count;
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
        searchTxt.returnKeyType = UIReturnKeySearch;
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
        NSString *imagePath = [NSString stringWithFormat:@"%@%@",Kimg_path,filterGroupData[indexPath.row][@"ImagePath"]];
        [photoIv sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"users32"]];
        [cell.contentView addSubview:photoIv];
        
        // nameLbl
        UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 5, 0, 200, CGRectGetHeight(cell.frame))];
        nameLbl.textAlignment = NSTextAlignmentLeft;
        nameLbl.text = filterGroupData[indexPath.row][@"Name"];
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
    if (indexPath.section == 1) {
        //显示聊天会话界面
        ChatRoomViewController *chat = [[ChatRoomViewController alloc]init];
        chat.iFlag = _iFlag;
        chat.conversationType = ConversationType_GROUP;
        chat.targetId = [filterGroupData[indexPath.row][@"Id"] stringValue];
        chat.title = filterGroupData[indexPath.row][@"Name"];
        [self.navigationController pushViewController:chat animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([searchTxt.text isEqual:@""]) {
        filterGroupData = groupData;
    }else{
        filterGroupData = [[NSMutableArray alloc] init];
        for (NSDictionary *itemDict in groupData) {
            NSString *nameStr = [NSString stringWithFormat:@"%@",itemDict[@"Name"]];
            if ([nameStr containsString:searchTxt.text]) {
                [filterGroupData addObject:itemDict];
            }
        }
    }
    [mTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    return true;
}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return NO;
//    }else{
//        return YES;
//    }
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [Toolkit showWithStatus:@"请稍等..."];
//        DataProvider *dataProvider = [[DataProvider alloc] init];
//        [dataProvider setDelegateObject:self setBackFunctionName:@"DelBackCall:"];
//        [dataProvider dismissTeam:[Toolkit getStringValueByKey:@"Id"] andGroupId:[filterGroupData[indexPath.row][@"Id"] stringValue]];
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//    }
//}
//
//-(void)DelBackCall:(id)dict{
//    [SVProgressHUD dismiss];
//    if ([dict[@"code"] intValue] == 200) {
//        [mTableView.header beginRefreshing];
//    }else{
//        [Toolkit showErrorWithStatus:@"删除失败"];
//    }
//}

@end
