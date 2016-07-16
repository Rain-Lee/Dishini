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
#import "MyHeaderView.h"
#import "MyFooterView.h"
#import "MJRefresh.h"
#import "DetailsViewController.h"
#import "SelectMemberViewController.h"
#import <RongIMKit/RongIMKit.h>

#define cellIdentifier  @"GroupMoreCell"
#define headCellIdentifier  @"HeadCellIdentifier"
#define footerCellIdentifier  @"FooterCellIdentifier"

@interface GroupMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SelectMemberDelegate>{
    // view
    UICollectionView *mCollectionView;
    MyHeaderView *headerV;
    MyFooterView *footerV;
    
    // data
    NSMutableArray *groupMemberData;
    BOOL isManager;
    NSMutableArray *idList;
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

-(void)clickRightButton:(UIButton *)sender{
    if (isManager){
        [Toolkit showWithStatus:@"保存中..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"editGroupCallBack:"];
        [dataProvider editGroup:_groupId andName:headerV.groupNameTxt.text andUserId:[Toolkit getStringValueByKey:@"Id"]];
    }
}

-(void)editGroupCallBack:(id)dict{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showSuccessWithStatus:@"修改群名称成功"];
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(void)initView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 5 * 10) / 4, (SCREEN_WIDTH - 5 * 10) / 4 + 20);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height) collectionViewLayout:layout];
    mCollectionView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    mCollectionView.delegate = self;
    mCollectionView.dataSource = self;
    [self.view addSubview:mCollectionView];
    [mCollectionView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    // header
    [mCollectionView registerClass:[MyHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCellIdentifier];
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
        
        if (isManager) {
            [self addRightbuttontitle:@"保存"];
        }else{
            headerV.groupNameTxt.enabled = false;
        }
        
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
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_GROUP targetId:_groupId];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:true];
    }else{
        [Toolkit showErrorWithStatus:@"删除失败"];
    }
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return groupMemberData.count + (isManager ? 2 : 1);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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
    
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(SCREEN_WIDTH / 2, 179);
//}

////设置每个item的UIEdgeInsets
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 0, 0);
//}

//设置头尾的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 70);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 45);
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    
    {
        if (kind == UICollectionElementKindSectionHeader) {
            //定制头部视图的内容
            if (headerV == nil) {
                headerV = (MyHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCellIdentifier forIndexPath:indexPath];
                headerV.groupNameTxt.text = _groupName;
            }
            reusableView = headerV;
        }else if (kind == UICollectionElementKindSectionFooter){
            //定制尾部视图的内容
            footerV = (MyFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerCellIdentifier forIndexPath:indexPath];
            if (isManager) {
                [footerV.quitBtn setTitle:@"退出并删除" forState:UIControlStateNormal];
                footerV.quitBtn.tag = 1;
                [footerV.quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [footerV.quitBtn setTitle:@"退出" forState:UIControlStateNormal];
                footerV.quitBtn.tag = 2;
                [footerV.quitBtn addTarget:self action:@selector(quitBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            reusableView = footerV;
        }
    }
    
    //    if (kind == UICollectionElementKindSectionFooter){
    //        MyFooterView *footerV = (MyFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //        footerV.titleLab.text = @"尾部视图";
    //        reusableView = footerV;
    //    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
}

-(void)selectMemberRefreshData{
    [mCollectionView.header beginRefreshing];
}

@end
