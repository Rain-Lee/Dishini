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
#import "CustomTabBarViewController.h"

@interface AppDelegate (){
    NSMutableArray *friendArray;
    NSMutableArray *groupArray;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initConfiguration];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginRongCloud) name:@"loginRongCloud" object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        NSString *accountStr = [Toolkit getStringValueByKey:@"Account"];
        NSString *passwordStr = [Toolkit getStringValueByKey:@"Password"];
        if (accountStr != nil && ![accountStr isEqual:@""] && passwordStr != nil && ![passwordStr isEqual:@""]) {
            [self loginRongCloud];
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            navLoginVC.navigationBar.hidden = true;
            self.window.rootViewController = navLoginVC;
        }
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFriendFunc) name:@"getFriendFunc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGroupFunc) name:@"getGroupFunc" object:nil];
    
    return YES;
}

- (void)initConfiguration{
    // 融云即时通讯
    [[RCIM sharedRCIM] initWithAppKey:@"vnroth0krxvao"];
    // 设置用户信息提供者，需要提供正确的用户信息，否则SDK无法显示用户头像、用户名和本地通知
    //获取好友信息
    [self getFriendFunc];
    //获取战队信息
    [self getGroupFunc];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];//监听接收消息的代理设置
    
    // Mob短信
    [SMSSDK registerApp:@"145d0e804a274"
             withSecret:@"64d4800bb58c2ccb51eed5bfa7948781"];
    [SMSSDK enableAppContactFriends:false];
    
    //注册趣拍
    [[QupaiSDK shared] registerAppWithKey:@"209c2ed064f8e5b" secret:@"af0b6db7e8ad47328dc8949871575b05" space:@"comzykjchatproject" success:^(NSString *accessToken) {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"accessToken"];
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginRongCloud{
    //登录融云服务器的token。需要您向您的服务器请求，您的服务器调用server api获取token
    //开发初始阶段，您可以先在融云后台API调试中获取
    NSString *token = [Toolkit getStringValueByKey:@"Token"];
    //连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        [SVProgressHUD dismiss];
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:userId name:[Toolkit getUserDefaultValue:@"NickName"] portrait:[Toolkit getUserDefaultValue:@"PhotoPath"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            CustomTabBarViewController *customTabBarVC = [[CustomTabBarViewController alloc] init];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.window.rootViewController = customTabBarVC;
        });
    } error:^(RCConnectErrorCode status) {
        [SVProgressHUD dismiss];
        NSLog(@"登陆的错误码为:%ld", (long)status);
        if (status == RC_DISCONN_KICK) {
            // 当前用户在其他设备上登陆，此设备被踢下线
        }
    } tokenIncorrect:^{
        [SVProgressHUD dismiss];
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
}

-(void)getFriendFunc{
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getFriendBackCall:"];
    [dataProvider getFriendForKeyValue:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getGroupFunc{
    DataProvider *dataProvider2 = [[DataProvider alloc] init];
    [dataProvider2 setDelegateObject:self setBackFunctionName:@"getGroupCallBack:"];
    [dataProvider2 selectAllTeamByUserId:[Toolkit getStringValueByKey:@"Id"]];
}

-(void)getFriendBackCall:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [RCIM sharedRCIM].userInfoDataSource = self;
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        friendArray = dict[@"data"];
//        NSMutableArray *friendArrayTemp = [[NSMutableArray alloc] initWithArray:dict[@"data"]];
//        if (friendArray == nil || ![friendArrayTemp isEqualToArray:friendArray]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewData" object:nil];
//            friendArray = friendArrayTemp;
//        }
    }
}

-(void)getGroupCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        groupArray = dict[@"data"];
        //NSMutableArray *groupArrayTemp = [[NSMutableArray alloc] initWithArray:dict[@"data"]];
//        if (friendArray == nil || ![groupArrayTemp isEqualToArray:friendArray]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshViewData" object:nil];
//            groupArray = groupArrayTemp;
//        }
    }
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
        BOOL isFrendState = NO;
        for (int i = 0; i < friendArray .count; i++) {
            if([userId isEqual:[NSString stringWithFormat:@"%@",[friendArray[i] valueForKey:@"Key"]]]){
                isFrendState = YES;
                userInfo.name = [[friendArray[i] valueForKey:@"Value"][@"RemarkName"] isEqual:@""] ? [friendArray[i] valueForKey:@"Value"][@"NicName"] : [friendArray[i] valueForKey:@"Value"][@"RemarkName"];
                userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",Kimg_path,[friendArray[i] valueForKey:@"Value"][@"PhotoPath"]];
                break;
            }
        }
        if (!isFrendState) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DataProvider *dataProvider = [[DataProvider alloc] init];
                NSDictionary *dict = [dataProvider getUserInfoByUserIDChat:userId];
                userInfo.name = [Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"NicName"]];
                userInfo.portraitUri = [NSString stringWithFormat:@"%@%@",Kimg_path,[Toolkit judgeIsNull:[dict[@"data"] valueForKey:@"PhotoPath"]]];
            });
        }
        return completion(userInfo);
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
    RCGroup *group = [[RCGroup alloc]init];
    group.groupId = groupId;
    BOOL isExitGroup = false;
    for (NSDictionary *itemDict in groupArray) {
        if ([[itemDict[@"Id"] stringValue] isEqual:groupId]) {
            isExitGroup = true;
            group.groupName =[itemDict valueForKey:@"Name"];
            group.portraitUri = [NSString stringWithFormat:@"%@%@",Kimg_path,[itemDict valueForKey:@"ImagePath"]];
            break;
        }
    }
    if (!isExitGroup) {
        group.groupName =@"未命名";
    }
    
    return completion(group);
}


-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"%ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [Toolkit showInfoWithStatus:@"当前用户在其他设备上登陆，此设备被踢下线"];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navLoginVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        navLoginVC.navigationBar.hidden = true;
        self.window.rootViewController = navLoginVC;
    }
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    if (message.conversationType == ConversationType_PRIVATE) { // 单聊
        BOOL isContain = false;
        for (NSDictionary *itemDict in friendArray) {
            if ([[NSString stringWithFormat:@"%@",itemDict[@"Key"]] isEqual:[NSString stringWithFormat:@"%@",message.senderUserId]]) {
                isContain = true;
                break;
            }
        }
        if (!isContain) {
            [self getFriendFunc];
        }
    }else{ // 群聊
        NSLog(@"%@",groupArray);
        NSLog(@"%@",message.targetId);
        BOOL isContain = false;
        for (NSDictionary *itemDict in groupArray) {
            if ([[NSString stringWithFormat:@"%@",itemDict[@"Id"]] isEqual:[NSString stringWithFormat:@"%@",message.targetId]]) {
                isContain = true;
                break;
            }
        }
        if (!isContain) {
            [self getGroupFunc];
        }
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
