//
//  DetailsViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/27.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : BaseNavigationController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong) NSString *userId;

@property(nonatomic,strong) NSString *phone;

/**
 * 1、根据用户Id获取用户信息  2、根据手机号获取用户信息
 */
@property(nonatomic,strong) NSString *iFlag;

@end
