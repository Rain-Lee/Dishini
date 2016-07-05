//
//  SendVideoViewController.h
//  KongFuCenter
//
//  Created by Rain on 15/12/25.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "BaseNavigationController.h"

@protocol SendVideoDelegate <NSObject>

-(void)sendVideo;

@end

@interface SendVideoViewController : BaseNavigationController

@property (nonatomic,strong) NSURL * VideoFilePath;

@property (nonatomic, strong) id<SendVideoDelegate> delegate;

@end
