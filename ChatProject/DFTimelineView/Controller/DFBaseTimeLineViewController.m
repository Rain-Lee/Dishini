//
//  DFBaseTimeLineViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/10/15.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTimeLineViewController.h"
#import "SendNewsViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>
#import "SendVideoViewController.h"

#define TableHeaderHeight 290*([UIScreen mainScreen].bounds.size.width / 375.0)
#define CoverHeight 240*([UIScreen mainScreen].bounds.size.width / 375.0)


#define AvatarSize 70*([UIScreen mainScreen].bounds.size.width / 375.0)
#define AvatarRightMargin 15
#define AvatarPadding 2


#define NickFont [UIFont systemFontOfSize:20]

#define SignFont [UIFont systemFontOfSize:11]


#define sendNews  (2015+1)
#define smallVideo  (2015+2)

@interface DFBaseTimeLineViewController(){
    UIView *moreSettingBackView;
    SendNewsViewController *sendNewsVC;
    UIViewController *recordController;
}

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

- (void)setTopView:(int)iFlag andTitle:(NSString *)title{
    // topView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Header_Height)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = title;
    [topView addSubview:titleLbl];
    if (iFlag == 1) {
        // 修改_tableView frame
        _tableView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height - TabBar_HEIGHT);
        // rightBtn
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75 - 14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
        rightBtn.titleLabel.textColor = [UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBtn setImage:[UIImage imageNamed:@"moreNoword"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:rightBtn];
    }else if (iFlag == 2){
        // 修改_tableView frame 因为向下偏移
        _tableView.frame = CGRectMake(0, Header_Height - 20, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height + 20);
        // leftBtn
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(clickLeftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:leftBtn];
    }else{
        // 去掉 tableHeaderView
        _tableView.tableHeaderView = [[UIView alloc] init];
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
    
    moreSettingBackView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100 -10), Header_Height, 100, 88)];
    moreSettingBackView.backgroundColor = navi_bar_bg_color;
    UIButton *newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newBtn setTitle:@"发动态" forState:UIControlStateNormal];
    newBtn.tag = sendNews;
    [newBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width - 2, 1)];
    lineView2.backgroundColor = Separator_Color;
    UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, moreSettingBackView.frame.size.height/2, moreSettingBackView.frame.size.width,  moreSettingBackView.frame.size.height/2)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"小视频" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.tag = smallVideo;
    
    
    
    [moreSettingBackView addSubview:newBtn];
    [moreSettingBackView addSubview:delBtn];
    [moreSettingBackView addSubview:lineView2];
    
    [self.view addSubview:moreSettingBackView];
    moreSettingBackView.hidden = YES;
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
    UITapGestureRecognizer *tapCoverView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCoverViewEvent)];
    _coverView.userInteractionEnabled = true;
    [_coverView addGestureRecognizer:tapCoverView];
    
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
        _tableView.tableFooterView = [[UIView alloc] init];
        
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

-(void)setCoverImg:(UIImage *)img{
    _coverView.image = img;
}

-(void)setUserAvatar:(NSString *)url
{
    [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_photo"]];
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
    if(moreSettingBackView.hidden == YES)
    {
        moreSettingBackView.hidden = NO;
        [self positionShowView:moreSettingBackView];
    }
    else
    {
        
        [self positionDismissView:moreSettingBackView];
    }
}

-(void)btnClick:(UIButton *)sender
{
    [self positionDismissView:moreSettingBackView];
    if(sender.tag == sendNews)
    {
        sendNewsVC = [[SendNewsViewController alloc] init];
        sendNewsVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:sendNewsVC animated:YES];
    }
    else  if(sender.tag == smallVideo)
    {
        QupaiSDK *sdkqupai = [QupaiSDK shared];
        [sdkqupai setDelegte:(id<QupaiSDKDelegate>)self];
        
        /*可选设置*/
        sdkqupai.thumbnailCompressionQuality =0.3;
        sdkqupai.combine = YES;
        sdkqupai.progressIndicatorEnabled = YES;
        sdkqupai.beautySwitchEnabled = NO;
        sdkqupai.flashSwitchEnabled = NO;
        sdkqupai.tintColor = [UIColor orangeColor];
        sdkqupai.localizableFileUrl = [[NSBundle mainBundle] URLForResource:@"QPLocalizable_en" withExtension:@"plist"];
        sdkqupai.bottomPanelHeight = 120;
        sdkqupai.recordGuideEnabled = YES;
        
        /*基本设置*/
        CGSize videoSize = CGSizeMake(320, 240);
        recordController = [sdkqupai createRecordViewControllerWithMinDuration:2
                                                                   maxDuration:8
                                                                       bitRate:500000
                                                                     videoSize:videoSize];
        [self presentViewController:recordController animated:YES completion:nil];
    }
}

//趣拍取消
-(void)qupaiSDKCancel:(QupaiSDK *)sdk
{
    [recordController dismissViewControllerAnimated:YES completion:nil];
}

-(void)qupaiSDK:(QupaiSDK *)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    NSLog(@"%@",videoPath);
    
    [recordController dismissViewControllerAnimated:YES completion:nil];
    
    SendVideoViewController *sendVideoVC = [[SendVideoViewController alloc] init];
    sendVideoVC.hidesBottomBarWhenPushed = true;
    sendVideoVC.VideoFilePath=[NSURL fileURLWithPath:videoPath];
    [self.navigationController pushViewController:sendVideoVC animated:YES];
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

@end
