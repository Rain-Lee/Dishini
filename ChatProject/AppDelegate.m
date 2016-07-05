//
//  AppDelegate.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "FirstScrollController.h"
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initConfiguration];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navLoginVC.navigationBar.hidden = true;
        self.window.rootViewController = navLoginVC;
    }else{
        FirstScrollController *firstScrollController = [[FirstScrollController alloc] init];
        self.window.rootViewController = firstScrollController;
    }
    
    [self.window makeKeyAndVisible];
    
    // 只能竖屏显示
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    // 修改UINavigationBar背景颜色
    [[UINavigationBar appearance] setBarTintColor:navi_bar_bg_color];
    [[UINavigationBar appearance] setTranslucent:NO];
    // 修改UINavigationBar title颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    return YES;
}

- (void)initConfiguration{
    // 融云即时通讯
    [[RCIM sharedRCIM] initWithAppKey:@"vnroth0krxvao"];
    // 设置用户信息提供者，需要提供正确的用户信息，否则SDK无法显示用户头像、用户名和本地通知
    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    // Mob短信
    [SMSSDK registerApp:@"145d0e804a274"
             withSecret:@"64d4800bb58c2ccb51eed5bfa7948781"];
    [SMSSDK enableAppContactFriends:false];
    
    //注册趣拍
    [[QupaiSDK shared] registerAppWithKey:@"2052a8cb76e5aa7" secret:@"9788da8ec0ce45f4935bcad6dccf20e4" space:@"space" success:^(NSString *accessToken) {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    } failure:^(NSError *error) {
        
    }];
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    //简单的示例，根据userId获取对应的用户信息并返回
    //建议您在本地做一个缓存，只有缓存没有该用户信息的情况下，才去您的服务器获取，以提高用户体验
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    RCUserInfo *myUserInfo = [RCIM sharedRCIM].currentUserInfo;
    userInfo.userId = userId;
    if ([userId isEqual:myUserInfo.userId]) {
        userInfo = myUserInfo;
    }else{
        userInfo.name = @"unknown";
        userInfo.portraitUri = @"";
    }
}

-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"%ld",(long)status);
    if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"断开连接" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
