//
//  InputAddressViewController.h
//  ChatProject
//
//  Created by Rain on 16/7/11.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputAddressDelegate <NSObject>

-(void)getAddress:(NSString *)addressStr;

@end

@interface InputAddressViewController : BaseNavigationController

@property(nonatomic, strong) id<InputAddressDelegate> delegate;
@property(nonatomic, strong) NSString *addressStr;

@end
