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
 * 通过手机号+验证码登陆
 * @param phone 手机号
 */
-(void)loginWithoutPassword:(NSString *)phone;

/**
 * 注册
 * @param phone    手机号
 * @param password 密码
 */
-(void)registerUser:(NSString *)phone andPassword:(NSString *)password;

/**
 * 修改密码
 * @param phone    手机号
 * @param oldPwd   原密码
 * @param password 新密码
 */
-(void)changePwd:(NSString *)phone andOldPwd:(NSString *)oldPwd andPassword:(NSString *)password;

/**
 * 获取省
 */
-(void)getProvince;

/**
 * 根据省获取市
 * @param provinceCode 省code
 */
-(void)getCityByProvince:(NSString *)provinceCode;

/**
 * 根据市获取县
 * @param cityCode 市code
 */
-(void)getCountyByCity:(NSString *)cityCode;

/**
 * 编辑用户信息
 * @param userId     用户id
 * @param nickName   昵称
 * @param sex        性别
 * @param homeAreaId 地址
 */
-(void)editUserInfo:(NSString *)userId andNickName:(NSString *)nickName andSex:(NSString *)sex andHomeAreaId:(NSString *)homeAreaId;

/**
 * 上传头像
 * @param userId     用户Id
 * @param filestream 图片数据
 * @param fileName   图片名称
 */
-(void)upLoadPhoto:(NSString *)userId andImgData:(NSString *)filestream  andImgName:(NSString *)fileName;

/**
 * 上传图片
 * @param imageData 图片数据
 */
-(void)UploadImgWithImgdata:(NSString *)imageData;

/**
 * 朋友圈
 * @param userId          用户Id
 * @param startRowIndexs 开始索引
 * @param maximumRows     每页条数
 */
-(void)getDongtaiPageByFriends:(NSString *)userId andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows;

/**
 * 保存动态
 * @param userId        用户Id
 * @param content       内容
 * @param pathlist      关联图片地址，多张图片用“&”拼接
 * @param videoImage    视频截图
 * @param videopath     视频地址
 * @param videoDuration 视频时长
 * @param smallImage    缩略图地址
 */
-(void)SaveDongtai:(NSString *)userId andContent:(NSString *)content andPathlist:(NSString *)pathlist andVideoImage:(NSString *)videoImage andVideopath:(NSString *)videopath andVideoDuration:(NSString *)videoDuration andSmallImage:(NSString *)smallImage;

/**
 * 更新朋友圈头部背景图片
 * @param userId    用户Id
 * @param imagePath 图片
 */
-(void)saveSpaceImage:(NSString *)userId andImagePath:(NSString *)imagePath;

/**
 * 上传视频
 * @param videoPath 视频数据
 */
-(void)upLoadVideo:(NSURL *)videoPath;



/**
 * 获取通讯录
 * @param userId 用户Id
 */
-(void)getFriends:(NSString *)userId;


@end
