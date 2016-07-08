//
//  UserMomentsViewController.m
//  ChatProject
//
//  Created by Rain on 16/6/22.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import "UserMomentsViewController.h"
#import "MomentsItemViewController.h"

@interface UserMomentsViewController (){
    int index;
}

@end

@implementation UserMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTopView:2 andTitle:_nickName];
    
    [self initData];
    
    [self setHeader];
}

-(void) setHeader
{
    NSString *coverUrl = [Toolkit getUserDefaultValue:@"SpaceImagePath"];
    [self setCover:coverUrl];
    
    NSString *avatarUrl = [Toolkit getStringValueByKey:@"PhotoPath"];
    [self setUserAvatar:avatarUrl];
    
    [self setUserNick:[Toolkit getStringValueByKey:@"NickName"]];
    
    //[self setUserSign:@"梦想还是要有的 万一实现了呢"];
    
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
    
}

@end
