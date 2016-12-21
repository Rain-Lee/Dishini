//
//  NewFriendsViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendsViewController : BaseNavigationController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL isDefaultSearch;

@end
