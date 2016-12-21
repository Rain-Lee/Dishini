//
//  ChatRecordSearchViewController.m
//  ChatProject
//
//  Created by Rain on 16/12/5.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatRecordSearchViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ChatRecordItem.h"
#import "UIImageView+WebCache.h"
#import "ChatRecordSearchDetailViewController.h"

#define CellIdentifier @"CellIdentifier"

@interface ChatRecordSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITextField *searchTxt;
    
    NSMutableArray *chatRecordArray;
}

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation ChatRecordSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    chatRecordArray = [[NSMutableArray alloc] init];
    
    [self initView];
}

#pragma mark - method
-(void)initView{
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.bgView];
    
    [self.view addSubview:self.mTableView];
}

-(void)cancelEvent{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)searchChatRecord:(NSString *)keyword{
    if ([keyword isEqual:@""]) {
        return;
    }
    
    self.bgView.hidden = true;
    self.mTableView.hidden = false;
    
    [chatRecordArray removeAllObjects];
    
    NSArray *messageArray = [[RCIMClient sharedRCIMClient] searchMessages:ConversationType_GROUP targetId:_groupId keyword:keyword count:1000 startTime:0];
    for (RCMessage *itemMessage in messageArray) {
        RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:itemMessage.senderUserId];
        ChatRecordItem *chatRecordItem = [[ChatRecordItem alloc] init];
        chatRecordItem.userId = userInfo.userId;
        chatRecordItem.name = userInfo.name;
        chatRecordItem.portraitUri = userInfo.portraitUri;
        RCMessageContent *messageContent = itemMessage.content;
        chatRecordItem.content = ((RCTextMessage *)messageContent).content;
        chatRecordItem.sendTime = [Toolkit getTimeFromTimeInterval:itemMessage.sentTime];
        chatRecordItem.messageId = [NSString stringWithFormat:@"%ld",itemMessage.messageId];
        [chatRecordArray addObject:chatRecordItem];
    }
    
    [_mTableView reloadData];
}

#pragma mark - property
-(UIView *)searchView{
    if (!_searchView) {
        // _searchView
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _searchView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
        // searchTxt
        searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(15, StatusBar_HEIGHT + (NavigationBar_HEIGHT - 33) / 2, SCREEN_WIDTH - 30 - 30 - 2, 33)];
        searchTxt.delegate = self;
        [searchTxt becomeFirstResponder];
        searchTxt.backgroundColor = [UIColor whiteColor];
        searchTxt.returnKeyType = UIReturnKeySearch;
        searchTxt.placeholder = @"请输入手机号";
        searchTxt.layer.masksToBounds = true;
        searchTxt.layer.cornerRadius = 6;
        searchTxt.layer.borderWidth = 0.5;
        searchTxt.layer.borderColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00].CGColor;
        [_searchView addSubview:searchTxt];
        // searchIv
        UIImageView *searchIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(searchTxt.frame) - 18) / 2, 35, 18)];
        searchIv.contentMode = UIViewContentModeScaleAspectFit;
        searchIv.image = [UIImage imageNamed:@"search"];
        searchTxt.leftView = searchIv;
        searchTxt.leftViewMode = UITextFieldViewModeAlways;
        // cancelBtn
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchTxt.frame) + 6, StatusBar_HEIGHT, 33, NavigationBar_HEIGHT)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:0.16 green:0.57 blue:0.14 alpha:1.00] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:cancelBtn];
    }
    
    return _searchView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.frame.size.height)];
        _bgView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00];
    }
    
    return _bgView;
}

-(UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchView.frame.size.height)];
        _mTableView.dataSource = self;
        _mTableView.delegate = self;
        _mTableView.hidden = true;
        _mTableView.tableFooterView = [[UIView alloc] init];
        [_mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    
    return _mTableView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chatRecordArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *itemView in cell.contentView.subviews) {
        [itemView removeFromSuperview];
    }
    
    ChatRecordItem *chatRecordItem = chatRecordArray[indexPath.row];
    
    // photoIv
    UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 50, 50)];
    [photoIv sd_setImageWithURL:[NSURL URLWithString:chatRecordItem.portraitUri] placeholderImage:[UIImage imageNamed:@"default_photo"]];
    [cell.contentView addSubview:photoIv];
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 5, CGRectGetMinY(photoIv.frame) + 3, 200, 21)];
    titleLbl.text = chatRecordItem.name;
    titleLbl.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLbl];
    // detailLbl
    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 5, CGRectGetMaxY(titleLbl.frame) + 3, 200, 21)];
    detailLbl.textColor = [UIColor lightGrayColor];
    NSString *contentStr = chatRecordItem.content;
    NSRange itemRange = [contentStr rangeOfString:searchTxt.text];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.16 green:0.57 blue:0.14 alpha:1.00] range:itemRange];
    detailLbl.attributedText = attr;
    detailLbl.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:detailLbl];
    // dateLbl
    UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 12 - 150, CGRectGetMinY(photoIv.frame) + 3, 150, 21)];
    dateLbl.text = chatRecordItem.sendTime;
    dateLbl.textAlignment = NSTextAlignmentRight;
    dateLbl.textColor = [UIColor lightGrayColor];
    dateLbl.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:dateLbl];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
//    ChatRecordItem *chatRecordItem = chatRecordArray[indexPath.row];
//    
//    ChatRecordSearchDetailViewController *chatRecordSearchDetailVC = [[ChatRecordSearchDetailViewController alloc] init];
//    chatRecordSearchDetailVC.targetId = _groupId;
//    chatRecordSearchDetailVC.sentTime = chatRecordItem.sendTime;
//    [self.navigationController pushViewController:chatRecordSearchDetailVC animated:true];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchChatRecord:textField.text];
}

@end
