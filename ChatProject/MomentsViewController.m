//
//  MomentsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MomentsViewController.h"
#import "UserMomentsViewController.h"
#import "SendVideoViewController.h"

@interface MomentsViewController ()<SendVideoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSString *currentVideoPath;
    UIImage *currentScreenShot;
    
    int index;
    UIImage *headImage;
    long long currentNewsId;
    long long currentCommentId;
    NSString *currentCommentContent;
    BOOL currentIsLike;
}

@end

@implementation MomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView:1 andTitle:@"朋友圈"];
    
    [self setHeader];
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeader) name:@"setHeader" object:nil];
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:@"initData" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [self initData];
}

-(void)setHeader
{
    
    NSString *avatarUrl = [Toolkit getStringValueByKey:@"PhotoPath"];
    [self setUserAvatar:avatarUrl];
    
    [self setUserNick:[Toolkit getStringValueByKey:@"NickName"]];
    
    //[self setUserSign:@"梦想还是要有的 万一实现了呢"];
    
}


-(void) initData
{
    index = 0;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDongtaiPageByFriendsCallBack:"];
    [dataProvider getDongtaiPageByFriends:[Toolkit getStringValueByKey:@"Id"] andStartRowIndex:@"0" andMaximumRows:@"10"];
}

-(void)getDongtaiPageByFriendsCallBack:(id)dict{
    [self deleteAllItem];
    [self addItemFunc:dict];
    [self endRefresh];
    [self endLoadMore];
}

-(void)loadMoreFunc{
    index++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"loadMoreFuncCallBack:"];
    [dataProvider getDongtaiPageByFriends:[Toolkit getStringValueByKey:@"Id"] andStartRowIndex:[NSString stringWithFormat:@"%d",index * 10] andMaximumRows:@"10"];
}

-(void)loadMoreFuncCallBack:(id)dict{
    [self addItemFunc:dict];
    [self endLoadMore];
}

-(void)addItemFunc:(id)dict{
    @try {
        if ([dict[@"code"] intValue] == 200) {
            if (![[Toolkit judgeIsNull:dict[@"SpaceImagePath"]] isEqual:@""]) {
                NSString *coverUrl = [NSString stringWithFormat:@"%@%@",Kimg_path, dict[@"SpaceImagePath"]];
                [self setCover:coverUrl];
            }
            
            for (NSDictionary *item in dict[@"data"]) {
                
                if ([item[@"VideoPath"] isEqual:@""]) {
                    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
                    textImageItem.itemId = [item[@"Id"] intValue];
                    textImageItem.userId = [item[@"UserId"] intValue];
                    textImageItem.userAvatar = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"PhotoPath"]];
                    textImageItem.userNick = [item[@"RemarkName"] isEqual:@""] ? item[@"NicName"] : item[@"RemarkName"];
                    textImageItem.title = @"";
                    textImageItem.text = item[@"Content"];
                    textImageItem.ts = [Toolkit getTimeIntervalFromString:item[@"PublishTime"]];
                    
                    BOOL isLike = [[Toolkit judgeIsNull:item[@"IsLike"]] isEqual:@"1"] ? true : false;
                    textImageItem.isLike = isLike;
                    
                    
                    // 图片
                    NSMutableArray *thumbImages = [NSMutableArray array];
                    for (NSDictionary *picItem in item[@"PicList"]) {
                        [thumbImages addObject:[NSString stringWithFormat:@"%@%@",Kimg_path, picItem[@"ImagePath"]]];
                    }
                    textImageItem.thumbImages = thumbImages;
                    NSMutableArray *srcImages = [NSMutableArray array];
                    for (NSDictionary *picItem in item[@"PicList"]) {
                        [srcImages addObject:[NSString stringWithFormat:@"%@%@",Kimg_path, picItem[@"ImagePath"]]];
                    }
                    textImageItem.srcImages = srcImages;
                    
                    // 评论
                    for (NSDictionary *commentItem in item[@"ComList"]){
                        DFLineCommentItem *lineItem = [[DFLineCommentItem alloc] init];
                        lineItem.commentId = [commentItem[@"Id"] intValue];
                        lineItem.userId = [commentItem[@"CommenterId"] intValue];
                        lineItem.userNick = commentItem[@"NicName"];
                        lineItem.text = commentItem[@"Content"];
                        NSString *parentId = [commentItem[@"ParentId"] stringValue];
                        if (![parentId isEqual:@"0"]) {
                            lineItem.replyUserId = [commentItem[@"CommentedId"] intValue];
                            lineItem.replyUserNick = commentItem[@"CommentedNicName"];
                        }
                        [textImageItem.comments addObject:lineItem];
                    }
                    
                    textImageItem.width = 640;
                    textImageItem.height = 360;
                    
                    [self addItem:textImageItem];
                }else{
                    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
                    videoItem.itemId = [item[@"Id"] intValue]; //随便设置一个 待服务器生成
                    videoItem.userId = [item[@"UserId"] intValue];
                    videoItem.userAvatar = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"PhotoPath"]];
                    videoItem.userNick = [item[@"RemarkName"] isEqual:@""] ? item[@"NicName"] : item[@"RemarkName"];
                    videoItem.title = @"";
                    videoItem.text = item[@"Content"];
                    videoItem.location = @"";
                    videoItem.ts = [Toolkit getTimeIntervalFromString:item[@"PublishTime"]];
                    
                    BOOL isLike = [[Toolkit judgeIsNull:item[@"IsLike"]] isEqual:@"1"] ? true : false;
                    videoItem.isLike = isLike;
                    
                    videoItem.localVideoPath = currentVideoPath;
                    videoItem.videoUrl = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"VideoPath"]]; //网络路径
                    videoItem.thumbUrl = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"ImagePath"]];
                    //videoItem.thumbImage = [UIImage imageNamed:@"index_1"]; //如果thumbImage存在 优先使用thumbImage
                    
                    // 评论
                    for (NSDictionary *commentItem in item[@"ComList"]){
                        DFLineCommentItem *lineItem = [[DFLineCommentItem alloc] init];
                        lineItem.commentId = [commentItem[@"Id"] intValue];
                        lineItem.userId = [commentItem[@"CommenterId"] intValue];
                        lineItem.userNick = commentItem[@"NicName"];
                        lineItem.text = commentItem[@"Content"];
                        NSString *parentId = [commentItem[@"ParentId"] stringValue];
                        if (![parentId isEqual:@"0"]) {
                            lineItem.replyUserId = [commentItem[@"CommentedId"] intValue];
                            lineItem.replyUserNick = commentItem[@"CommentedNicName"];
                        }
                        [videoItem.comments addObject:lineItem];
                    }
                    
                    [self addItem:videoItem];
                }
            }
        }else{
            [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(void)onCommentCreate:(long long)commentId text:(NSString *)text itemId:(long long) itemId
{
    currentCommentContent = text;
    currentNewsId = itemId;
    currentCommentId = commentId;
    
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"messageCommentCallBack:"];
    if (commentId == 0) {
        [dataProvider messageComment:[NSString stringWithFormat:@"%lld",itemId] andUserId:[Toolkit getStringValueByKey:@"Id"] andComment:text];
    }else{
        [dataProvider commentComment:[NSString stringWithFormat:@"%lld",commentId] andUserId:[Toolkit getStringValueByKey:@"Id"] andComment:text];
    }
}

-(void)messageCommentCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        DFLineCommentItem *commentItem = [[DFLineCommentItem alloc] init];
        commentItem.commentId = [dict[@"insertid"] intValue];
        commentItem.userId = [[Toolkit getStringValueByKey:@"Id"] intValue];
        commentItem.userNick = [Toolkit getStringValueByKey:@"NickName"];
        commentItem.text = currentCommentContent;
        [self addCommentItem:commentItem itemId:currentNewsId replyCommentId:currentCommentId];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"data"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)onLike:(long long)itemId andIsLike:(BOOL)isLike
{
    NSLog(@"---------------%d",isLike);
    
    currentIsLike = isLike;
    currentNewsId = itemId;
    
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"newsZanCallBack:"];
    
    if (currentIsLike) { // 取消赞
        [dataProvider newsZanCancel:[NSString stringWithFormat:@"%lld",itemId] andUserId:[Toolkit getStringValueByKey:@"Id"] andIFlag:@"2"];
    }else{ // 点赞
        [dataProvider newsZan:[NSString stringWithFormat:@"%lld",itemId] andUserId:[Toolkit getStringValueByKey:@"Id"] andIFlag:@"2"];
    }
}

-(void)newsZanCallBack:(id)dict{
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        if (currentIsLike) { // 取消赞
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickZanEvent" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",currentNewsId],@"itemId",@"0",@"isLike", nil]];
        }else{ // 点赞
            [[NSNotificationCenter defaultCenter] postNotificationName:@"clickZanEvent" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lld",currentNewsId],@"itemId",@"1",@"isLike", nil]];
        }
        [Toolkit showSuccessWithStatus:@"操作成功~"];
    }
}


-(void)onClickUser:(NSUInteger)userId
{
    //点击左边头像 或者 点击评论和赞的用户昵称
    NSLog(@"onClickUser: %ld", userId);
    
    UserMomentsViewController *userMomentsVC = [[UserMomentsViewController alloc] init];
    userMomentsVC.hidesBottomBarWhenPushed = true;
    userMomentsVC.nickName = @"个人动态";
    userMomentsVC.userId = [NSString stringWithFormat:@"%lu",(unsigned long)userId];
    [self.navigationController pushViewController:userMomentsVC animated:YES];
}

-(void)onClickHeaderUserAvatar
{
    UserMomentsViewController *userMomentsVC = [[UserMomentsViewController alloc] init];
    userMomentsVC.hidesBottomBarWhenPushed = true;
    userMomentsVC.nickName = @"个人动态";
    userMomentsVC.userId = [Toolkit getStringValueByKey:@"Id"];
    [self.navigationController pushViewController:userMomentsVC animated:YES];
}

-(void) refresh
{
    //下拉刷新
    [self initData];
}



-(void) loadMore
{
    //加载更多
    [self loadMoreFunc];
}



//选择照片后得到数据
-(void)onSendTextImage:(NSString *)text images:(NSArray *)images
{
    DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
    textImageItem.itemId = 10000000; //随便设置一个 待服务器生成
    textImageItem.userId = 10018;
    textImageItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    textImageItem.userNick = @"富二代";
    textImageItem.title = @"发表了";
    textImageItem.text = text;
    
    
    NSMutableArray *srcImages = [NSMutableArray array];
    textImageItem.srcImages = srcImages; //大图 可以是本地路径 也可以是网络地址 会自动判断
    
    NSMutableArray *thumbImages = [NSMutableArray array];
    textImageItem.thumbImages = thumbImages; //小图 可以是本地路径 也可以是网络地址 会自动判断
    
    
    for (id img in images) {
        [srcImages addObject:img];
        [thumbImages addObject:img];
    }
    
    textImageItem.location = @"广州信息港";
    [self addItemTop:textImageItem];
    
    
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
    
}


//发送视频 目前没有实现填写文字
-(void)onSendVideo:(NSString *)text videoPath:(NSString *)videoPath screenShot:(UIImage *)screenShot
{
    // 保存当前视频
    currentVideoPath = videoPath;
    currentScreenShot = screenShot;
    
    SendVideoViewController *sendVideoVC = [[SendVideoViewController alloc] init];
    sendVideoVC.delegate = self;
    sendVideoVC.hidesBottomBarWhenPushed = true;
    sendVideoVC.VideoFilePath=[NSURL fileURLWithPath:videoPath];
    [self.navigationController pushViewController:sendVideoVC animated:YES];
}

-(void)sendVideo{
    DFVideoLineItem *videoItem = [[DFVideoLineItem alloc] init];
    videoItem.itemId = 10000000; //随便设置一个 待服务器生成
    videoItem.userId = 10018;
    videoItem.userAvatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
    videoItem.userNick = @"富二代";
    videoItem.title = @"发表了";
    videoItem.text = @"新年过节 哈哈"; //这里需要present一个界面 用户填入文字后再发送 场景和发图片一样
    videoItem.location = @"广州";
    
    videoItem.localVideoPath = currentVideoPath;
    videoItem.videoUrl = @""; //网络路径
    videoItem.thumbUrl = @"";
    videoItem.thumbImage = currentScreenShot; //如果thumbImage存在 优先使用thumbImage
    
    [self addItemTop:videoItem];
    
    //接着上传图片 和 请求服务器接口
    //请求完成之后 刷新整个界面
}

-(void)tapCoverViewEvent{
    [Toolkit actionSheetViewSecond:self andTitle:nil andMsg:nil andCancelButtonTitle:@"取消" andOtherButtonTitle:[NSArray arrayWithObjects:@"拍照", @"从手机相册选择", nil] handler:^(int buttonIndex, UIAlertAction *alertView) {
        if (buttonIndex == 1) {
            // 拍照
            UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
            mImagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            mImagePick.delegate = self;
            mImagePick.allowsEditing = YES;
            [self presentViewController:mImagePick animated:YES completion:nil];
        }else if (buttonIndex == 2){
            // 从相册中选取
            UIImagePickerController *mImagePick = [[UIImagePickerController alloc] init];
            mImagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            mImagePick.delegate = self;
            mImagePick.allowsEditing = YES;
            [self presentViewController:mImagePick animated:YES completion:nil];
        }
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(500, 500)];
    NSData *imageData = UIImagePNGRepresentation(smallImage);
    headImage = smallImage;
    [self changeHeadBgImage:imageData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)changeHeadBgImage:(NSData *)data{
    [Toolkit showWithStatus:@"上传中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"didGetImageName:"];
    NSString *imagebase64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    [dataProvider UploadImgWithImgdata:imagebase64];
}

-(void)didGetImageName:(id)dict{
    [SVProgressHUD dismiss];
    if([dict[@"code"] intValue] == 200){
        NSLog(@"%@",dict);
        [Toolkit showWithStatus:@"正在保存..."];
        DataProvider *dataProvider = [[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"saveImageCallBack:"];
        [dataProvider saveSpaceImage:[Toolkit getStringValueByKey:@"Id"] andImagePath:dict[@"data"][@"BigImagePath"]];
    }
}

-(void)saveImageCallBack:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"code"] intValue] == 200) {
        [self setCoverImg:headImage];
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"date"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
}

-(void)onClickDelNews:(NSString *)newsId{
    NSLog(@"%@",newsId);
    [Toolkit alertView:self andTitle:@"提示" andMsg:@"确认删除动态?" andCancelButtonTitle:@"取消" andOtherButtonTitle:@"确定" handler:^(int buttonIndex, UIAlertAction *alertView) {
        if (buttonIndex == 1) {
            DataProvider *dataProvider = [[DataProvider alloc] init];
            [dataProvider setDelegateObject:self setBackFunctionName:@"delNewsCallBack:"];
            [dataProvider delDongtai:newsId];
        }
    }];
}

-(void)delNewsCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        [Toolkit showSuccessWithStatus:@"删除动态成功"];
        [self refresh];
    }else{
        [Toolkit showErrorWithStatus:@"删除动态失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
