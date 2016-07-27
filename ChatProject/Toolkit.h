//
//  Toolkit.h
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>


@interface Toolkit : NSObject

+(NSString *)getCurrentDate;

+(NSDate*)getDateFromString:(NSString*)dateString;

+(NSTimeInterval)getTimeIntervalFromString:(NSString *)dateString;

+(BOOL)isExitAccount;

+(void)showWithStatus:(NSString *)msg;

+(void)showInfoWithStatus:(NSString *)msg;

+(void)showSuccessWithStatus:(NSString *)msg;

+(void)showErrorWithStatus:(NSString *)msg;

+(void)setUserDefaultValue:(id)value andKey:(NSString *)key;

+(id)getUserDefaultValue:(NSString *)key;

+(NSString *)getStringValueByKey:(NSString *)key;

+(BOOL)getBoolValueByKey:(NSString *)key;

+(void)removeUserDefault:(NSString *)key;

+(void)clearUserDefaultCache; // 清空NSUserDefault

+(NSString *)phoneEdit:(NSString *)phoneNum;

+ (BOOL)isEnglishSysLanguage;
+ (BOOL)isSystemIOS7;
+(BOOL)isSystemIOS8;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+(NSString *) compareCurrentTime:(NSString *) compareDateStr;
+(NSString *)calculateAge:(NSString *)birthDay;
+(BOOL)judgeIsJumpLogin:(UIViewController *)viewcontroller;
+ (void) lowQuailtyWithInputURL:(NSURL*)inputURL
                      outputURL:(NSURL*)outputURL
                   handler:(void (^)(AVAssetExportSession *session, CGSize size))handler;
+ (CGFloat) getFileSize:(NSString *)path;
+(int)degressFromVideoFileWithURL:(NSURL *)url;
+(UIImage *)scaleFromImage:(UIImage *)image andSize:(CGSize)size;
+(NSString *)getImageStr:(NSString *)imageStr;

/**
 *根据nsstring 和 view的宽度计算高度
 */
+(CGFloat)heightWithString:(NSString*)string fontSize:(CGFloat)fontSize width:(CGFloat)width;
/**
 *根据nsstring 和 view的高度计算长度
 */
+(CGFloat)WidthWithString:(NSString*)string fontSize:(CGFloat)fontSize height:(CGFloat)heigh;
//返回rgba色值
+(NSMutableArray *)getColorRGBA:(UIColor *) color;
//添加划线api
+(UIImageView *)drawLine:(CGFloat)startX andSY:(CGFloat)startY andEX:(CGFloat)endX andEY:(CGFloat)endY andLW:(CGFloat)lineWidth andColor:(UIColor *)color andView:(UIView *)tempView;
//获取userId
+(NSString *)getUserID;
+(BOOL)isVip;
+(NSString *)judgeIsNull:(NSString *)str;
//显示顶部菊花
+(UIActivityIndicatorView*)showJuHua;
//检测当前是否登陆
+(BOOL)islogin;

//手机号隐藏中间四位
+(NSString *)phoneEncryption:(NSString *)phoneNum;

// 弹框
+(void)alertView:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler;

/// 只有两个，otherButtonTitle样式是UIAlertActionStyleDestructive
+(void)actionSheetViewFirst:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSString *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler;

/// 有多个，otherButtonTitle样式是UIAlertActionStyleDefault
+(void)actionSheetViewSecond:(id)target andTitle:(NSString *)title andMsg:(NSString *)msg andCancelButtonTitle:(NSString *)cancelButtonTitle andOtherButtonTitle:(NSArray *)otherButtonTitle handler:(void (^)(int buttonIndex, UIAlertAction *alertView))handler;

#pragma mark Plist
+(id)ReadPlist:(NSString*)FileName ForKey:(NSString *)key;
+(void)writePlist:(NSString*)FileName andContent:(id)content andKey:(NSString *)key;
+(void)delPlist:(NSString *)plist;
#pragma mark - camera

+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;

#pragma mark - 打电话
+(void)makeCall:(NSString *)phoneNum;
#pragma mark - time 

+(NSString *)GettitleForDate:(NSString *)dateStr;

// 判断是否为纯数字
+ (BOOL)isNumText:(NSString *)str;
@end
