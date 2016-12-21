//
//  DataProvider.m
//  BuerShopping
//
//  Created by 于金祥 on 15/5/30.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFURLRequestSerialization.h"
#import "SVProgressHUD.h"
#import "SBXMLParser.h"
#import "SecurityUtil.h"
#import "JSONKit.h"

@implementation DataProvider

// 登陆
-(void)login:(NSString *)username andPassword:(NSString *)password{
    
    if (username && password) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"username",
                                          @"password"]
                              andResult:@[@"Login",
                                          username,
                                          password
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
    
}

-(void)loginWithoutPassword:(NSString *)phone{
    if (phone) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"phone"]
                              andResult:@[@"LoginWithoutPassword",
                                          phone
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

// 注册
-(void)registerUser:(NSString *)phone andPassword:(NSString *)password andName:(NSString *)name{
    
    if (phone && password) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"phone",
                                          @"password",
                                          @"name"]
                              andResult:@[@"Register",
                                          phone,
                                          password,
                                          name
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

// 修改密码
-(void)changePwd:(NSString *)phone andOldPwd:(NSString *)oldPwd andPassword:(NSString *)password{
    
    if (phone && oldPwd && password) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"phone",
                                          @"oldpwd",
                                          @"password"]
                              andResult:@[@"ChangePassWordByPhone",
                                          phone,
                                          oldPwd,
                                          password
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

// 编辑用户信息
-(void)editUserInfo:(NSString *)userId andNickName:(NSString *)nickName andSex:(NSString *)sex andHomeAreaId:(NSString *)homeAreaId andDescription:(NSString *)description{
    NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
    
    NSString *json = [self setParam:@[@"function",
                                      @"userid",
                                      @"nicname",
                                      @"sexuality",
                                      @"height",
                                      @"weight",
                                      @"address",
                                      @"experience",
                                      @"description",
                                      @"birthday"
                                      ]
                          andResult:@[@"ChangeInfor",
                                      userId,
                                      nickName,
                                      sex,
                                      @"0",
                                      @"0",
                                      homeAreaId,
                                      @"0",
                                      description,
                                      @"1900/01/01"
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)getProvince{
    NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
    
    NSString *json = [self setParam:@[@"function"
                                      ]
                          andResult:@[@"GetProvince"
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)getCityByProvince:(NSString *)provinceCode{
    
    if (provinceCode) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"provinceCode"]
                              andResult:@[@"GetCityByProvince",
                                          provinceCode
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getCountyByCity:(NSString *)cityCode{
    if (cityCode) {
        
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"cityCode"]
                              andResult:@[@"GetCountyByCity",
                                          cityCode
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)upLoadPhoto:(NSString *)userId andImgData:(NSString *)filestream  andImgName:(NSString *)fileName{
    if (userId && filestream && fileName) {
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"fileName",
                                          @"filestream",
                                          @"userid"
                                          ]
                              andResult:@[@"UpLoadPhoto",
                                          fileName,
                                          filestream,
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)UploadImgWithImgdata:(NSString *)imageData
{
    if (imageData) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"fileName",
                                          @"filestream"
                                          ]
                              andResult:@[@"UpLoadImage",
                                          @"PhotoName.png",
                                          imageData
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getFriends:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid"
                                          ]
                              andResult:@[@"GetFriendForKeyValue",
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getDongtaiPageByFriends:(NSString *)userId andStartRowIndex:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows{
    if (userId && startRowIndex && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"startRowIndex",
                                          @"maximumRows"
                                          ]
                              andResult:@[@"GetDongtaiPageByFriends",
                                          userId,
                                          startRowIndex,
                                          maximumRows
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)SaveDongtai:(NSString *)userId andContent:(NSString *)content andPathlist:(NSString *)pathlist andVideoImage:(NSString *)videoImage andVideopath:(NSString *)videopath andVideoDuration:(NSString *)videoDuration andSmallImage:(NSString *)smallImage{
    if (userId && content && pathlist && videoImage && videopath && videoDuration && smallImage) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"content",
                                          @"pathlist",
                                          @"videoImage",
                                          @"videopath",
                                          @"videoDuration",
                                          @"smallImage"
                                          ]
                              andResult:@[@"SaveDongtai",
                                          userId,
                                          content,
                                          pathlist,
                                          videoImage,
                                          videopath,
                                          videoDuration,
                                          smallImage
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)saveSpaceImage:(NSString *)userId andImagePath:(NSString *)imagePath{
    if (userId && imagePath) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"imagepath"
                                          ]
                              andResult:@[@"SaveSpaceImage",
                                          userId,
                                          imagePath
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)upLoadVideo:(NSURL *)videoPath{
    if (videoPath) {
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:videoPath];
        NSString *imagebase64= [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"fileName",
                                          @"filestream"
                                          ]
                              andResult:@[@"UpLoadVideo",
                                          @"video.mov",
                                          imagebase64
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getDongtaiByUserId:(NSString *)userId andStartRowFriends:(NSString *)startRowFriends andMaximumRows:(NSString *)maximumRows{
    if (userId && startRowFriends && maximumRows) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"friendid",
                                          @"startRowIndex",
                                          @"maximumRows"
                                          ]
                              andResult:@[@"SelectDongtaiByFriendId",
                                          userId,
                                          startRowFriends,
                                          maximumRows
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getDongtaiByNewsId:(NSString *)userId andNewsId:(NSString *)newsId{
    if (userId && newsId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"messid"
                                          ]
                              andResult:@[@"GetDongtaiById",
                                          userId,
                                          newsId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)newsZan:(NSString *)newsId andUserId:(NSString *)userId andIFlag:(NSString *)iFlag{
    if (newsId && userId && iFlag) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"userid",
                                          @"flg"
                                          ]
                              andResult:@[@"MessageRepeatAndFavorite",
                                          newsId,
                                          userId,
                                          iFlag
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)newsZanCancel:(NSString *)newsId andUserId:(NSString *)userId andIFlag:(NSString *)iFlag{
    if (newsId && userId && iFlag) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"userid",
                                          @"flg"
                                          ]
                              andResult:@[@"MessageRepeatAndFavoriteCancel",
                                          newsId,
                                          userId,
                                          iFlag
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)messageComment:(NSString *)newsId andUserId:(NSString *)userId andComment:(NSString *)comment{
    if (newsId && userId && comment) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"userid",
                                          @"comment"
                                          ]
                              andResult:@[@"MessageComment",
                                          newsId,
                                          userId,
                                          comment
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)commentComment:(NSString *)newsId andUserId:(NSString *)userId andComment:(NSString *)comment{
    if (newsId && userId && comment) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id",
                                          @"userid",
                                          @"comment"
                                          ]
                              andResult:@[@"CommentComment",
                                          newsId,
                                          userId,
                                          comment
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)selectFriended:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid"
                                          ]
                              andResult:@[@"SelectFriended",
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)selectApplyList:(NSString *)startRowIndex andMaximumRows:(NSString *)maximumRows andUserId:(NSString *)userId{
    if (startRowIndex && maximumRows && userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"startRowIndex",
                                          @"maximumRows",
                                          @"userid"
                                          ]
                              andResult:@[@"SelectApplyList",
                                          startRowIndex,
                                          maximumRows,
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getFriendByAreaCodeAndSearch:(NSString *)startRowFriends andMaximumRows:(NSString *)maximumRows andNicName:(NSString *)nicName andAreaCode:(NSString *)areaCode andAge:(NSString *)age andSexuality:(NSString *)sexuality andUserId:(NSString *)userId{
    if (startRowFriends && maximumRows && nicName && areaCode && age && sexuality && userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"startRowFriends",
                                          @"maximumRows",
                                          @"nicName",
                                          @"areaCode",
                                          @"age",
                                          @"sexuality",
                                          @"userid"
                                          ]
                              andResult:@[@"GetFriendByAreaCodeAndSearch",
                                          startRowFriends,
                                          maximumRows,
                                          nicName,
                                          areaCode,
                                          age,
                                          sexuality,
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)contactsMatch:(NSString *)userId andContacts:(NSString *)contacts{
    if (userId && contacts) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"contacts"
                                          ]
                              andResult:@[@"ContactsMatch",
                                          userId,
                                          contacts
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)createGroup:(NSString *)userId andIdList:(NSString *)idList andImagePath:(NSString *)imagePath andTeamName:(NSString *)teamName{
    if (userId && idList) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"idlist",
                                          @"imagepath",
                                          @"teamname"
                                          ]
                              andResult:@[@"BuildTeam",
                                          userId,
                                          idList,
                                          imagePath,
                                          teamName
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getUserInfoByUserId:(NSString *)userId andFriendId:(NSString *)friendId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"friendid"
                                          ]
                              andResult:@[@"GetUserInfor",
                                          userId,
                                          friendId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)searchFriendByPhone:(NSString *)userId andPhone:(NSString *)phone{
    if (userId && phone) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"phone"
                                          ]
                              andResult:@[@"SearchFriendByPhone",
                                          userId,
                                          phone
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)addFriend:(NSString *)userId andFriendId:(NSString *)friendId{
    if (userId && friendId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"friendid"
                                          ]
                              andResult:@[@"SaveFriend",
                                          userId,
                                          friendId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)agreeFriendAndSaveFriend:(NSString *)applyId{
    if (applyId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"applyid"
                                          ]
                              andResult:@[@"AgreeFriendAndSaveFriend",
                                          applyId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getFriendForKeyValue:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid"
                                          ]
                              andResult:@[@"GetFriendForKeyValue",
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)selectAllTeamByUserId:(NSString *)userId{
    if (userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid"
                                          ]
                              andResult:@[@"SelectAllTeamByUserId",
                                          userId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)deleteFriend:(NSString *)userId andFriendId:(NSString *)friendId{
    if (userId && friendId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"friendid"
                                          ]
                              andResult:@[@"DeleteFriend",
                                          userId,
                                          friendId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)editGroup:(NSString *)groupId andName:(NSString *)name andUserId:(NSString *)userId andImagePath:(NSString *)imagePath{
    if (groupId && name && userId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"teamid",
                                          @"name",
                                          @"userid",
                                          @"imagepath"
                                          ]
                              andResult:@[@"EditTeam",
                                          groupId,
                                          name,
                                          userId,
                                          imagePath
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getGroupMember:(NSString *)groupId andUserId:(NSString *)userid{
    if (groupId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"teamid"
                                          ]
                              andResult:@[@"SelectTeamMember",
                                          userid,
                                          groupId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)getGroupInfoById:(NSString *)groupId{
    if (groupId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"teamid"
                                          ]
                              andResult:@[@"SelectTeam",
                                          groupId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)saveGroupInfo:(NSString *)groupId andContent:(NSString *)content{
    if (groupId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"teamid",
                                          @"content"
                                          ]
                              andResult:@[@"EditGonggao",
                                          groupId,
                                          content
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)changeFriendRName:(NSString *)userId andFriendId:(NSString *)friendId andRname:(NSString *)rname{
    if (userId && friendId && rname) {
        NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"friendid",
                                          @"rname"
                                          ]
                              andResult:@[@"ChangeFriendRName",
                                          userId,
                                          friendId,
                                          rname
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)yaoQing:(NSString *)idList andTeamId:(NSString *)teamid{
    if (idList && teamid) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"idlist",
                                          @"teamid",
                                          @"userid"
                                          ]
                              andResult:@[@"YaoQing",
                                          idList,
                                          teamid,
                                          [Toolkit getStringValueByKey:@"Id"]
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)tiChu:(NSString *)idList andTeamId:(NSString *)teamid{
    if (idList && teamid) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"idlist",
                                          @"teamid"
                                          ]
                              andResult:@[@"TiChu",
                                          idList,
                                          teamid
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)dismissTeam:(NSString *)userId andGroupId:(NSString *)groupId{
    if (userId && groupId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"teamid"
                                          ]
                              andResult:@[@"DismissTeam",
                                          userId,
                                          groupId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)delDongtai:(NSString *)newsId{
    if (newsId) {
        NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"id"
                                          ]
                              andResult:@[@"DelDongtai",
                                          newsId
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)selectGongGaoList:(NSString *)startRowIndex andmaximumRows:(NSString *)maximumRows{
    NSString *url = [NSString stringWithFormat:@"%@/SystemNews.asmx/Entry",Url];
    
    NSString *json = [self setParam:@[@"function",
                                      @"startRowIndex",
                                      @"maximumRows"
                                      ]
                          andResult:@[@"SelectGongGaoList",
                                      startRowIndex,
                                      maximumRows
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)updateSuggestion:(NSString *)userid andusername:(NSString *)username andtitle:(NSString *)title andcontent:(NSString *)content andpublishtime:(NSString *)publishtime anduserphone:(NSString *)userphone{
    if (userid && username && title && content && publishtime && userphone) {
        NSString *url = [NSString stringWithFormat:@"%@/Suggestion.asmx/Entry",Url];
        
        NSString *json = [self setParam:@[@"function",
                                          @"userid",
                                          @"username",
                                          @"title",
                                          @"content",
                                          @"publishtime",
                                          @"userphone"
                                          ]
                              andResult:@[@"UpdateSuggestion",
                                          userid,
                                          username,
                                          title,
                                          content,
                                          publishtime,
                                          userphone
                                          ]];
        
        NSDictionary * prm=@{@"args":json};
        [self PostRequest:url andpram:prm];
    }else{
        [SVProgressHUD dismiss];
    }
}

-(void)aboutUs{
    NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
    NSString *json = [self setParam:@[@"function"
                                      ]
                          andResult:@[@"SelectAboutUs"
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)getAllGonggaoByUserId:(NSString *)userId{
    NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
    NSString *json = [self setParam:@[@"function",
                                      @"userid"
                                      ]
                          andResult:@[@"GetAllGonggao",
                                      userId
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)editIsClose:(NSString *)userId andTeamid:(NSString *)teamid andisclose:(NSString *)isclose{
    NSString *url = [NSString stringWithFormat:@"%@/Friends.asmx/Entry",Url];
    NSString *json = [self setParam:@[@"function",
                                      @"userid",
                                      @"teamid",
                                      @"isclose"
                                      ]
                          andResult:@[@"EditIsClose",
                                      userId,
                                      teamid,
                                      isclose
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)reportUser:(NSString *)userId andTeamid:(NSString *)teamid andContent:(NSString *)content{
    NSString *url = [NSString stringWithFormat:@"%@/LoginAndRegister.asmx/Entry",Url];
    NSString *json = [self setParam:@[@"function",
                                      @"userId",
                                      @"targetId",
                                      @"content"
                                      ]
                          andResult:@[@"ReportUser",
                                      userId,
                                      teamid,
                                      content
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

-(void)getQrCode{
    NSString *url = [NSString stringWithFormat:@"%@/SystemNews.asmx/Entry",Url];
    NSString *json = [self setParam:@[@"function"
                                      ]
                          andResult:@[@"GetPicture"
                                      ]];
    
    NSDictionary * prm=@{@"args":json};
    [self PostRequest:url andpram:prm];
}

#pragma mark - 加密
#define YZkey @"fd15f548-7559-4d40-80a1-f00ca9bfcc02"
#define uid @"48a5f357-484f-4847-97b7-a44a2e73e8d5"
-(NSString *)setParam:(NSArray *)params andResult:(NSArray *)results
{
    
    NSString *json = @"";
    
    @try {
        if (params && results && params.count == results.count) {
            json = ZY_NSStringFromFormat(@"\"%@\":\"%@\"",params[0],results[0]);
            for (int i = 1; i < params.count ; i++) {
                if (((NSString *)params[i]).length >=5 && [[params[i] substringToIndex:5] isEqualToString:@"list_"]/*json字符串 不加“”*/ ) {
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":%@",json,params[i],results[i]);
                }
                else
                {
                    json = ZY_NSStringFromFormat(@"%@,\"%@\":\"%@\"",json,params[i],results[i]);
                    
                }
            }
            //添加key
            json = ZY_NSStringFromFormat(@"\"key\":\"%@\",\"uid\":\"%@\",%@",YZkey,uid,json);
            //添加｛｝
            json = ZY_NSStringFromFormat(@"{%@}",json);
            DLog(@"%@",json);
            return [self encryptionStr:json];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return json;
}

-(NSString *)encryptionStr:(NSString *)str
{
    NSString *securityStr;
    securityStr = [SecurityUtil encryptAESData:[NSString stringWithFormat:@"%lu&%@",(unsigned long)str.length,str]];
    return securityStr;
    
}

-(NSString *)encryptionStr11111:(NSString *)str
{
    NSString *securityStr;
    securityStr = [SecurityUtil decryptAESData:str];
    return securityStr;
    
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    
    callBackFunctionName = selectorName;
}

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    NSLog(@"----------------------------------------%f",[NSDate timeIntervalSinceReferenceDate]);
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/plain"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=20;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
//        /*解析xml字符串开始*/
//        SBXMLParser * parser = [[SBXMLParser alloc] init];
//        XMLElement * root = [parser parserXML:[str dataUsingEncoding:NSASCIIStringEncoding]];
//        NSLog(@"解析后：root=%@",root.text);
//        /*解析xml字符串结束*/
        NSLog(@"check time 1");
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [Toolkit showErrorWithStatus:@"请检查网络"];
//        [SVProgressHUD dismiss];
    }];
}




-(void)GetRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/xml"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage GET:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        /*解析xml字符串开始*/
        SBXMLParser * parser = [[SBXMLParser alloc] init];
        XMLElement * root = [parser parserXML:[str dataUsingEncoding:NSASCIIStringEncoding]];
        NSLog(@"解析后：root=%@",root.text);
        /*解析xml字符串结束*/
        
        NSData * data =[root.text dataUsingEncoding:NSUTF8StringEncoding];
        
        
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        [Toolkit showErrorWithStatus:@"请检查网络或防火墙"];
    }];
}

-(NSDictionary *)getUserInfoByUserIDChat:(NSString *)userID
{
    BOOL isTrue = false;
    NSString * urlstr=[NSString stringWithFormat:@"%@/LoginAndRegister.asmx/GetUserInforForIos",Url];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *urlrequest = [[NSMutableURLRequest alloc]initWithURL:url];
    urlrequest.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"userid=%@&friendid=%@",[Toolkit getStringValueByKey:@"Id"],userID];
    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    urlrequest.HTTPBody = body;
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
    requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [requestOperation start];
    [requestOperation waitUntilFinished];
    NSLog(@"%@",requestOperation.responseString);
    NSData * data =[requestOperation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSRange range = [requestOperation.responseString rangeOfString:@"\"msg\":\"0\""];
    if (range.location != NSNotFound) {
        isTrue = true;
    }
    if (!isTrue) {
        //SHOWALERT(@"错误", @"您需要联系开发人员");
    }
    return  dict;
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filestream" fileName:@"avatar.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [Toolkit showErrorWithStatus:@"请检查网络或防火墙"];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
//    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            file,@"FILES",
    
//                            @"avatar",@"name",
//                            key, @"key", nil];
//    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
//    NSLog(@"%@",result);
}

- (void)UploadImageWithImage:(NSData *)imagedata andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imagedata name:@"filestream" fileName:@"showorder_img.jpg" mimeType:@"image/jpg"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [Toolkit showErrorWithStatus:@"请检查网络或防火墙"];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    //    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            file,@"FILES",
    //                            @"avatar",@"name",
    //                            key, @"key", nil];
    //    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
    //    NSLog(@"%@",result);
}


- (void)uploadVideoWithFilePath:(NSURL *)videoPath andurl:(NSString *)url andprm:(NSDictionary *)prm
{
    NSData *itemdata=[NSData dataWithContentsOfURL:videoPath];
//    
//    NSData * data=[[NSData alloc] initWithBase64EncodedData:itemdata options:0];
    
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [itemdata base64EncodedStringWithOptions:0];
    
    
    // NSData from the Base64 encoded str
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64Encoded options:0];
    
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:prm constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"filestream" fileName:@"video.mov" mimeType:@"video/quicktime"];
    }];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
            [SVProgressHUD dismiss];
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
        [Toolkit showErrorWithStatus:@"请检查网络或防火墙"];
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    //    FileDetail *file = [FileDetail fileWithName:@"avatar.jpg" data:data];
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                            file,@"FILES",
    //                            @"avatar",@"name",
    //                            key, @"key", nil];
    //    NSDictionary *result = [HttpRequest upload:[NSString stringWithFormat:@"%@index.php?act=member_index&op=avatar_upload",Url] widthParams:params];
    //    NSLog(@"%@",result);
}
// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end
