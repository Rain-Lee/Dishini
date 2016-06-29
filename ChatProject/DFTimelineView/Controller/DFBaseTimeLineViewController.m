//
//  DFBaseTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"

#define TableHeaderHeight 290*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2


#define NickFont [UIFont systemFontOfSize:20]

#define SignFont [UIFont systemFontOfSize:11]




@interface DFBaseTimeLineViewController()

@property (nonatomic, strong) UIImageView *coverView;

@property (nonatomic, strong) UIImageView *userAvatarView;

@property (nonatomic, strong) MLLabel *userNickView;

@property (nonatomic, strong) MLLabel *userSignView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIView *footer;

@property (nonatomic, assign) BOOL isLoadingMore;



@end


@implementation DFBaseTimeLineViewController



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _isLoadingMore = NO;
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initHeader];
    
    [self initFooter];
    
}

- (void)setTopView:(int)iFlag{
    // topView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Header_Height)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = @"朋友圈";
    [topView addSubview:titleLbl];
    if (iFlag == 1) {
        // 修改_tableView frame
        _tableView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT);
        // rightBtn
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75 - 14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
        rightBtn.titleLabel.textColor = [UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBtn setTitle:@"" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:rightBtn];
    }else{
        // 修改_tableView frame 因为向下偏移
        _tableView.frame = CGRectMake(0, Header_Height - 20, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height + 20);
        // leftBtn
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(clickLeftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:leftBtn];
    }
}

-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height) style:UITableViewStylePlain];
    //_tableView.backgroundColor = [UIColor darkGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsZero;
    }
    [self.view addSubview:_tableView];
}

-(void) initHeader
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = TableHeaderHeight;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    header.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = header;
    
    
    //封面
    height = CoverHeight;
    _coverView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _coverView.backgroundColor = [UIColor darkGrayColor];
    
    self.coverWidth  = width*2;
    self.coverHeight = height*2;
    [header addSubview:_coverView];
    
    //用户头像
    x = self.view.frame.size.width - AvatarRightMargin - AvatarSize;
    y = header.frame.size.height - AvatarSize - 20;
    width = AvatarSize;
    height = width;
    
    UIButton *avatarBg = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    avatarBg.backgroundColor = [UIColor whiteColor];
    avatarBg.layer.borderWidth=0.5;
    avatarBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [avatarBg addTarget:self action:@selector(onClickUserAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:avatarBg];
    
    x = AvatarPadding;
    y = x;
    width = CGRectGetWidth(avatarBg.frame) - 2*AvatarPadding;
    height = width;
    _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [avatarBg addSubview:_userAvatarView];
    self.userAvatarSize = width*2;
    
    
    //用户昵称
    if (_userNickView == nil) {
        _userNickView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userNickView.textColor = [UIColor whiteColor];
        _userNickView.font = NickFont;
        _userNickView.numberOfLines = 1;
        _userNickView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userNickView];
        
        
    }
    
    
    //用户签名
    if (_userSignView== nil) {
        _userSignView = [[MLLabel alloc] initWithFrame:CGRectZero];
        _userSignView.textColor = [UIColor lightGrayColor];
        _userSignView.font = SignFont;
        _userSignView.numberOfLines = 1;
        _userSignView.adjustsFontSizeToFitWidth = NO;
        [header addSubview:_userSignView];
        
        
    }
    
    //下拉刷新
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:self.refreshControl];
    }
    
    
    
}


-(void) initFooter
{
    CGFloat x,y,width, height;
    x=0;
    y=0;
    width = self.view.frame.size.width;
    height = 0.1;
    
    _footer = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _footer.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = _footer;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.center = CGPointMake(_footer.frame.size.width/2, 30);
    indicator.hidden = YES;
    [indicator startAnimating];
    
    [_footer addSubview:indicator];
    
    
}




#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


#pragma mark - TabelViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}





#pragma mark - PullMoreFooterDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"size: %f  offset:  %f", scrollView.contentSize.height, scrollView.contentOffset.y+self.tableView.frame.size.height);
    
    if (_isLoadingMore) {
        return;
    }
    
    if (scrollView.contentOffset.y+self.tableView.frame.size.height - 30 > scrollView.contentSize.height) {
        
        [self showFooter];
    }
}


-(void) showFooter
{
    NSLog(@"show footer");
    
    CGRect frame = _tableView.tableFooterView.frame;
    CGFloat x,y,width,height;
    width = frame.size.width;
    height = 50;
    x = frame.origin.x;
    y = frame.origin.y;
    _footer.frame = CGRectMake(x, y, width, height);
    _tableView.tableFooterView = _footer;
    
    _isLoadingMore = YES;
    [self loadMore];
    
    
    
    
}


-(void) hideFooter
{
    NSLog(@"hide footer");
    
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect frame = _tableView.tableFooterView.frame;
        CGFloat x,y,width,height;
        width = frame.size.width;
        height = 0.1;
        x = frame.origin.x;
        y = frame.origin.y;
        _footer.frame = CGRectMake(x, y, width, height);
        _tableView.tableFooterView = _footer;
        
        _isLoadingMore = NO;
        
    }];
    
}


-(void) onPullDown:(id) sender
{
    [self refresh];
}


-(void) refresh
{
}

-(void) loadMore
{
}


-(void)endLoadMore
{
    [self hideFooter];
}

-(void)endRefresh
{
    [_refreshControl endRefreshing];
}



#pragma mark - Method


-(void)setCover:(NSString *)url
{
    [_coverView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserAvatar:(NSString *)url
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setUserNick:(NSString *)nick
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:nick font:NickFont];
    width = size.width;
    height = size.height;
    x = CGRectGetMinX(_userAvatarView.superview.frame) - width - 5;
    y = CGRectGetMidY(_userAvatarView.superview.frame) - height - 2;
    _userNickView.frame = CGRectMake(x, y, width, height);
    _userNickView.text = nick;
}


-(void)setUserSign:(NSString *)sign
{
    CGFloat x, y, width, height;
    
    CGSize size = [MLLabel getViewSizeByString:sign font:SignFont];
    width = size.width;
    height = size.height;
    x = CGRectGetWidth(self.view.frame) - width - 15;
    y = CGRectGetMaxY(_userAvatarView.superview.frame) + 5;
    _userSignView.frame = CGRectMake(x, y, width, height);
    _userSignView.text = sign;
}




-(void) onClickUserAvatar:(id) sender
{
    [self onClickHeaderUserAvatar];
}


-(void)onClickHeaderUserAvatar
{
    
}

-(void)clickLeftBtnEvent{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)clickRightBtnEvent{
    
}

@end