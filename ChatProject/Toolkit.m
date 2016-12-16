//
//  Toolkit.m
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "Toolkit.h"
#import "LoginViewController.h"

@implementation Toolkit


#pragma mark - add by wangjc

+(NSString *)getCurrentDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+(NSDate*)getDateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

+(NSString *)getStringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

+(NSTimeInterval)getTimeIntervalFromString:(NSString *)dateString{
    NSDate *timeDate = [Toolkit getDateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[timeDate timeIntervalSince1970]];
    return timeSp.longLongValue * 1000;
}

+(NSString *)getTimeFromTimeInterval:(long long)time{
    NSDate *timeDate = [[NSDate alloc] initWithTimeIntervalSince1970:time / 1000];
    return [Toolkit getStringFromDate:timeDate];
}

+(NSString *)sendMsgValication:(NSString *)phone{
    NSString *randomNum = [Toolkit randomNum:6];
    NSString *sendMsg = [NSString stringWithFormat:@"【IPIC】尊敬的用户您好，感谢您注册IPIC账号，本次注册的验证码为：%@，请妥善保管",randomNum];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://118.145.18.170:8080/sms.aspx"]];
    request.HTTPMethod = @"POST";
    NSString *strTemp = [NSString stringWithFormat:@"action=send&userid=2375&account=twslkj&password=a123123&mobile=%@&content=%@&sendTime=&extno=",phone,sendMsg];
    request.HTTPBody = [strTemp dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",newStr);
    }];
    return randomNum;
}

+(NSString *)randomNum:(int)numLength{
    int num = (arc4random() % (int)pow(10, numLength));
    NSString *randomNumber = [NSString stringWithFormat:@"%.6d", num];
    return randomNumber;
}

+(BOOL)isExitAccount{
    return [[Toolkit getStringValueByKey:@"Id"] isEqual:@""] ? false : true;
}

+(void)showWithStatus:(NSString *)msg{
    [SVProgressHUD showWithStatus:msg];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+(void)showInfoWithStatus:(NSString *)msg{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showInfoWithStatus:msg];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+(void)showSuccessWithStatus:(NSString *)msg{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showSuccessWithStatus:msg];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+(void)showErrorWithStatus:(NSString *)msg{
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD showErrorWithStatus:msg];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

+(void)dismiss{
    [SVProgressHUD dismiss];
}

+(void)setUserDefaultValue:(id)value andKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
}

+(id)getUserDefaultValue:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@",[userDefault valueForKey:key]];
}

+(NSString *)getStringValueByKey:(NSString *)key{
    id value = [Toolkit getUserDefaultValue:key];
    if ([[Toolkit judgeIsNull:value] isEqual:@""]){
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",value];
    }
}

+(BOOL)getBoolValueByKey:(NSString *)key{
    id value = [Toolkit getUserDefaultValue:key];
    if ([[Toolkit judgeIsNull:value] isEqual:@""]){
        return false;
    }else{
        return [NSString stringWithFormat:@"%@",value].boolValue;
    }
}

+(void)removeUserDefault:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
}

+(void)clearUserDefaultCache{
    //清空 NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    // 引导图  true 不显示引导图
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"firstStart"];
}

+(void)makeCall:(NSString *)phoneNum
{
    if(phoneNum ==nil||phoneNum.length==0)
    {
        return;
    }
    
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

+(NSString *)phoneEdit:(NSString *)phoneNum{
    if (phoneNum == nil || phoneNum.length == 0) {
        return @"";
    }
    if (phoneNum.length < 11) {
        return phoneNum;
    }
    NSMutableString *str = [NSMutableString stringWithString:phoneNum];
    [str insertString:@"-" atIndex:3];
    [str insertString:@"-" atIndex:8];
    return str;
}

+(NSString *)phoneEncryption:(NSString *)phoneNum{
    if (phoneNum == nil || phoneNum.length == 0) {
        return @"";
    }
    if (phoneNum.length < 11) {
        return phoneNum;
    }
    phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return phoneNum;
}

+(UIApplication*)showJuHua
{
    
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    
    return application;
}

+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.height;
}


//根据字符串计算宽度
+(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)height
{
    NSDictionary *attrs = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return  [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size.width;
}



+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView
{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:tempView.frame];
    [tempView addSubview:imageView];
    
    CGFloat R, G, B,A;
    
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);  //线宽
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), R,G, B, A);  //颜色
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startX, startY);  //起点坐标
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endX, endY);   //终点坐标
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return imageView;
}

+(NSMutableArray *)getColorRGBA:(UIColor *) color
{
    CGColorRef colorRef = [color CGColor];
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        
        NSMutableArray *rgbaArr = [NSMutableArray array];
        for (int i = 0; i<numComponents; i++) {
            [rgbaArr addObject:[NSString stringWithFormat:@"%lf",components[i]]];
        }
        return rgbaArr;
    }
    else
    {
        return nil;
    }
}


+(NSString *)getUserID
{
    
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                  NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//    NSDictionary *userInfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];//read plist
//    NSString *userID = [userInfoWithFile objectForKey:@"id"];//获取userID

    NSUserDefaults *mUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *userID = [mUserDefault valueForKey:@"Id"];//获取userID
    return  userID;

}

+(NSString *)judgeIsNull:(NSString *)str{
    str = [NSString stringWithFormat:@"%@",str];
    if([str isEqual:@""] || [str isEqual:[NSNull null]] || [str isEqual:@"(null)"]){
        return @"";
    }
    return str;
}

+(BOOL)isVip
{
    if([get_sp(@"IsPay") intValue] == 1)
        return  YES;
    else
        return NO;
}


+(BOOL)islogin
{
    NSString *str = get_sp(@"OUTLOGIN") ;
    
    if (str == nil || [str isEqualToString:@"YES"]) {
        return NO;
    }
    
    return YES;
}

+(BOOL)judgeIsJumpLogin:(UIViewController *)viewcontroller{
    if (![Toolkit islogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [viewcontroller presentViewController:loginVC animated:YES completion:nil];
        return true;
    }else{
        return false;
    }
}

+(NSString *)getImageStr:(NSString *)imageStr{
    if (imageStr.length > 5 && [[imageStr substringToIndex:4] isEqual:@"http"]) {
        return imageStr;
    }else{
        return [NSString stringWithFormat:@"%@%@",Url,imageStr];
    }
}

+(void)lowQuailtyWithInputURL:(NSURL *)inputURL outputURL:(NSURL*)outputURL handler:(void (^)(AVAssetExportSession *session, CGSize size))handler{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
    
    CGAffineTransform translateToCenter;
    CGAffineTransform mixedTransform;
    AVMutableVideoComposition *waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
    waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    int degrees = [Toolkit degressFromVideoFileWithURL:inputURL];
    if (degrees == 0) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
        session.outputURL = outputURL;
        session.outputFileType = AVFileTypeQuickTimeMovie;
        [session exportAsynchronouslyWithCompletionHandler:^(void)
         {
             handler(session,videoTrack.naturalSize);
         }];
    }else{
        if(degrees == 90){
            //顺时针旋转90°
            NSLog(@"视频旋转90度,home按键在左");
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        }else if(degrees == 180){
            //顺时针旋转180°
            NSLog(@"视频旋转180度，home按键在上");
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
        }else if(degrees == 270){
            //顺时针旋转270°
            NSLog(@"视频旋转270度，home按键在右");
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        }
        
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        //将视频方向旋转加入到视频处理中
        waterMarkVideoComposition.instructions = @[roateInstruction];
        
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
        session.outputURL = outputURL;
        session.videoComposition = waterMarkVideoComposition;
        session.outputFileType = AVFileTypeQuickTimeMovie;
        [session exportAsynchronouslyWithCompletionHandler:^(void)
         {
             handler(session,waterMarkVideoComposition.renderSize);
         }];
    }
}

+(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(void)alertView:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButtonTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler != nil) {
                handler(0, action);
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (otherButtonTitle != nil) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (handler != nil) {
                handler(1, action);
            }
        }];
        [alertController addAction:otherAction];
    }
    
    [target presentViewController:alertController animated:true completion:nil];
}

+(void)actionSheetViewFirst:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    if (cancelButtonTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler != nil) {
                handler(0, action);
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (otherButtonTitle != nil) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (handler != nil) {
                handler(1, action);
            }
        }];
        [alertController addAction:otherAction];
    }
    
    [target presentViewController:alertController animated:true completion:nil];
}

+(void)actionSheetViewSecond:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSArray *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    if (cancelButtonTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (handler != nil) {
                handler(0, action);
            }
        }];
        [alertController addAction:cancelAction];
    }
    if (otherButtonTitle != nil) {
        for (int i = 0; i < otherButtonTitle.count; i++) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (handler != nil) {
                    handler(i + 1, action);
                }
            }];
            [alertController addAction:otherAction];
        }
    }
    
    [target presentViewController:alertController animated:true completion:nil];
}

+(int)degressFromVideoFileWithURL:(NSURL *)url
{
    int degress = 0;
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    
    return degress;
}

+ (CGFloat) getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}

#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark - plist file 

+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key
{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];

    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        dic = [NSDictionary dictionaryWithContentsOfFile:filename];
        return dic[key];
    }
    else
    {
        return dic[key];
    }

}



+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:FileName];
    
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:filename];
   
    
    NSLog(@"dic is:%@",dic);
    
    if(dic == nil)
    {
        //1. 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filename contents:nil attributes:nil];
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    else
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:dic];
        
        [tempDict setObject:content forKey:key];
        [tempDict writeToFile:filename atomically:YES];
    }
    
}


+(void)delPlist:(NSString *)plist
{
    //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
    NSFileManager *fileMger = [NSFileManager defaultManager];
    
    NSString *xiaoXiPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:plist];
    
    //如果文件路径存在的话
    BOOL bRet = [fileMger fileExistsAtPath:xiaoXiPath];
    
    if (bRet) {
        
        NSError *err;
        
        [fileMger removeItemAtPath:xiaoXiPath error:&err];
    }
}


#pragma mark - time 


+(NSString *)GettitleForDate:(NSString *)dateStr
{
    @try {
        NSString * resultStr=@"";
        
        if (dateStr.length>0) {
            
            NSDate * nowDate=[NSDate date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *date = [dateFormatter dateFromString:dateStr];
            
            NSTimeInterval a_hour = 60*60;
            
            NSDate *other = [date addTimeInterval: a_hour];
            
            
            
            if ([nowDate compare:other]==NSOrderedDescending) {
                
                NSTimeInterval a_day = 24*60*60;
                
                NSDate *othersecond = [[self extractDate:date] addTimeInterval: a_day];
                if ([nowDate compare:othersecond]==NSOrderedDescending) {
                    if ([nowDate compare:[othersecond addTimeInterval:a_day]]==NSOrderedDescending) {
                        if ([nowDate compare:[[othersecond addTimeInterval:a_day] addTimeInterval:a_day] ]==NSOrderedDescending) {
                            [dateFormatter setDateFormat:@"MM月dd日"];
                            NSString *strHour = [dateFormatter stringFromDate:date];
                            return [NSString stringWithFormat:@"%@",strHour];
                        }
                        else
                        {
                            return @"前天发布";
                        }
                    }
                    else
                    {
                        return @"昨天发布";
                    }
                }
                else
                {
                    [dateFormatter setDateFormat:@"HH:mm"];
                    NSString *strHour = [dateFormatter stringFromDate:date];
                    return [NSString stringWithFormat:@"%@",strHour];
                }
            }
            else
            {
                return @"刚刚发布";
            }
        }
        
        return resultStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        
    }
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+(NSString *) compareCurrentTime:(NSString *) compareDateStr
//
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *compareDate = [dateFormatter dateFromString:compareDateStr];
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = @"刚刚";
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSString *)calculateAge:(NSString *)birthDay
{
    if (birthDay == nil || [birthDay isEqual:@""]) {
        return @"";
    }
    NSString *age;
    NSString *now;
    NSInteger numAge;
    now = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSInteger bYear = [[birthDay substringToIndex:4] integerValue];
    NSInteger nYear = [[now substringToIndex:4] integerValue];
    
    NSRange tempRang;
    tempRang.length = 2;
    tempRang.location = 5;
    NSInteger bMonth = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nMonth = [[now substringWithRange:tempRang] integerValue];
    
    tempRang.length = 2;
    tempRang.location =8;
    NSInteger bDay = [[birthDay substringWithRange:tempRang] integerValue];
    NSInteger nDay = [[now substringWithRange:tempRang] integerValue];
    
    
    if(bYear > nYear)
        return @"0";
    numAge = nYear - bYear;
    
    if(bMonth>nMonth)//不到生日减一岁
    {
        if(numAge >0)
            numAge--;
    }
    else if(bMonth == nMonth)
    {
        if(bDay > nDay)
        {
            if(numAge >0)
                numAge--;
        }
    }
    
    age = [NSString stringWithFormat:@"%ld",(long)numAge];
    return age;
}

+ (NSDate *)extractDate:(NSDate *)date {
    if (!date) {
        date=[NSDate date];
    }
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

#pragma mark  - old

+ (BOOL)isSystemIOS7
{
     
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0&&[[[UIDevice currentDevice] systemVersion] floatValue] < 8.0? YES : NO;
}
+ (BOOL)isSystemIOS8
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO;
}



//+ (NSString *)getSystemLanguage
//{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:kSystemLanguage];
//}
//
//+ (void)setSystemLanguage:(NSString *)strLanguage
//{
//    if (strLanguage)
//        [[NSUserDefaults standardUserDefaults] setObject:strLanguage forKey:kSystemLanguage];
//}

//+(UIImage *)drawsimiLine:(UIImageView *)imageView
//{
//    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
//    
//    CGFloat lengths[] = {5,5};
//    CGContextRef line = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(line, [UIColor whiteColor].CGColor);
//    
//    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
//    CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
//    CGContextAddLineToPoint(line, 310.0, 20.0);
//    CGContextStrokePath(line);
//    
//    return UIGraphicsGetImageFromCurrentImageContext();
//}

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
/******************************************************************************
 函数名称 : + (NSString *)base64EncodedStringFrom:(NSData *)data
 函数描述 : 文本数据转换为base64格式字符串
 输入参数 : (NSData *)data
 输出参数 : N/A
 返回参数 : (NSString *)
 备注信息 :
 ******************************************************************************/
+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

//+ (void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    [tableView setTableFooterView:view];
//}

 + (BOOL)isEnglishSysLanguage
 {
     return NO;
     //return [[self getSystemLanguage] isEqualToString:kEnglish] ? YES : NO;
 }


+ (BOOL)isNumText:(NSString *)str{
    
    NSString * regex        = @"(/^[0-9]*$/)";
    
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch            = [pred evaluateWithObject:str];
    
    if (isMatch) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}


@end
