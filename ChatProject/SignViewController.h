//
//  SignViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/30.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignDelegate <NSObject>

-(void)getSign:(NSString *)signStr;

@end

@interface SignViewController : BaseNavigationController

@property(nonatomic, strong) id<SignDelegate> delegate;
@property(nonatomic, strong) NSString *signStr;

@end
