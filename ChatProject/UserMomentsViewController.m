//
//  UserMomentsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "UserMomentsViewController.h"
#import "MomentsItemViewController.h"
#import "DetailsViewController.h"
#import "PersonalViewController.h"

@interface UserMomentsViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    int index;
    UIImage *headImage;
}

@end

@implementation UserMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView:2 andTitle:_nickName];
    
    [self getUserInfoById];
    
    [self initData];
}

-(void)getUserInfoById{
    dispatch_async(dispatch_get_main_queue(), ^{
        DataProvider *dataUserInfo1 = [[DataProvider alloc] init];
        [dataUserInfo1 setDelegateObject:self setBackFunctionName:@"getUserInfoCallBack:"];
        [dataUserInfo1 getUserInfoByUserId:[Toolkit getStringValueByKey:@"Id"] andFriendId:_userId];
    });
}

-(void)getUserInfoCallBack:(id)dict{
    if ([dict[@"code"] intValue] == 200) {
        NSString *photoPath = [NSString stringWithFormat:@"%@%@",Kimg_path,[Toolkit judgeIsNull:dict[@"data"][@"PhotoPath"]]];
        [self setUserAvatar:photoPath];
        NSString *nickName = [Toolkit judgeIsNull:dict[@"data"][@"NicName"]];
        [self setUserNick:nickName];
    }
}

-(void) initData
{
    index = 0;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getDongtaiByUserIdCallBack:"];
    [dataProvider getDongtaiByUserId:_userId andStartRowFriends:@"0" andMaximumRows:@"10"];
}

-(void)getDongtaiByUserIdCallBack:(id)dict{
    [self deleteAllItem];
    [self addItemFunc:dict];
    [self endRefresh];
}

-(void)loadMoreFunc{
    index++;
    DataProvider *dataProvider = [[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"loadMoreFuncCallBack:"];
    [dataProvider getDongtaiByUserId:_userId andStartRowFriends:[NSString stringWithFormat:@"%d",index * 10] andMaximumRows:@"10"];
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
                DFTextImageUserLineItem *textImageItem = [[DFTextImageUserLineItem alloc] init];
                textImageItem.itemId = [item[@"Id"] intValue];
                textImageItem.ts = [Toolkit getTimeIntervalFromString:item[@"PublishTime"]];
                textImageItem.text = item[@"Content"];
                // 图片
                if ([item[@"PicList"] count] > 0) {
                    textImageItem.cover = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"PicList"][0][@"ImagePath"]];
                    textImageItem.photoCount = [item[@"PicList"] count];
                }
                // 视频
                if (![item[@"ImagePath"] isEqual:@""]) {
                    textImageItem.cover = [NSString stringWithFormat:@"%@%@",Kimg_path,item[@"ImagePath"]];
                }
                [self addItem:textImageItem];
            }
        }else{
            [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"error"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

-(void) refresh
{
    
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}


-(void) loadMore
{
    [self loadMoreFunc];
}



-(void)onClickItem:(DFBaseUserLineItem *)item
{
    NSLog(@"click item: %lld", item.itemId);
    
    MomentsItemViewController *momentsItemVC = [[MomentsItemViewController alloc] init];
    momentsItemVC.newsId = [NSString stringWithFormat:@"%lld",item.itemId];
    [self.navigationController pushViewController:momentsItemVC animated:true];
}

-(void)tapCoverViewEvent{
    if ([[Toolkit getStringValueByKey:@"Id"] isEqual:_userId]){
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
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *smallImage = [self scaleFromImage:image andSize:CGSizeMake(800, 800)];
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

-(void)onClickHeaderUserAvatar{
    if ([[Toolkit getStringValueByKey:@"Id"] isEqual:_userId]) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:true];
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = true;
        detailsVC.userId = _userId;
        detailsVC.iFlag = @"1";
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

@end
