//
//  RemarksViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RemarksDelegate <NSObject>

-(void)changeRemarkRefreshData;

@end

@interface RemarksViewController : BaseNavigationController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) id<RemarksDelegate> delegate;
@property(nonatomic,strong) NSString *remarkValue;

@end
