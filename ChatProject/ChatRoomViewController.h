//
//  ChatRoomViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface ChatRoomViewController : RCConversationViewController

/**
 * 1：正常 2：推荐好友 3:差走势 4：查余额
 */
@property(nonatomic,strong) NSString *iFlag;

@end
