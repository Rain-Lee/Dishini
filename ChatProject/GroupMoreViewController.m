//
//  GroupMoreViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/12.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "GroupMoreViewController.h"
#import "GroupMoreCell.h"
#import "UIImageView+WebCache.h"
#import "MyFooterView.h"
#import "MJRefresh.h"
#import "DetailsViewController.h"
#import "SelectMemberViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "GroupNameViewController.h"
#import "ChatRecordSearchViewController.h"
#import "ChatRoomViewController.h"
#import "GroupGonggaoViewController.h"
#import "TousuViewController.h"

#define cellIdentifier  @"GroupMoreCell"
#define cellIdentifierTwo  @"cellIdentifierTwo"
#define headCellIdentifier  @"HeadCellIdentifier"
#define footerCellIdentifier  @"FooterCellIdentifier"

@interface GroupMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SelectMemberDelegate, GroupNameDelegate>{
    // view
    UICollectionView *mCollectionView;
    
    // data
    NSMutableArray *groupMemberData;
    BOOL isManager;
    NSMutableArray *idList;
    BOOL currentState;
}

@end

@implementation GroupMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"群组信息"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//-(void)editGroupCallBack:(id)dict{
//    [SVProgressHUD dismiss];
//    if ([dict[@"code"] intValue] == 200) {
//        [Toolkit showSuccessWithStatus:@"修改群名称成功"];
//        [self.navigationController popViewControllerAnimated:true];
//    }
//}

-(void)initView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //layout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 * 10) / 4, (SCREEN_WIDTH - 5 * 10) / 4 + 20);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height) collectionViewLayout:layout];
    mCollectionView.backgroundColor = [UIColor whiteColor];
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    [self.view addSubview:mCollectionView];
    [mCollectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifierTwo];
    
    // header
    //[mCollectionView registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCellIdentifier];
    // footer
    [mCollectionView registerClass:[MyFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerCellIdentifier];
    
    mCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mCollectionView.header beginRefreshing];
}

- (void)refreshData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getGroupCallBack:"];
    [dataProvider getGroupMember:_groupId andUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getGroupCallBack:(id)dict{
    [mCollectionView.header endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        groupMemberData = [[NSMutableArray alloc] init];
        groupMemberData = dict[@"data"];
        idList = [[NSMutableArray alloc] init];
        for (NSDictionary *itemDict in groupMemberData) {
            [idList addObject:itemDict[@"MemnerId"]];
        }
        if ([[Toolkit judgeIsNull:dict[@"BuilderId"]] isEqual:[Toolkit getStringValueByKey:@"Id"]]){
            isManager = true;
        }else{
            isManager = false;
        }
        
        self.groupName = [Toolkit judgeIsNull:dict[@"data1"]];
        currentState = [[Toolkit judgeIsNull:dict[@"data2"]] isEqual:@"1"] ? true : false;
        
        [mCollectionView reloadData];
    }
}

-(void)quitBtn:(UIButton *)sender{
    if (sender.tag == 1) { // 解散群组
        [Toolkit showWithStatus:@"请稍等..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"DelBackCall:"];
        [dataProvider dismissTeam:[Toolkit getStringValueByKey:@"Id"] andGroupId:_groupId];
    }else{ // 退出群组
        [Toolkit showWithStatus:@"加载中..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"DelBackCall:"];
        NSString *mmId;
        for (NSDictionary *itemDict in groupMemberData) {
            if ([[itemDict[@"MemnerId"] stringValue] isEqual:[Toolkit getStringValueByKey:@"Id"]]) {
                mmId = itemDict[@"Id"];
                break;
            }
        }
        [dataProvider tiChu:mmId andTeamId:_groupId];
    }
}

-(void)DelBackCall:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initChatListData" object:nil];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:_groupId];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:true];
    }else{
        [Toolkit showErrorWithStatus:@"删除失败"];
    }
}

-(void)messageEvent:(UISwitch *)sender{
    currentState = sender.on;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"messageStateCallBacl:"];
    [dataProvider editIsClose:[Toolkit getUserID] andTeamid:_groupId andisclose:[NSString stringWithFormat:@"%@",currentState ? @"1" : @"0"]];
}

-(void)messageStateCallBacl:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
//        [[RCIM sharedRCIM] setDisableMessageNotificaiton:currentState];
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:_groupId isBlocked:currentState success:nil error:nil];
    }else{
        [Toolkit showErrorWithStatus:dict[@"error"]];
    }
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 12;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 1 || section == 2 || section == 4 || section == 6 || section == 8 || section == 10) {
        return 1;
    }else if (section == 3){
        return 2;
    }else if (section == 5){
        return 3;
    }else if (section == 7){
        return 2;
    }else if (section == 9){
        return 1;
    }else if (section == 11){
        return 1;
    }else{
        return groupMemberData.count + (isManager ? 2 : 1);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GroupMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        @try {
            if (isManager && indexPath.item >= groupMemberData.count){
                if (indexPath.row == groupMemberData.count) {
                    cell.photoIv.image = [UIImage imageNamed:@"jia"];
                    cell.nameLbl.text = @"";
                }else{
                    cell.photoIv.image = [UIImage imageNamed:@"jian"];
                    cell.nameLbl.text = @"";
                }
            }else if (!isManager && indexPath.item == groupMemberData.count){
                cell.photoIv.image = [UIImage imageNamed:@"jia"];
                cell.nameLbl.text = @"";
            }else{
                NSString *photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,groupMemberData[indexPath.item][@"PhotoPath"]];
                [cell.photoIv sd_setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:[UIImage imageNamed:@"default_photo"]];
                cell.photoIv.layer.masksToBounds = true;
                cell.photoIv.layer.cornerRadius = 6;
                cell.nameLbl.text = [groupMemberData[indexPath.item][@"RemarkName"] isEqual:@""] ? groupMemberData[indexPath.item][@"NicName"] : groupMemberData[indexPath.item][@"RemarkName"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            return cell;
        }
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierTwo forIndexPath:indexPath];
        for (UIView *itemView in cell.contentView.subviews) {
            [itemView removeFromSuperview];
        }
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.section == 1) {
            // lineView
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
            [cell.contentView addSubview:lineView];
            // titleLbl
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 15, cell.frame.size.height - 1)];
            titleLbl.text = [NSString stringWithFormat:@"全部群成员(%lu)",(unsigned long)groupMemberData.count];
            titleLbl.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:titleLbl];
        }else if (indexPath.section == 2){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }else if (indexPath.section == 3){
            if (indexPath.row == 0) {
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, cell.frame.size.height)];
                titleLbl.text = [NSString stringWithFormat:@"群名称"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
                // nameLbl
                UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 250, 0, 250, cell.frame.size.height)];
                nameLbl.font = [UIFont systemFontOfSize:15];
                nameLbl.textAlignment = NSTextAlignmentRight;
                nameLbl.text = _groupName;
                [cell.contentView addSubview:nameLbl];
            }else{
                // lineView
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
                lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
                [cell.contentView addSubview:lineView];
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 15, cell.frame.size.height - 1)];
                titleLbl.text = [NSString stringWithFormat:@"群公告"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
            }
        }else if (indexPath.section == 4){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }else if (indexPath.section == 5){
            if (indexPath.row == 0) {
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, cell.frame.size.height)];
                titleLbl.text = [NSString stringWithFormat:@"消息免打扰"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
                // messageSwitch
                UISwitch *messageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 50, (cell.frame.size.height - 25) / 2, 50, 25)];
                messageSwitch.on = currentState;
                [messageSwitch addTarget:self action:@selector(messageEvent:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:messageSwitch];
            }else if (indexPath.row == 1){
                // lineView
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
                lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
                [cell.contentView addSubview:lineView];
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 15, cell.frame.size.height - 1)];
                titleLbl.text = [NSString stringWithFormat:@"查找聊天记录"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
            }else{
                // lineView
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
                lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
                [cell.contentView addSubview:lineView];
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 15, cell.frame.size.height - 1)];
                titleLbl.text = [NSString stringWithFormat:@"投诉"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
            }
        }else if (indexPath.section == 6){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }else if (indexPath.section == 7){
            if (indexPath.row == 0) {
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, cell.frame.size.height)];
                titleLbl.text = [NSString stringWithFormat:@"查余额"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
            }else{
                // lineView
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, 1)];
                lineView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
                [cell.contentView addSubview:lineView];
                // titleLbl
                UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, SCREEN_WIDTH - 15, cell.frame.size.height - 1)];
                titleLbl.text = [NSString stringWithFormat:@"差走势"];
                titleLbl.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:titleLbl];
            }
        }else if (indexPath.section == 8){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }else if (indexPath.section == 9){
            // titleLbl
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15, cell.frame.size.height)];
            titleLbl.text = [NSString stringWithFormat:@"清空聊天记录"];
            titleLbl.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:titleLbl];
        }else if (indexPath.section == 10){
            cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        }else{
            UIButton *_quitBtn = [[UIButton alloc]init];
            _quitBtn.frame = CGRectMake(15, 15, cell.frame.size.width - 30, 44);
            _quitBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.00 blue:0.03 alpha:1.00];
            [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _quitBtn.layer.masksToBounds = true;
            _quitBtn.layer.cornerRadius = 6;
            if (isManager) {
                [_quitBtn setTitle:@"退出并删除" forState:UIControlStateNormal];
                _quitBtn.tag = 1;
                [_quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [_quitBtn setTitle:@"退出" forState:UIControlStateNormal];
                _quitBtn.tag = 2;
                [_quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell.contentView addSubview:_quitBtn];
        }
        return cell;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((SCREEN_WIDTH - 5 * 10) / 4, (SCREEN_WIDTH - 5 * 10) / 4 + 20);
    }else if (indexPath.section == 1 || indexPath.section == 3 || indexPath.section == 5 || indexPath.section == 7 || indexPath.section == 9){
        return CGSizeMake(SCREEN_WIDTH, 50);
    }else if (indexPath.section == 11){
        return CGSizeMake(SCREEN_WIDTH, 90);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 12);
    }
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }else{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (isManager && indexPath.item >= groupMemberData.count){
            if (indexPath.item == groupMemberData.count) {
                // jia
                SelectMemberViewController *selectMemberVC = [[SelectMemberViewController alloc] init];
                selectMemberVC.delegate = self;
                selectMemberVC.iFlag = @"1";
                selectMemberVC.groupId = _groupId;
                selectMemberVC.idList = idList;
                [self.navigationController pushViewController:selectMemberVC animated:true];
            }else{
                // jian
                SelectMemberViewController *selectMemberVC = [[SelectMemberViewController alloc] init];
                selectMemberVC.delegate = self;
                selectMemberVC.iFlag = @"2";
                selectMemberVC.groupId = _groupId;
                selectMemberVC.idList = idList;
                [self.navigationController pushViewController:selectMemberVC animated:true];
            }
        }else if (!isManager && indexPath.item == groupMemberData.count){
            // jia
            SelectMemberViewController *selectMemberVC = [[SelectMemberViewController alloc] init];
            selectMemberVC.delegate = self;
            selectMemberVC.iFlag = @"1";
            selectMemberVC.groupId = _groupId;
            selectMemberVC.idList = idList;
            [self.navigationController pushViewController:selectMemberVC animated:true];
        }else{
            // 正常，点击的是头像
            DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
            detailsVC.hidesBottomBarWhenPushed = true;
            detailsVC.userId = groupMemberData[indexPath.item][@"MemnerId"];
            detailsVC.iFlag = @"1";
            [self.navigationController pushViewController:detailsVC animated:true];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0){
            if (isManager) {
                GroupNameViewController *groupNameVC = [[GroupNameViewController alloc] init];
                groupNameVC.delegate = self;
                groupNameVC.nameStr = _groupName;
                groupNameVC.groupId = _groupId;
                [self.navigationController pushViewController:groupNameVC animated:true];
            }
        }else{
            GroupGonggaoViewController *groupGonggaoVC = [[GroupGonggaoViewController alloc] init];
            groupGonggaoVC.groupId = _groupId;
            groupGonggaoVC.isManager = isManager ? @"1" : @"0";
            [self.navigationController pushViewController:groupGonggaoVC animated:true];
        }
    }else if (indexPath.section == 5){
        if (indexPath.row == 1) {
            ChatRecordSearchViewController *chatRecordSearchVC = [[ChatRecordSearchViewController alloc] init];
            chatRecordSearchVC.groupId = _groupId;
            [self.navigationController pushViewController:chatRecordSearchVC animated:true];
        }else if (indexPath.row == 2){
            TousuViewController *tousuVC = [[TousuViewController alloc] init];
            tousuVC.groupId = _groupId;
            [self.navigationController pushViewController:tousuVC animated:true];
        }
    }else if(indexPath.section == 7){
        if (indexPath.row == 0) {
            ChatRoomViewController *chat = [[ChatRoomViewController alloc]init];
            chat.iFlag = @"4";
            chat.conversationType = ConversationType_GROUP;
            chat.targetId = _groupId;
            chat.title = _groupName;
            [self.navigationController pushViewController:chat animated:YES];
        }else{
            ChatRoomViewController *chat = [[ChatRoomViewController alloc]init];
            chat.iFlag = @"3";
            chat.conversationType = ConversationType_GROUP;
            chat.targetId = _groupId;
            chat.title = _groupName;
            [self.navigationController pushViewController:chat animated:YES];
        }
    }else if (indexPath.section == 9){
        if ([[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:_groupId]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadConversationMessageCollectionViewData" object:nil];
            [Toolkit showSuccessWithStatus:@"清空成功"];
        }else{
            [Toolkit showErrorWithStatus:@"清空失败"];
        }
    }
}

-(void)getName:(NSString *)nameStr{
    _groupName = nameStr;
    [mCollectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
}

-(void)selectMemberRefreshData{
    [mCollectionView.header beginRefreshing];
}

@end
