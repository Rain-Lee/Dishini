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
-(void)editUserInfo:(NSString *)userId andNickName:(NSString *)nickName andSex:(NSString *)sex andHomeAreaId:(NSString *)homeAreaId andDescription:(NSString *)description;

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
 * 根据用户Id获取动态信息
 * @param userId          用户Id
 * @param startRowFriends 开始索引
 * @param maximumRows     每页条数
 */
-(void)getDongtaiByUserId:(NSString *)userId andStartRowFriends:(NSString *)startRowFriends andMaximumRows:(NSString *)maximumRows;

/**
 * 根据动态ID获取动态信息
 * @param userId 用户Id
 * @param newsId 动态Id
 */
-(void)getDongtaiByNewsId:(NSString *)userId andNewsId:(NSString *)newsId;

/**
 * 动态赞
 * @param newsId 动态Id
 * @param userId 用户Id
 * @param iFlag  转发：0 收藏：1 赞：2
 */
-(void)newsZan:(NSString *)newsId andUserId:(NSString *)userId andIFlag:(NSString *)iFlag;

/**
 * 动态取消赞
 * @param newsId 动态Id
 * @param userId 用户Id
 * @param iFlag  转发：0 收藏：1 赞：2
 */
-(void)newsZanCancel:(NSString *)newsId andUserId:(NSString *)userId andIFlag:(NSString *)iFlag;

/**
 * 动态评论
 * @param newsId  动态Id
 * @param userId  用户Id
 * @param comment 评论内容
 */
-(void)messageComment:(NSString *)newsId andUserId:(NSString *)userId andComment:(NSString *)comment;

/**
 * 动态回复评论
 * @param newsId  动态回复Id
 * @param userId  用户Id
 * @param comment 评论内容
 */
-(void)commentComment:(NSString *)newsId andUserId:(NSString *)userId andComment:(NSString *)comment;

/**
 * 获取被关注列表
 * @param userId 用户Id
 */
-(void)selectFriended:(NSString *)userId;

/**
 * 获取申请好友列表
 * @param startRowIndex 开始索引
 * @param maximumRows   每页个数
 * @param userId        用户Id
 */
-(void)selectApplyList:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andUserId:(NSString *)userId;

/**
 * 获取通讯录
 * @param userId 用户Id
 */
-(void)getFriends:(NSString *)userId;

/**
 * 查询用户信息
 * @param startRowFriends 开始索引
 * @param maximumRows     每页条数
 * @param nicName         昵称
 * @param areaCode        地区code
 * @param age             年龄 0：不限 1：18岁以下 2：18-22岁 3：23-26岁 4：27-35岁 5：35以上
 * @param sexuality       性别 0：不限 1：男 2：女
 * @param userId          用户Id
 */
-(void)getFriendByAreaCodeAndSearch:(NSString *)startRowFriends andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaCode:(NSString *)areaCode andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserId:(NSString *)userId;

/**
 * 通讯录匹配，未注册不返回，注册之后判断是否为好友
 * @param userId   用户Id
 * @param contacts 通讯录手机号，多个用“&”拼接
 */
-(void)contactsMatch:(NSString *)userId andContacts:(NSString *)contacts;

/**
 * 创建群组
 * @param userId   用户Id
 * @param idList   邀请所有好友ID集合，用“A”拼接
 */
-(void)createGroup:(NSString *)userId andIdList:(NSString *)idList;

/**
 * 根据用户Id获取用户信息
 * @param userId 用户Id
 */
-(void)getUserInfoByUserId:(NSString *)userId andFriendId:(NSString *)friendId;

/**
 * 根据手机号查询用户信息
 * @param userId 用户Id
 * @param phone  手机号
 */
-(void)searchFriendByPhone:(NSString *)userId andPhone:(NSString *)phone;

/**
 * 添加好友
 * @param userId   用户Id
 * @param friendId 好友Id
 */
-(void)addFriend:(NSString *)userId andFriendId:(NSString *)friendId;

/**
 * 同意并加对方好友
 * @param applyId 申请列表ID
 */
-(void)agreeFriendAndSaveFriend:(NSString *)applyId;

/**
 * 聊天--获取武友信息
 * @param userId 用户Id
 */
-(void)getFriendForKeyValue:(NSString *)userId;

/**
 * 根据Id获取用户信息 -- 聊天
 * @param userId 用户Id
 */
-(NSDictionary *)getUserInfoByUserIDChat:(NSString *)userId;

/**
 * 根据用户ID查询所有参与的群组
 * @param userId 用户Id
 */
-(void)selectAllTeamByUserId:(NSString *)userId;

/**
 * 删除好友
 * @param userId   用户Id
 * @param friendId 好友Id
 */
-(void)deleteFriend:(NSString *)userId andFriendId:(NSString *)friendId;

/**
 * 编辑群组
 * @param groupId 群组Id
 * @param name    名称
 * @param userId  用户Id
 */
-(void)editGroup:(NSString *)groupId andName:(NSString *)name andUserId:(NSString *)userId;

/**
 * 获取群成员
 * @param groupId 群Id
 * @param userid  用户Id
 */
-(void)getGroupMember:(NSString *)groupId andUserId:(NSString *)userid;

/**
 * 修改好友备注名称
 * @param userId   用户Id
 * @param friendId 好友Id
 * @param rname    备注名称
 */
-(void)changeFriendRName:(NSString *)userId andFriendId:(NSString *)friendId andRname:(NSString *)rname;

/**
 * 邀请群成员
 * @param idList 好友ID集合，多个ID中间用“A”分割
 * @param teamid 群组ID
 */
-(void)yaoQing:(NSString *)idList andTeamId:(NSString *)teamid;

/**
 * 提出成员
 * @param idList 群成员ID集合（不是会员ID），多个ID中间用“A”分割
 * @param teamid 群组ID
 */
-(void)tiChu:(NSString *)idList andTeamId:(NSString *)teamid;

/**
 * 解散群组
 * @param userId  用户Id
 * @param groupId 群组Id
 */
-(void)dismissTeam:(NSString *)userId andGroupId:(NSString *)groupId;

/**
 * 删除动态
 * @param newsId 动态Id
 */
-(void)delDongtai:(NSString *)newsId;

@end
