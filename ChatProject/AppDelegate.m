//
//  AppDelegate.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initConfiguration];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    navLoginVC.navigationBar.hidden = true;
    self.window.rootViewController = navLoginVC;
    [self.window makeKeyAndVisible];
    
    // 只能竖屏显示
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
    return YES;
}

- (void)initConfiguration{
    //融云即时通讯
    [[RCIM sharedRCIM] initWithAppKey:@"vnroth0krxvao"];
    //设置用户信息提供者，需要提供正确的用户信息，否则SDK无法显示用户头像、用户名和本地通知
    [RCIM sharedRCIM].userInfoDataSource = self;
}

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    //简单的示例，根据userId获取对应的用户信息并返回
    //建议您在本地做一个缓存，只有缓存没有该用户信息的情况下，才去您的服务器获取，以提高用户体验
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = userId;
    if ([userId isEqual: @"1"]) {
        userInfo.name = @"name1";
        userInfo.portraitUri = @"http://pic.to8to.com/attch/day_160218/20160218_d968438a2434b62ba59dH7q5KEzTS6OH.png";
    }else if ([userInfo isEqual:@"2"]){
        userInfo.name = @"name2";
        userInfo.portraitUri = @"http://img3.redocn.com/20101213/20101211_0e830c2124ac3d92718fXrUdsYf49nDl.jpg";
    }else{
        userInfo.name = @"unknown";
        userInfo.portraitUri = @"";
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
