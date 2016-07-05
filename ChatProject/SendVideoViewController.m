//
//  UploadVideoViewController.m
//  KongFuCenter
//
//  Created by 于金祥 on 15/12/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import "SendVideoViewController.h"
#import "SCRecorder.h"
#import "DataProvider.h"

@interface SendVideoViewController ()
{
    //Preview
    SCPlayer *_player;
    
    UITextView * txt_title;
    UITextView * txt_Content;
    
    NSString * channelID;
    
    NSUserDefaults *userDefault;
}

@end

@implementation SendVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addLeftButton:@"left"];
    channelID=@"";
    _lblTitle.text=@"视频信息";
    [self addRightbuttontitle:@"保存"];
    self.view.backgroundColor = BACKGROUND_COLOR;
    userDefault = [NSUserDefaults standardUserDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SelectChannelCallBack:) name:@"select_channel_finish" object:nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:) ];
    [self.view addGestureRecognizer:tapGesture];
    
    
    
    [self InitAllView];
}

-(void)InitAllView
{
    // 创建视频播放器
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = CGRectMake(10, 74, SCREEN_WIDTH - 20, SCREEN_HEIGHT * 0.3);
    [self.view addSubview:playerView];
    _player.loopEnabled = YES;
    [_player setItemByUrl:_VideoFilePath];
    [_player play];
    
    txt_Content=[[UITextView alloc] initWithFrame:CGRectMake(10,playerView.frame.size.height+playerView.frame.origin.y+10 , SCREEN_WIDTH-20, SCREEN_HEIGHT-playerView.frame.size.height-playerView.frame.origin.y-20)];
    
    txt_Content.backgroundColor = navi_bar_bg_color;
    txt_Content.textColor = [UIColor whiteColor];
    
    [self.view addSubview:txt_Content];
    
    
    
}

-(void)tapViewAction:(id)sender
{
    NSLog(@"tap view---");
    
    [self.view endEditing:YES];
    
    //    if(_keyShow == true)
    //    {
    //        _keyShow = false;
    //        [_textView resignFirstResponder];//关闭textview的键盘
    //        [_titleField resignFirstResponder];//关闭titleField的键盘
    //
    //    }
}

-(void)clickRightButton:(UIButton *)sender
{
    if (txt_Content.text.length==0) {
        [Toolkit alertView:self andTitle:@"提示" andMsg:@"请填写内容信息" andCancelButtonTitle:@"确定" andOtherButtonTitle:nil handler:nil];
        return;
    }
    
    [Toolkit showWithStatus:@"正在上传视频..."];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoCallBack:"];
    [dataprovider upLoadVideo:_VideoFilePath];
}

-(void)sendVideoCallBack:(id)dict
{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    [Toolkit showWithStatus:@"正在保存视频信息..."];
    
    //    code = 200;
    //    date =     {
    //        ImageName = "UpLoad\\Image\\83e46012-91f3-4a31-a27b-fdb658601adf.JPG";
    //        VideoDuration = "00:00:08";
    //        VideoName = "UpLoad\\Video\\279b6db9-455e-4feb-9e03-1e5fa15a9879.mov";
    //    };
    
    if ([dict[@"code"] intValue]==200) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"sendVideoInfoCallBack:"];
        [dataprovider SaveDongtai:[Toolkit getStringValueByKey:@"Id"] andContent:txt_Content.text andPathlist:@"" andVideoImage:dict[@"data"][@"ImageName"] andVideopath:dict[@"data"][@"VideoName"] andVideoDuration:dict[@"data"][@"VideoDuration"] andSmallImage:@""];
        
        //[dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:txt_Content.text andpathlist:dict[@"data"][@"ImageName"] andvideopath:dict[@"data"][@"VideoName"] andvideoDuration:dict[@"data"][@"VideoDuration"]];
        //[dataprovider SaveDongtai:[userDefault valueForKey:@"id"] andcontent:txt_Content.text andpathlist:@"" andvideoImage:dict[@"data"][@"ImageName"] andvideopath:dict[@"data"][@"VideoName"] andvideoDuration:dict[@"data"][@"VideoDuration"]];
        
        
//        NSMutableDictionary * prm=[[NSMutableDictionary alloc] init];
//        
//        [prm setObject:@"0" forKey:@"id"];
//        
//        [prm setObject:dict[@"data"][@"ImageName"] forKey:@"ImagePath"];
//        
//        [prm setObject:txt_Content.text forKey:@"Content"];
//        
//        [prm setObject:txt_title.text forKey:@"Title"];
//        
//        [prm setObject:dict[@"data"][@"VideoName"] forKey:@"VideoPath"];
//        
//        [prm setObject:@"TRUE" forKey:@"IsOriginal"];
//        
//        [prm setObject:@"TRUE" forKey:@"IsFree"];
//        
//        [prm setObject:channelID forKey:@"CategoryId"];
//        
//        [prm setObject:[Toolkit getUserID] forKey:@"UserId"];
//        
//        [prm setObject:dict[@"data"][@"VideoDuration"] forKey:@"VideoDuration"];
        
        //[dataprovider SendVideoInfo:prm];
        
        
    }
}


-(void)sendVideoInfoCallBack:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"code"] intValue]==200) {
        
        if ([self.delegate respondsToSelector:@selector(sendVideo)]) {
            [self.delegate sendVideo];
        }
        
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)JumpToChannelVC
{
//    ChannelViewController *channelViewCtl = [[ChannelViewController alloc] init];
//    
//    channelViewCtl.navtitle = @"请选择分类";
//    
//    channelViewCtl.isVideoSelectCadagray=YES;
//    
//    [self.navigationController pushViewController:channelViewCtl animated:YES];
}
-(void)SelectChannelCallBack:(NSNotification *)notice
{
    NSLog(@"%@",[notice object]);
    
    channelID=[notice object];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
