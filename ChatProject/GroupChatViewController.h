//
//  GroupChatViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/29.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupChatViewController : BaseNavigationController<UITableViewDataSource, UITableViewDelegate>

/**
 * 1：正常    2：推荐好友
 */
@property(nonatomic,strong) NSString *iFlag;

@end
