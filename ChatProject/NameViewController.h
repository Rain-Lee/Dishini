//
//  NameViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameDelegate <NSObject>

-(void)getName:(NSString *)nameStr;

@end

@interface NameViewController : BaseNavigationController

@property(nonatomic, strong) id<NameDelegate> delegate;
@property(nonatomic, strong) NSString *nameStr;

@end
