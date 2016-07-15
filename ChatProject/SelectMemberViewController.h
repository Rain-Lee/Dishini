//
//  SelectMemberViewController.h
//  ChatProject
//
//  Created by Rain on 16/7/13.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectMemberDelegate <NSObject>

-(void)selectMemberRefreshData;

@end

@interface SelectMemberViewController : BaseNavigationController<UITableViewDelegate, UITableViewDataSource>

/**
 * 1：加  2：减
 */
@property(nonatomic,strong) NSString *iFlag;
@property(nonatomic,strong) NSString *groupId;
@property(nonatomic,strong) id<SelectMemberDelegate> delegate;
@property(nonatomic,strong) NSArray *idList;

@end
