//
//  CustomTabBarViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "ChatListViewController.h"
#import "ContactsViewController.h"
#import "MomentsViewController.h"
#import "IViewController.h"
#import "WZLBadgeImport.h"
#import "UIView+Frame.h"

@interface CustomTabBarViewController (){
    ChatListViewController *chatListVC;
}

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabBarItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDefaultSelectTabBarItem:) name:@"setDefaultSelectTabBarItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNoReadNum) name:@"refreshNoReadNum" object:nil];
}

-(void)refreshNoReadNum{
    NSString *noReadNum = [NSString stringWithFormat:@"%d",[[RCIMClient sharedRCIMClient] getTotalUnreadCount]];
    if (![noReadNum isEqual:@"0"]){
        dispatch_async(dispatch_get_main_queue(), ^{
            chatListVC.tabBarItem.badgeValue = noReadNum;
        });
    }else{
        chatListVC.tabBarItem.badgeValue = nil;
    }
}

- (void)initTabBarItem{
    // ChatViewController
    chatListVC = [[ChatListViewController alloc] init];
    chatListVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [self refreshNoReadNum];
    chatListVC.tabBarItem.image = [UIImage imageNamed:@"weixin-dianjiqian"];
    chatListVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"weixin-dianjihou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *chatListVCNav = [[UINavigationController alloc] initWithRootViewController:chatListVC];
    chatListVCNav.navigationBar.hidden = true;
    if (chatListVC.navigationController.navigationBar.translucent) {
        chatListVC.automaticallyAdjustsScrollViewInsets = false;
    }
    
    // ContactsViewController
    ContactsViewController *contactsVC = [[ContactsViewController alloc] init];
    contactsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    contactsVC.tabBarItem.image = [UIImage imageNamed:@"tongxunlu-dianjiqian"];
    contactsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tongxunlu-dianjihou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *contactsVCNav = [[UINavigationController alloc] initWithRootViewController:contactsVC];
    contactsVCNav.navigationBar.hidden = true;
    if (contactsVC.navigationController.navigationBar.translucent) {
        contactsVC.automaticallyAdjustsScrollViewInsets = false;
    }
    
    // MomentsViewController
    MomentsViewController *momentsVC = [[MomentsViewController alloc] init];
    momentsVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    momentsVC.tabBarItem.image = [UIImage imageNamed:@"pengyq-dianjiqian"];
    momentsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"pengyq-dianjihou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *momentsVCNav = [[UINavigationController alloc] initWithRootViewController:momentsVC];
    momentsVCNav.navigationBar.hidden = true;
    if (momentsVC.navigationController.navigationBar.translucent) {
        momentsVC.automaticallyAdjustsScrollViewInsets = false;
    }
    
    // IViewController
    IViewController *iVC = [[IViewController alloc] init];
    iVC.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    iVC.tabBarItem.image = [UIImage imageNamed:@"wodianjiqian"];
    iVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"wodianjihou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *iVCNav = [[UINavigationController alloc] initWithRootViewController:iVC];
    iVCNav.navigationBar.hidden = true;
    if (iVC.navigationController.navigationBar.translucent) {
        iVC.automaticallyAdjustsScrollViewInsets = false;
    }
    
    //将view添加到tabbar
    self.viewControllers = [NSArray arrayWithObjects:chatListVCNav, contactsVCNav, momentsVCNav, iVCNav, nil];
}

-(void)setDefaultSelectTabBarItem:(id)sender{
    int index = [[sender userInfo][@"index"] intValue];
    self.selectedIndex = index;
}

@end
