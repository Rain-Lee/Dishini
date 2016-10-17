//
//  RegisterSecondViewController.h
//  ChatProject
//
//  Created by Rain on 16/6/24.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterSecondViewController : BaseNavigationController

@property (nonatomic, strong) NSString *phone;

/**
 * 1：注册   2：通过短息验证码登陆
 */
@property (nonatomic, strong) NSString *iFlagType;
@property (nonatomic, strong) NSString *verificationCode;

@end
