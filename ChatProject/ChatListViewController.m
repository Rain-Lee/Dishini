//
//  ChatListViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatRoomViewController.h"
#import "LMJScrollTextView.h"

@interface ChatListViewController (){
    RCConversationBaseCell *selectCell;
    LMJScrollTextView * scrollTextView;
    UIView *carouselView;
    UIView *lineView2;
}

@property (nonatomic, strong) UIButton *bgView;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initChatListData) name:@"initChatListData" object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置conversationListTableView frame
    //self.conversationListTableView.frame = CGRectMake(0, Header_Height + 41, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 41);
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    self.emptyConversationView = [[UIView alloc] init];
    
    // 设置显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE), @(ConversationType_GROUP)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewData) name:@"refreshViewData" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshNoReadNum" object:nil];
}

-(void)refreshViewData{
    [self refreshConversationTableViewIfNeeded];
}

-(void)bgEvent{
    [self.bgView removeFromSuperview];
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
    titleLbl.text = @"迪士尼";
    [topView addSubview:titleLbl];
    
    // carouselView
    carouselView = [[UIView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, 40)];
    carouselView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:carouselView];
    // iconIv
    UIImageView *iconIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, (carouselView.frame.size.height - 17) / 2, 17, 17)];
    iconIv.image = [UIImage imageNamed:@"tips"];
    [carouselView addSubview:iconIv];
    // messageLbl
    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconIv.frame) + 5, 0, 56, carouselView.frame.size.height)];
    messageLbl.font = [UIFont systemFontOfSize:13];
    messageLbl.textColor = [UIColor grayColor];
    messageLbl.text = @"最新消息:";
    [carouselView addSubview:messageLbl];
    // scrollTextView
    scrollTextView = [[LMJScrollTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLbl.frame) + 5, 0, SCREEN_WIDTH - CGRectGetMaxX(messageLbl.frame) - 5 - 5, 40) textScrollModel:LMJTextScrollContinuous direction:LMJTextScrollMoveLeft];
    scrollTextView.backgroundColor = [UIColor whiteColor];
    [scrollTextView setMoveSpeed:0.8];
    [carouselView addSubview:scrollTextView];
    
    [self initChatListData];
    
    // lineView2
    lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carouselView.frame), SCREEN_WIDTH, 1)];
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView2];
}

-(void)initChatListData{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"initDataCallBack:"];
    [dataProvider getAllGonggaoByUserId:[Toolkit getUserID]];
}

-(void)initDataCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSArray *gonggaoArray = [NSArray arrayWithArray:dict[@"data"]];
        NSString *gonggaoStr = @"";
        for (NSDictionary *itemDict in gonggaoArray) {
            if (![[Toolkit judgeIsNull:itemDict[@"Gonggao"]] isEqual:@""]){
                gonggaoStr = [NSString stringWithFormat:@"%@&%@",gonggaoStr,itemDict[@"Gonggao"]];
            }
        }
        if (gonggaoStr.length == 0) {
            [carouselView removeFromSuperview];
            [lineView2 removeFromSuperview];
            self.conversationListTableView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT);
        }else{
            gonggaoStr = [gonggaoStr substringFromIndex:1];
            [self.view addSubview:carouselView];
            [self.view addSubview:lineView2];
            self.conversationListTableView.frame = CGRectMake(0, Header_Height + 41, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - 41 - TabBar_HEIGHT);
            [scrollTextView startScrollWithText:gonggaoStr textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13]];
        }
    }
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

-(UIButton *)bgView{
    if (!_bgView) {
        // _bgView
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = BACKGROUND_COLOR;
        _bgView.alpha = 0.4;
        [_bgView addTarget:self action:@selector(bgEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // showView
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT / 2 - 91 / 2, SCREEN_WIDTH - 25 * 2, 91)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.masksToBounds = true;
    showView.layer.cornerRadius = 6;
    [_bgView addSubview:showView];
    
    // zhidingBtn
    UIButton *zhidingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 45)];
    [zhidingBtn setTitle:selectCell.model.isTop ? @"取消置顶" : @"置顶该聊天" forState:UIControlStateNormal];
    zhidingBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [zhidingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [zhidingBtn addTarget:self action:@selector(zhidingEvent) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:zhidingBtn];
    
    // lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zhidingBtn.frame), showView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [showView addSubview:lineView];
    
    // delBtn
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), showView.frame.size.width, 45)];
    [delBtn setTitle:@"删除该聊天记录" forState:UIControlStateNormal];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [delBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delEvent) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:delBtn];
    
    return _bgView;
}

-(void)zhidingEvent{
    [[RCIMClient sharedRCIMClient] setConversationToTop:selectCell.model.conversationType targetId:selectCell.model.targetId isTop:!selectCell.model.isTop];
    [self refreshConversationTableViewIfNeeded];
    
    [self bgEvent];
}

-(void)delEvent{
    [[RCIMClient sharedRCIMClient] removeConversation:selectCell.model.conversationType targetId:selectCell.model.targetId];
    [self refreshConversationTableViewIfNeeded];
    
    [self bgEvent];
}

-(void)cellLongPress:(UIGestureRecognizer *)sender{
    selectCell = (RCConversationBaseCell *)sender.view;
    
    [self.view addSubview:self.bgView];
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

/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPress:)];
    [cell addGestureRecognizer:longPressGesture];
}

@end
