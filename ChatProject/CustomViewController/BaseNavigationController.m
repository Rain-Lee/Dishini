//
//  BaseNavigationController.m
//  Blinq
//
//  Created by user on 13-9-2.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "BaseNavigationController.h"
#import "Toolkit.h"

#define DefaultLeftImageWidth 44

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        _orginY = 20;
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavigationBar_HEIGHT + _orginY)];
    //_topView.backgroundColor = [UIColor colorWithRed:238 / 255.0f green:225 / 255.0f blue:208 / 255.0f alpha:1.0f];
    
    _topView.userInteractionEnabled = YES;
    // _topView.backgroundColor = [UIColor colorWithRed:0.97 green:0.96 blue:0.96 alpha:1];
    
    _topView.backgroundColor = navi_bar_bg_color;
    
 
    
    [self.view addSubview:_topView];
    
    
    _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(DefaultLeftImageWidth, _orginY  + 0, SCREEN_WIDTH - 2 * DefaultLeftImageWidth, NavigationBar_HEIGHT)];
    _lblTitle.backgroundColor = [UIColor clearColor];
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    //[_lblTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //_lblTitle.font = [UIFont boldSystemFontOfSize:20];
    _lblTitle.textColor = [UIColor whiteColor];
    _lblTitle.font=[UIFont boldSystemFontOfSize:18];
    _lblTitle.textAlignment = NSTextAlignmentCenter;
    _lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    if(self.navtitle != nil)
    {
        _lblTitle.text = self.navtitle ;
    }
    
    _lblTitle.numberOfLines = 0;
    _lblTitle.center = CGPointMake(_topView.center.x, _lblTitle.center.y);
    [self.view addSubview:_lblTitle];
    
    _imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, _orginY, 40, NavigationBar_HEIGHT)];
    _imgLeft.backgroundColor = [UIColor clearColor];
    _imgLeft.center = CGPointMake(_imgLeft.center.x, _lblTitle.center.y);
    [self.view addSubview:_imgLeft];
    
    _lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(_imgLeft.frame.size.width+_imgLeft.frame.origin.x,_orginY,60 ,NavigationBar_HEIGHT)];
    
    _lblLeft.numberOfLines = 0;
    _lblLeft.textAlignment=NSTextAlignmentCenter;
    _lblLeft.font = [UIFont systemFontOfSize:16];
    _lblLeft.textColor = [UIColor whiteColor];
    _lblLeft.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblLeft];
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, _orginY, 60, NavigationBar_HEIGHT)];
    [_btnLeft addTarget:self action:@selector(clickLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    _btnLeft.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_btnLeft];
    
    _imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , _orginY, 60, NavigationBar_HEIGHT)];
    _imgRight.backgroundColor = [UIColor clearColor];
    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
    [self.view addSubview:_imgRight];
    
    _lblRight = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60-10 ,_orginY ,80,NavigationBar_HEIGHT)];
    
    _lblRight.numberOfLines = 0;
    _lblRight.textAlignment=NSTextAlignmentCenter;
    _lblRight.font = [UIFont systemFontOfSize:16];
    _lblRight.textColor = [UIColor whiteColor];
    _lblRight.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_lblRight];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, _orginY, 60, NavigationBar_HEIGHT)];
    _btnRight.backgroundColor = [UIColor clearColor];
    [_btnRight addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnRight];
    
    
//    [self createButton];
    
    
    /*
    if(self.DoNotcheckLogin == NO)
    {
        if ([Toolkit islogin] == NO) {
            LoginViewController *loginViewCtl = [[LoginViewController alloc] init];
            loginViewCtl.DoNotcheckLogin = YES;
            [self presentViewController:loginViewCtl animated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];

                
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil userInfo:[NSDictionary dictionaryWithObject:@"mainpage" forKey:@"rootView"]];
            }];
            
            return;
            
        }
    }
    */
    
}



-(void)setNavtitle:(NSString *)navtitle
{
    _navtitle = navtitle;
    [self setBarTitle:_navtitle];
}

- (void)setBarTitle:(NSString *)strTitle
{
    _lblTitle.text = strTitle;
    NSLog(@"%@",_lblTitle);
    _lblTitle.center = CGPointMake(_topView.center.x, _lblTitle.center.y);
}

- (void)setBarTitleColor:(UIColor *)color
{
    _lblTitle.textColor = color;
}

- (void)addLeftButton:(NSString *)strImage
{
    //UIImage *imgBtn = [UIImage imageWithBundleName:strImage];
    UIImage *imgBtn = [UIImage imageNamed:strImage];
    _imgLeft.image = imgBtn;
    [_imgLeft setFrame:CGRectMake(_btnLeft.frame.origin.x + 10, _btnLeft.frame.origin.y, imgBtn.size.width , imgBtn.size.height )];
    _imgLeft.center = CGPointMake(_imgLeft.center.x, _lblTitle.center.y);
}

- (void)addRightButton:(NSString *)strImage
{
    UIImage *imgBtn = [UIImage imageNamed:strImage];
    _imgRight.image = imgBtn;
    _imgRight.contentMode = UIViewContentModeScaleAspectFill;
    [_imgRight setFrame:CGRectMake(_btnRight.frame.origin.x + 25, _btnRight.frame.origin.y,imgBtn.size.width , imgBtn.size.height )];
    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
    
    
//    UIImage *imgBtn = [UIImage imageWithBundleName:strImage];
//    _imgRight.image = imgBtn;
//    [_imgRight setFrame:CGRectMake(_btnRight.frame.origin.x + 10, _btnRight.frame.origin.y, imgBtn.size.width, imgBtn.size.height)];
//    _imgRight.center = CGPointMake(_imgRight.center.x, _imgLeft.center.y);
}
- (void)addLeftbuttontitle:(NSString *)strName
{
    _lblLeft.text=strName;
}
- (void)addRightbuttontitle:(NSString *)strName
{
    _lblRight.text=strName;
}




- (void)clickLeftButton:(UIButton *)sender
{
    
    [self hiddenFloatnBtn];
    NSLog(@"left button click");
    UIViewController *aa = [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"aa:%@",aa);
}

- (void)clickRightButton:(UIButton *)sender
{
    NSLog(@"right button click");
}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}



//重写这两个方法，设置成UIInterfaceOrientationMaskAll 和return yes则支持转屏
-(UIInterfaceOrientationMask)supportedInterfaceOrientations//支持的转屏方向
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate//是否支持转屏
{
    return YES;
}
//- (void)addStarToNavigtionBar
//{
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 32 / 2.0, 45 / 2.0)];
//    imageView.image = [UIImage imageWithBundleName:@"iconAffirmed.png"];
//    imageView.center = CGPointMake(imageView.center.x, _imgLeft.center.y);
//    [self.view addSubview:imageView];
//}



#pragma mark - 悬浮按钮



-(void)createButton
{
    self.floatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.floatButton setTitle:@"悬浮按钮" forState:UIControlStateNormal];
    self.floatButton.frame = CGRectMake(0, 0, 40, 40);
    [self.floatButton addTarget:self action:@selector(clickFloatBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.floatButton setImage:[UIImage imageNamed:@"onerow"] forState:UIControlStateNormal];
    [self.floatButton setImage:[UIImage imageNamed:@"doublerow"] forState:UIControlStateSelected];
//    self.floatButton.contentMode = UIViewContentModeScaleAspectFit;
    self.floatButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.floatWindow = [[UIWindow alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , SCREEN_HEIGHT-100, 40, 40)];
    self.floatWindow.windowLevel = UIWindowLevelAlert+1;
    self.floatWindow.backgroundColor = ItemsBaseColor;
    self.floatWindow.layer.cornerRadius = self.floatWindow.frame.size.width/2;
    self.floatWindow.layer.masksToBounds = YES;
    [self.floatWindow addSubview:self.floatButton];
}

-(void)clickFloatBtn:(UIButton*)sender
{
    NSLog(@"Click Float Btn");
}

-(void)showFloatBtn
{
    [self createButton];
    [self.floatWindow makeKeyAndVisible];//关键语句,显示window
}

/**
 *  关闭悬浮的window
 */
- (void)hiddenFloatnBtn
{
    
    if(self.floatWindow!=nil)
    {
        [self.floatWindow resignKeyWindow];
        self.floatWindow = nil;
    }
}
- (void)showFloatBtnWindow
{
    
    if(self.floatWindow!=nil)
    {
        [self.floatWindow makeKeyAndVisible];
        self.floatWindow.hidden = NO;
    }
}
- (void)hiddenFloatnWindow
{
    
    if(self.floatWindow!=nil)
    {
        [self.floatWindow resignKeyWindow];
        self.floatWindow.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc
//{
//    [super dealloc];
//}


@end
