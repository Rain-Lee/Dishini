//
//  MomentsItemViewController.m
//  ChatProject
//
//  Created by Rain on 16/7/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "MomentsItemViewController.h"
#import "UserMomentsViewController.h"
#import "PersonalViewController.h"
#import "DetailsViewController.h"

@interface MomentsItemViewController (){
    long long currentNewsId;
    long long currentCommentId;
    NSString *currentCommentContent;
    BOOL currentIsLike;
}

@end

@implementation MomentsItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView:3 andTitle:@"详情"];
    
    [self initData];
}

-(void) initData
{
    [Toolkit showWithStatus:@"加载中..."];
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDongtaiPageByFriendsCallBack:"];
    [dataProvider getDongtaiByNewsId:[Toolkit getStringValueByKey:@"Id"] andNewsId:_newsId];
}

-(void)getDongtaiPageByFriendsCallBack:(id)dict{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    [self deleteAllItem];
    [self addItemFunc:dict];
    [self endRefresh];
}

-(void)addItemFunc:(id)dict{
    @try {
        if ([dict[@"code"] intValue] == 200) {
            NSDictionary *item = dict[@"data"];
            if ([item[@"VideoPath"] isEqual:@""]) {
                DFTextImageLineItem *textImageItem = [[DFTextImageLineItem alloc] init];
                textImageItem.itemId = [item[@"Id"] intValue];
                textImageItem.userId = [item[@"UserId"] intValue];
                textImageItem.userAvatar = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"PhotoPath"]];
                textImageItem.userNick = item[@"RemarkName"];
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
                //videoItem.itemId = 10000000; //随便设置一个 待服务器生成
                videoItem.userId = [item[@"UserId"] intValue];
                videoItem.userAvatar = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"PhotoPath"]];
                videoItem.userNick = item[@"NicName"];
                videoItem.title = @"";
                videoItem.text = item[@"Content"];
                videoItem.location = @"";
                videoItem.ts = [Toolkit getTimeIntervalFromString:item[@"PublishTime"]];
                
                BOOL isLike = [[Toolkit judgeIsNull:item[@"IsLike"]] isEqual:@"1"] ? true : false;
                videoItem.isLike = isLike;
                
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initData" object:nil];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initData" object:nil];
        [Toolkit showSuccessWithStatus:@"操作成功~"];
    }
}


-(void)onClickUser:(NSUInteger)userId
{
    //点击左边头像 或者 点击评论和赞的用户昵称
    NSLog(@"onClickUser: %ld", userId);
    
    if ([[Toolkit getStringValueByKey:@"Id"] isEqual:[NSString stringWithFormat:@"%lu",(unsigned long)userId]]) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:true];
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = true;
        detailsVC.userId = [NSString stringWithFormat:@"%lu",(unsigned long)userId];
        detailsVC.iFlag = @"1";
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

-(void)onClickHeaderUserAvatar
{
    //[self onClickUser:1111];
}

-(void) refresh
{
    //下拉刷新
    [self initData];
}



-(void) loadMore
{
    [self endLoadMore];
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
