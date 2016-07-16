//
//  ChatRoomViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/21.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "DetailsViewController.h"
#import "ChatLocationViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>
#import "PlayVideoView.h"
#import "BigImageShowViewController.h"
#import "GroupMoreViewController.h"
#import "UIImageView+WebCache.h"
#import "PersonalViewController.h"

@interface ChatRoomViewController ()<RCLocationPickerViewControllerDelegate>{
    UIViewController *recordController;
    PlayVideoView *playVideoView;
    UIImage *selectImage;
    BOOL isInGroup;
}

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isInGroup = true;
    
    [[RCIMClient sharedRCIMClient] getConversationNotificationStatus:ConversationType_GROUP targetId:self.targetId success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"success");
        NSLog(@"%lu",(unsigned long)nStatus);
    } error:^(RCErrorCode status) {
        NSLog(@"fail");
        isInGroup = false;
    }];
    
    [self initView];
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height);
    
    if ([_iFlag isEqual:@"2"]) {
        // 推荐好友
        RCImageMessage *imageMsg = [RCImageMessage messageWithImage:[self setSign].image];
        imageMsg.extra = [NSString stringWithFormat:@"654321;%@",[Toolkit getStringValueByKey:@"tjUserId"]];
        [self sendMessage:imageMsg pushContent:@""];
    }
}

-(UIImageView *)setSign{
    // mView
    UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    mView.backgroundColor = [UIColor whiteColor];
    mView.layer.masksToBounds = true;
    mView.layer.cornerRadius = 6;
    mView.layer.borderWidth = 0.5;
    mView.layer.borderColor = [UIColor greenColor].CGColor;
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 21)];
    titleLbl.font = [UIFont systemFontOfSize:20];
    titleLbl.textColor = [UIColor darkGrayColor];
    titleLbl.text = @"个人名片";
    [mView addSubview:titleLbl];
    // lineView
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), CGRectGetMaxY(titleLbl.frame) + 10, CGRectGetWidth(mView.frame) - CGRectGetMinX(titleLbl.frame) * 2, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [mView addSubview:lineView];
    // photoIv
    UIImageView *photoIv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), CGRectGetMaxY(lineView.frame) + 10, 70, 70)];
    if ([[Toolkit getStringValueByKey:@"tjPhotoPath"] isEqual:Kimg_path]) {
        photoIv.image = [UIImage imageNamed:@"default_photos"];
    }else{
        [photoIv sd_setImageWithURL:[NSURL URLWithString:[Toolkit getStringValueByKey:@"tjPhotoPath"]] placeholderImage:[UIImage imageNamed:@"default_photos"]];
    }
    photoIv.layer.masksToBounds = true;
    photoIv.layer.cornerRadius = 6;
    [mView addSubview:photoIv];
    // nameLbl
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photoIv.frame) + 15, CGRectGetMinY(photoIv.frame), 250, CGRectGetHeight(photoIv.frame))];
    nameLbl.font = [UIFont systemFontOfSize:20];
    nameLbl.text = [Toolkit getStringValueByKey:@"tjName"];
    [mView addSubview:nameLbl];
    
    return [self customSnapshoFromView:mView];
}

- (UIImageView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void)initView{
    // topView
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Header_Height)];
    topView.backgroundColor = navi_bar_bg_color;
    [self.view addSubview:topView];
    // titleLbl
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, NavigationBar_HEIGHT)];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = self.title;
    [topView addSubview:titleLbl];
    // leftBtn
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBtn setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(clickLeftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    if (self.conversationType == ConversationType_GROUP && isInGroup) {
        // rightBtn
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 75 - 14, StatusBar_HEIGHT, 75, NavigationBar_HEIGHT)];
        rightBtn.titleLabel.textColor = [UIColor whiteColor];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBtn setImage:[UIImage imageNamed:@"moreNoword"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickRightBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:rightBtn];
    }
    
    //自定义面板功能扩展
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"sendVideo"]
                                        title:@"小视频"
                                          tag:101];
}

- (void)clickLeftBtnEvent{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)clickRightBtnEvent{
    if (isInGroup) {
        GroupMoreViewController *groupMoreVC = [[GroupMoreViewController alloc] init];
        groupMoreVC.groupId = self.targetId;
        groupMoreVC.groupName = self.title;
        [self.navigationController pushViewController:groupMoreVC animated:true];
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    NSLog(@"%@",userId);
    if ([userId isEqual:[Toolkit getStringValueByKey:@"Id"]]) {
        PersonalViewController *personalVC = [[PersonalViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:true];
    }else{
        DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
        detailsVC.userId = userId;
        detailsVC.iFlag = @"1";
        [self.navigationController pushViewController:detailsVC animated:true];
    }
}

- (void)locationPicker:(ChatLocationViewController *)locationPicker
     didSelectLocation:(CLLocationCoordinate2D)location
          locationName:(NSString *)locationName
         mapScreenShot:(UIImage *)mapScreenShot {
    RCLocationMessage *locationMessage =
    [RCLocationMessage messageWithLocationImage:mapScreenShot
                                       location:location
                                   locationName:locationName];
    [self sendMessage:locationMessage pushContent:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case  PLUGIN_BOARD_ITEM_LOCATION_TAG : {
            {
                ChatLocationViewController * chatlocationVC=[[ChatLocationViewController alloc] init];
                chatlocationVC.delegate=self;
                [self.navigationController pushViewController:chatlocationVC animated:YES];
            }
            break;
        case 101:{
            QupaiSDK *sdkqupai = [QupaiSDK shared];
            [sdkqupai setDelegte:(id<QupaiSDKDelegate>)self];
            
            /*可选设置*/
            sdkqupai.thumbnailCompressionQuality =0.3;
            sdkqupai.combine = YES;
            sdkqupai.progressIndicatorEnabled = YES;
            sdkqupai.beautySwitchEnabled = NO;
            sdkqupai.flashSwitchEnabled = NO;
            sdkqupai.tintColor = [UIColor orangeColor];
            sdkqupai.localizableFileUrl = [[NSBundle mainBundle] URLForResource:@"QPLocalizable_en" withExtension:@"plist"];
            sdkqupai.bottomPanelHeight = 120;
            sdkqupai.recordGuideEnabled = YES;
            
            /*基本设置*/
            CGSize videoSize = CGSizeMake(320, 240);
            recordController = [sdkqupai createRecordViewControllerWithMinDuration:2
                                                                       maxDuration:8
                                                                           bitRate:500000
                                                                         videoSize:videoSize];
            [self presentViewController:recordController animated:YES completion:nil];
        }
            break;
        default:
            [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
            break;
        }
    }
}

//趣拍取消
-(void)qupaiSDKCancel:(QupaiSDK *)sdk
{
    [recordController dismissViewControllerAnimated:YES completion:nil];
}

-(void)qupaiSDK:(QupaiSDK *)sdk compeleteVideoPath:(NSString *)videoPath thumbnailPath:(NSString *)thumbnailPath
{
    [recordController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",videoPath);
    [Toolkit showWithStatus:@"发送中..."];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    [dataprovider upLoadVideo:[NSURL fileURLWithPath:videoPath]];
}

-(void)sendVideoCallBack:(id)dict{
    [SVProgressHUD dismiss];
    @try {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",Kimg_path,[dict[@"data"] valueForKey:@"ImagePath"]];
        UIImage *mImage = [self addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]] toImage:[UIImage imageNamed:@"ltplay"]];
        RCImageMessage *imageMsg = [RCImageMessage messageWithImage:mImage];
        imageMsg.extra = [NSString stringWithFormat:@"%@;%@",@"123456",[NSString stringWithFormat:@"%@%@",Kimg_path,[dict[@"data"] valueForKey:@"VideoPath"]]];
        imageMsg.imageUrl = [NSString stringWithFormat:@"%@%@",Kimg_path,[dict[@"data"] valueForKey:@"ImagePath"]];
        [self sendImageMessage:imageMsg pushContent:@"nihao"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake((image1.size.width - 80) / 2, (image1.size.height - 80) / 2, 80, 80)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)presentImagePreviewController:(RCMessageModel *)model{
    @try {
        NSString *mExtra = ((RCImageMessage *)model.content).extra;
        NSString *sendContentType = [mExtra substringToIndex:6];
        NSLog(@"%@",sendContentType);
        if ([sendContentType isEqual:@"123456"]) {
            NSString *videoUrl = [mExtra substringFromIndex:7];
            playVideoView = [[PlayVideoView alloc] initWithContent:@"" andVideoUrl:videoUrl];
            [playVideoView show];
        }else if ([sendContentType isEqual:@"654321"]){
            NSString *userId = [mExtra substringFromIndex:7];
            if ([userId isEqual:[NSString stringWithFormat:@"Id"]]) {
                PersonalViewController *personalVC = [[PersonalViewController alloc] init];
                [self.navigationController pushViewController:personalVC animated:true];
            }else{
                DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
                detailsVC.userId = userId;
                detailsVC.iFlag = @"1";
                [self.navigationController pushViewController:detailsVC animated:true];
            }
        }else{
            BigImageShowViewController *bigImageShowVC = [[BigImageShowViewController alloc] init];
            bigImageShowVC.imgUrl = ((RCImageMessage *)model.content).imageUrl;
            NSLog(@"%@",model.extra);
            selectImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:((RCImageMessage *)model.content).imageUrl]];
            [self.navigationController pushViewController:bigImageShowVC animated:YES];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage{
    UIImageWriteToSavedPhotosAlbum(selectImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [Toolkit showSuccessWithStatus:@"保存成功~"];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"已存入手机相册~" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        
    }else{
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"保存失败~" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
    }
    
}

@end
