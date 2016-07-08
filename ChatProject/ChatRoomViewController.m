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
#import "SimpleMessage.h"
#import "SimpleMessageCell.h"
#import <CoreMotion/CoreMotion.h>
#import <ALBBQuPaiPlugin/ALBBQuPaiPlugin.h>
#import "PlayVideoView.h"
#import "BigImageShowViewController.h"

@interface ChatRoomViewController ()<RCLocationPickerViewControllerDelegate>{
    UIViewController *recordController;
    PlayVideoView *playVideoView;
    UIImage *selectImage;
}

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, Header_Height, SCREEN_WIDTH, SCREEN_HEIGHT - Header_Height);
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
    
    //会话页面注册 UI
    [self registerClass:[SimpleMessageCell class] forCellWithReuseIdentifier:@"SimpleMessageCell"];
    
    //自定义面板功能扩展
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"span"]
                                        title:@"小视频"
                                          tag:101];
}

- (void)clickLeftBtnEvent{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didTapCellPortrait:(NSString *)userId{
    NSLog(@"%@",userId);
    DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
    detailsVC.userId = userId;
    detailsVC.iFlag = @"1";
    [self.navigationController pushViewController:detailsVC animated:true];
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
    NSLog(@"%@",videoPath);
    
    UIImage *mImage = [self addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg"]]] toImage:[UIImage imageNamed:@"ltplay"]];
    
    RCImageMessage *imageMsg = [RCImageMessage messageWithImage:mImage];
    //imageMsg.extra = [NSString stringWithFormat:@"%@;%@",@"123456",[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"VideoName"]]];
    imageMsg.imageUrl = @"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg";
    [self sendImageMessage:imageMsg pushContent:@"nihao"];
    
    [recordController dismissViewControllerAnimated:YES completion:nil];
    
    //DataProvider * dataprovider=[[DataProvider alloc] init];
    
    //[dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    
    //[dataprovider uploadVideoWithPath:filePath];
    //[SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - WechatShortVideoDelegate
- (void)finishWechatShortVideoCapture:(NSURL *)filePath {
    NSLog(@"filePath is %@", filePath);
    //UIImage *mImage = [self addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg"]]] toImage:[UIImage imageNamed:@"ltplay"]];
    
    //RCImageMessage *imageMsg = [RCImageMessage messageWithImage:mImage];
    //imageMsg.extra = [NSString stringWithFormat:@"%@;%@",@"123456",[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"VideoName"]]];
    //imageMsg.imageUrl = @"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg";
    //[self sendImageMessage:imageMsg pushContent:@"nihao"];
    //DataProvider * dataprovider=[[DataProvider alloc] init];
    
    //[dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    
    //[dataprovider uploadVideoWithPath:filePath];
    //[SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
}

-(void)sendVideoCallBack:(id)dict{
    UIImage *mImage = [self addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://img.ivsky.com/img/tupian/pre/201312/04/nelumbo_nucifera-009.jpg"]]] toImage:[UIImage imageNamed:@"ltplay"]];
    
    RCImageMessage *imageMsg = [RCImageMessage messageWithImage:mImage];
    imageMsg.extra = [NSString stringWithFormat:@"%@;%@",@"123456",[NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"VideoName"]]];
    imageMsg.imageUrl = [NSString stringWithFormat:@"%@%@",Url,[dict[@"data"] valueForKey:@"ImageName"]];
    [self sendImageMessage:imageMsg pushContent:@"nihao"];
}

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake((image1.size.width - 120) / 2, (image1.size.height - 120) / 2, 120, 120)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

- (void)presentImagePreviewController:(RCMessageModel *)model{
    NSString *mExtra = ((RCImageMessage *)model.content).extra;
    NSString *sendContentType = [mExtra substringToIndex:6];
    if ([sendContentType isEqual:@"123456"]) {
        NSString *videoUrl = [mExtra substringFromIndex:7];
        playVideoView = [[PlayVideoView alloc] initWithContent:@"" andVideoUrl:videoUrl];
        [playVideoView show];
    }else{
        BigImageShowViewController *bigImageShowVC = [[BigImageShowViewController alloc] init];
        bigImageShowVC.imgUrl = ((RCImageMessage *)model.content).imageUrl;
        NSLog(@"%@",model.extra);
        selectImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:((RCImageMessage *)model.content).imageUrl]];
        [self.navigationController pushViewController:bigImageShowVC animated:YES];
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
