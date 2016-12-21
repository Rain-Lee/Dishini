//
//  CreateGroupViewController.h
//  ChatProject
//
//  Created by Rain on 12/18/16.
//  Copyright © 2016 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewController : BaseNavigationController

@property (nonatomic, strong) NSString *selectFriendStr;

/**
 * 1：正常    2：推荐好友
 */
@property(nonatomic,strong) NSString *iFlag;

@end
