//
//  RegisterFirstViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/23.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFirstViewController : BaseNavigationController

/**
 * 1：注册   2：通过短息验证码登陆
 */
@property (nonatomic, strong) NSString *iFlagType;

@end
