//
//  ChatListViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatRoomViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.view.backgroundColor = navi_bar_bg_color;
    
    // 设置conversationListTableView frame
    self.conversationListTableView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height);
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.emptyConversationView = [[UIView alloc] init];
    
    // 设置显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewData) name:@"refreshViewData" object:nil];
}

-(void)refreshViewData{
    [self refreshConversationTableViewIfNeeded];
}

- (void)initView{
    // topView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Header_Height)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = @"会话列表";
    [topView addSubview:titleLbl];
    // rightBtn
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75 - 14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
    rightBtn.titleLabel.textColor = [UIColor whiteColor];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitle:@"单聊" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    //[topView addSubview:rightBtn];
}

- (void)clickRightBtnEvent{
    ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
    chatRoomVC.conversationType = ConversationType_PRIVATE;
    chatRoomVC.iFlag = @"1";
    chatRoomVC.targetId = [Toolkit getUserDefaultValue:@"Id"];
    chatRoomVC.title = [Toolkit getUserDefaultValue:@"NickName"];
    chatRoomVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatRoomVC animated:true];
}

#pragma mark - RCConversationListViewController
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    ChatRoomViewController *chatRoomVC = [[ChatRoomViewController alloc] init];
    chatRoomVC.iFlag = @"1";
    chatRoomVC.conversationType = model.conversationType;
    chatRoomVC.targetId = model.targetId;
    chatRoomVC.title = model.conversationTitle;
    chatRoomVC.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:chatRoomVC animated:true];
}



@end
