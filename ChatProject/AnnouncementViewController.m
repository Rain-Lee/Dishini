//
//  AnnouncementViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "MJRefresh.h"
#import "AnnouncementDetailViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface AnnouncementViewController (){
    // view
    UITableView *mTableView;
    
    // data
    int index;
    NSMutableArray *dataArray;
}

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"公告"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

#pragma mark - 自定义方法
-(void)initView{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.tableFooterView = [[UIView alloc] init];
    [mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:mTableView];
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [mTableView.header beginRefreshing];
    
    mTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

-(void)refreshData{
    index = 0;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendsCallBack:"];
    [dataProvider selectGongGaoList:@"0" andmaximumRows:@"20"];
}

-(void)getFriendsCallBack:(id)dict{
    [mTableView.header endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        dataArray = [[NSMutableArray alloc] init];
        dataArray = dict[@"data"];
        
        if (dataArray.count == [dict[@"recordcount"] intValue]){
            // 所有数据加载完毕，没有更多的数据了
            mTableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            // mj_footer设置为:普通闲置状态(Idle)
            mTableView.footer.state = MJRefreshStateIdle;
        }
    }
    [mTableView reloadData];
}

-(void)loadMore{
    index++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"loadMoreCallBack:"];
    [dataProvider selectGongGaoList:[NSString stringWithFormat:@"%d",index * 20] andmaximumRows:@"20"];
}

-(void)loadMoreCallBack:(id)dict{
    // 结束刷新
    [mTableView.footer endRefreshing];
    if ([dict[@"code"] intValue] == 200) {
        NSArray * arrayitem=[[NSArray alloc] init];
        arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [dataArray addObject:item];
        }
        if (dataArray.count == [dict[@"recordcount"] intValue]){
            // 所有数据加载完毕，没有更多的数据了
            mTableView.footer.state = MJRefreshStateNoMoreData;
        }else{
            // mj_footer设置为:普通闲置状态(Idle)
            mTableView.footer.state = MJRefreshStateIdle;
        }
        [mTableView reloadData];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dataArray[indexPath.row][@"Title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    AnnouncementDetailViewController *announcementDetailVC = [[AnnouncementDetailViewController alloc] init];
    announcementDetailVC.titleStr = dataArray[indexPath.row][@"Title"];
    announcementDetailVC.contentStr = dataArray[indexPath.row][@"Message"];
    [self.navigationController pushViewController:announcementDetailVC animated:true];
}

@end
