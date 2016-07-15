//
//  DataSettingViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/28.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataSettingDelegate <NSObject>

-(void)dataSettingRefreshData;

@end

@interface DataSettingViewController : BaseNavigationController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSString *userId;
@property(nonatomic,strong) NSString *remarkValue;
@property(nonatomic,strong) NSString *photoPath;
@property(nonatomic,strong) id<DataSettingDelegate> delegate;


@end
