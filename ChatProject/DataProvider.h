//
//  DataProvider.h
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}
/**
 *  设置回调函数
 *
 *  @param cbobject     回调对象
 *  @param selectorName 回调函数
 */
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

/**
 * 登陆
 * @param username 账号
 * @param password 密码
 */
-(void)login:(NSString *)username andPassword:(NSString *)password;

/**
 * 注册
 * @param phone    手机号
 * @param password 密码
 */
-(void)registerUser:(NSString *)phone andPassword:(NSString *)password;

/**
 * 修改面
 * @param phone    手机号
 * @param oldPwd   原密码
 * @param password 新密码
 */
-(void)changePwd:(NSString *)phone andOldPwd:(NSString *)oldPwd andPassword:(NSString *)password;

/**
 * 获取通讯录
 * @param uid 用户Id
 */
-(void)getFriendForKeyValue:(NSString *)uid;


@end
