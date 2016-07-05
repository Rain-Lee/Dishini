//
//  UploadDataToServer.m
//  KongFuCenter
//
//  Created by Wangjc on 15/12/23.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "UploadDataToServer.h"
@interface UploadDataToServer ()
{
    NSInteger uploadImgCount;
    NSMutableArray *thumbPath;
    NSMutableArray *imgPath;
    NSInteger allImgCount;
    NSArray *_imgArr;
    
}
@end

@implementation UploadDataToServer

-(id)init
{
    self = [super init];
    if(self)
    {
        thumbPath = [NSMutableArray array];
        imgPath = [NSMutableArray array];
        uploadImgCount = 0;
    }
    return self;

}

#pragma mark - upload img



-(void)uploadImg:(NSArray *)ImgArr
{
    if(ImgArr == nil || ImgArr.count == 0 )
        return;
    
    allImgCount = ImgArr.count;
    _imgArr = ImgArr;
    [self requestToServer];
}

-(void)requestToServer
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"uploadImgBackCall:"];
    [dataprovider UploadImgWithImgdata:_imgArr[uploadImgCount]];
}

-(void)uploadImgBackCall:(id)dict
{
    DLog(@"%@",dict);
    @try {
        if([dict[@"code"] integerValue] == 200)
        {
            [thumbPath addObject:dict[@"data"][@"SmallImagePath"]];
            [imgPath addObject:dict[@"data"][@"BigImagePath"]];
            uploadImgCount ++;
            if([self.delegate respondsToSelector:@selector(uploadImgsOneFinishDelegate:andImgIndex:)])
            {
                [self.delegate uploadImgsOneFinishDelegate:dict andImgIndex:(uploadImgCount+1)];
            }
            
            if(uploadImgCount >= allImgCount)
            {
                [SVProgressHUD dismiss];
                if([self.delegate respondsToSelector:@selector(uploadImgsAllFinishDelegate:andThumbPath:)])
                {
                    [self.delegate uploadImgsAllFinishDelegate:imgPath andThumbPath:thumbPath];
                }
            }
            else
            {
                [self requestToServer];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [Toolkit alertView:self andTitle:@"提示" andMsg:dict[@"data"] andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

}

@end
