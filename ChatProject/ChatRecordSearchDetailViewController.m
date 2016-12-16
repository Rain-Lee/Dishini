//
//  ChatRecordSearchDetailViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/9.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatRecordSearchDetailViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "MessageItemLeftTableViewCell.h"
#import "UIImageView+WebCache.h"

#define CellIdentifierLeft @"MessageItemLeftTableViewCell"

@interface ChatRecordSearchDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *historyMessageArray;
}

@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation ChatRecordSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavtitle:@"聊天记录"];
    [self addLeftButton:@"left"];
    
    [self initView];
}

#pragma mark - function

-(void)initView{
    [self.view addSubview:self.mTableView];
    
    [self getChatRecordData];
}

-(void)getChatRecordData{
    historyMessageArray = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_GROUP targetId:self.targetId sentTime:[Toolkit getTimeIntervalFromString:self.sentTime] beforeCount:10 afterCount:10000];
    [self.mTableView reloadData];
}

#pragma mark - property

-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height)];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.tableFooterView = [[UIView alloc] init];
        [_mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifierLeft];
        [_mTableView registerNib:[UINib nibWithNibName:CellIdentifierLeft bundle:nil] forCellReuseIdentifier:CellIdentifierLeft];
    }
    return _mTableView;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return historyMessageArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItemLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierLeft forIndexPath:indexPath];
    
    RCMessage *itemMessage = historyMessageArray[indexPath.row];
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:itemMessage.senderUserId];
    
    [cell.photoIv sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"default_photo"]];
    cell.nameLbl.text = userInfo.name;
    RCMessageContent *messageContent = itemMessage.content;
    NSLog(@"------------------------------%@",((RCTextMessage *)messageContent));
    if ([messageContent isKindOfClass:[RCTextMessage class]]) {
        cell.contentLbl.text = ((RCTextMessage *)messageContent).content;
    }else if ([messageContent isKindOfClass:[RCImageMessage class]]){
        
    }else if ([messageContent isKindOfClass:[RCInformationNotificationMessage class]]){
        
    }
    
    return cell;
}

@end
