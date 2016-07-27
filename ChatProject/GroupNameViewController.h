//
//  GroupNameViewController.h
//  ChatProject
//
//  Created by Rain on 16/7/26.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupNameDelegate <NSObject>

-(void)getName:(NSString *)nameStr;

@end

@interface GroupNameViewController : BaseNavigationController

@property (nonatomic, strong) id<GroupNameDelegate> delegate;
@property(nonatomic, strong) NSString *nameStr;
@property(nonatomic, strong) NSString *groupId;

@end
