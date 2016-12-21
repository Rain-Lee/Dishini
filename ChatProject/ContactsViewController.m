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
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "WZLBadgeImport.h"
#import "UIView+Frame.h"
#import "ErWeiMaViewController.h"
#import "OnlineChongzhiViewController.h"

#define ContactsCell @"ContactsTableViewCell"

@interface ContactsViewController (){
    
    // view
    UITableView *mTableView;
    UIView *moreSettingBackView;
    
    // data
    NSMutableArray *firstLetterArray;
    NSMutableArray *contactsData;
    NSMutableArray *letterResultArray;
    NSString *currentDelId;
    NSInteger applyNum;
}

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"通讯录"];
    [self addRightButton:@"Plus"];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mRefreshData) name:@"mRefreshData" object:nil];
}

-(void)clickRightButton:(UIButton *)sender{
    if(moreSettingBackView.hidden == YES){
        moreSettingBackView.hidden = NO;
        [self positionShowView:moreSettingBackView];
    }else{
        [self positionDismissView:moreSettingBackView];
    }
}

#define SHOW_ANIM_KEY   @"showSettingView"
#define DISMISS_ANIM_KEY   @"dismissSettingView"
-(void)positionShowView:(UIView *)tempView
{
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2), Header_Height)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    //tempView.layer.delegate = self;
    group.delegate= self;
    [moreSettingBackView.layer addAnimation:group forKey:SHOW_ANIM_KEY];
}

-(void)positionDismissView:(UIView *)tempView
{
    
    
    CABasicAnimation *scale=[CABasicAnimation animationWithKeyPath:@"transform"];
    [scale setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1, 1.0)]];
    [scale setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.0, 1.0)]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                                (moreSettingBackView.frame.size.height/2 + moreSettingBackView.frame.origin.y))];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake((moreSettingBackView.frame.origin.x+moreSettingBackView.frame.size.width/2),
                                                              Header_Height)];
    //动画执行后保持显示状态 但是属性值不会改变 只会保持显示状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    animation.autoreverses = YES;//动画返回
    
    CAAnimationGroup *group=[CAAnimationGroup animation];
    [group setAnimations:[NSArray arrayWithObjects:scale,animation, nil]];
    [group setDuration:0.5];
    //    animation.repeatCount = MAXFLOAT;//重复
    group.delegate= self;
    [tempView.layer addAnimation:group forKey:DISMISS_ANIM_KEY];
    
    [self performSelector:@selector(viewSetHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5 - 0.1];
}

-(void)viewSetHidden:(id)info
{
    moreSettingBackView.hidden = YES;
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
    
//    UIImage *imgBtn = [UIImage imageNamed:strImage];
//    _imgRight.image = imgBtn;
//    _imgRight.contentMode = UIViewContentModeScaleAspectFill;
//    [_imgRight setFrame:CGRectMake(_btnRight.frame.origin.x + 25, _btnRight.frame.origin.y,imgBtn.size.width , imgBtn.size.height )];
//    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 42, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 18) / 2, 18, 18)];
    [searchBtn setImage:[UIImage imageNamed:@"zoom"] forState:UIControlStateNormal];
    searchBtn.contentMode = UIViewContentModeScaleAspectFit;
    [_topView addSubview:searchBtn];
    [self.view bringSubviewToFront:searchBtn];
    UIButton *searchBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 42, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 18) / 2, 35, 44)];
    [searchBtn2 addTarget:self action:@selector(searchBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:searchBtn2];
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 132)];
    moreSettingBackView.backgroundColor = navi_bar_bg_color;
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/3)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [newBtn setTitle:@"扫一扫" forState:UIControlStateNormal];
    newBtn.tag = 1;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/3, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/3, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/3)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [delBtn setTitle:@"在线充值" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = 2;
    
    UIView *lineView3 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/3 * 2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView3.backgroundColor = Separator_Color;
    UIButton *serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/3 * 2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/3)];
    [serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    serviceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [serviceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    serviceBtn.tag = 3;
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:serviceBtn];
    [moreSettingBackView addSubview:lineView2];
    [moreSettingBackView addSubview:lineView3];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;
}

-(void)searchBtnEvent{
    NewFriendsViewController *newFriendVC = [[NewFriendsViewController alloc] init];
    newFriendVC.hidesBottomBarWhenPushed = true;
    newFriendVC.isDefaultSearch = false;
    [self.navigationController pushViewController:newFriendVC animated:true];
}

-(void)btnClick:(UIButton *)sender{
    [self positionDismissView:moreSettingBackView];
    
    if (sender.tag == 1){
        ErWeiMaViewController * erweima = [[ErWeiMaViewController alloc] init];
        erweima.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:erweima animated:true];
    }else if (sender.tag == 2){
        OnlineChongzhiViewController *onlineChongzhiVC = [[OnlineChongzhiViewController alloc] init];
        onlineChongzhiVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:onlineChongzhiVC animated:true];
    }else{
        [self getData];
    }
}

-(void)getData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDataCallBack:"];
    [dataProvider aboutUs];
}

-(void)getDataCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit makeCall:dict[@"data"][@"TelePhone"]];
    }
}

-(void)getApplyData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getApplyCallBack:"];
    [dataProvider selectApplyList:@"0" andMaximumRows:@"10000" andUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getApplyCallBack:(id)dict{
    NSArray *resultData = [NSArray arrayWithArray:dict[@"data"]];
    applyNum = resultData.count;
    [mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            if ([[Toolkit judgeIsNull:tempDict[@"RemarkName"]] isEqual:@""]) {
                tempDict[@"RemarkName"] = tempDict[@"NicName"];
            }
            [itemmutablearray addObject:tempDict];
        }
        firstLetterArray = [ChineseString mIndexArray:[itemmutablearray valueForKey:@"RemarkName"]];
        letterResultArray = [ChineseString mLetterSortArray:itemmutablearray];
        [mTableView reloadData];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
    [mTableView.header endRefreshing];
    [self getApplyData];
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
    [cell.nameLbl showBadgeWithStyle:WBadgeStyleNumber value:0 animationType:WBadgeAnimTypeNone];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.photoIv.image = [UIImage imageNamed:@"32"];
            cell.nameLbl.text = @"添加好友";
            [cell.nameLbl showBadgeWithStyle:WBadgeStyleNumber value:applyNum animationType:WBadgeAnimTypeNone];
            cell.nameLbl.badge.x = cell.nameLbl.badge.x - 160;
            cell.nameLbl.badge.y = 0;
        }else if (indexPath.row == 1){
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
            newFriendVC.isDefaultSearch = false;
            [self.navigationController pushViewController:newFriendVC animated:true];
        }else if (indexPath.row == 1){
            LaunchGroupChatViewController *launchGroupChatVC = [[LaunchGroupChatViewController alloc] init];
            launchGroupChatVC.hidesBottomBarWhenPushed = true;
            launchGroupChatVC.iFlag = @"1";
            [self.navigationController pushViewController:launchGroupChatVC animated:true];
        }else if (indexPath.row == 2){
            GroupChatViewController *groupChatVC = [[GroupChatViewController alloc] init];
            groupChatVC.iFlag = @"1";
            groupChatVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:groupChatVC animated:true];
        }
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = true;
        detailsVC.userId = ((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID;
        detailsVC.iFlag = @"1";
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    }else{
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).string);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [Toolkit showWithStatus:@"正在删除"];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"DelBackCall:"];
        currentDelId = [NSString stringWithFormat:@"%@",((ChineseString *)letterResultArray[indexPath.section - 1][indexPath.row]).friendID];
        [dataProvider deleteFriend:[Toolkit getStringValueByKey:@"Id"] andFriendId:currentDelId];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

-(void)DelBackCall:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showSuccessWithStatus:@"删除成功"];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:currentDelId];
        [mTableView.header beginRefreshing];
    }else{
        [Toolkit showErrorWithStatus:@"删除失败"];
    }
}

-(void)mRefreshData{
    [self refreshData];
}

@end
