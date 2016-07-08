//
//  DFLikeCommentToolbar.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFLikeCommentToolbar.h"

@interface DFLikeCommentToolbar()

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *commentButton;


@end


@implementation DFLikeCommentToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
    }
    return self;
}

-(void) initView
{
    
    self.userInteractionEnabled = YES;
    
    UIImage *image = [UIImage imageNamed:@"AlbumOperateMoreViewBkg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    self.image = image;
    
    
    
    CGFloat x, y, width, height;
    
    x=0;
    y=0;
    width = self.frame.size.width/2;
    height = self.frame.size.height;
    
    NSString *isLike = [Toolkit getStringValueByKey:@"isLike"];
    NSLog(@"isLike ------------- %@",isLike);
    _likeButton = [self getButton:CGRectMake(x, y, width, height) title:[isLike isEqual:@"1"] ? @"取消赞" : @"赞" image:@"AlbumLike"];
    [_likeButton addTarget:self action:@selector(onLike:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    x = width;
    _commentButton = [self getButton:CGRectMake(x, y, width, height) title:@"评" image:@"AlbumComment"];
    [_commentButton addTarget:self action:@selector(onComment:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentButton];
    
    //分割线
    height = height -16;
    y = (self.frame.size.height - height)/2;
    width = 1;
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    divider.backgroundColor = [UIColor whiteColor];
    [self addSubview:divider];
    
}

-(UIButton *) getButton:(CGRect) frame title:(NSString *) title image:(NSString *) image
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    //btn.backgroundColor = [UIColor redColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}



-(void) onLike:(id) sender
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onLike:)]) {
        UIButton *btn = (UIButton *)sender;
        NSString *titleString = btn.titleLabel.text;
        NSLog(@"%@",titleString);
        [_delegate onLike:[titleString isEqual:@"赞"] ? false : true];
    }
    
}


-(void) onComment:(id) sender
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(onComment)]) {
        [_delegate onComment];
    }
}

-(void)updateClickZan{
    NSString *isLike = [Toolkit getStringValueByKey:@"isLike"];
    NSLog(@"isLike ------------- %@",isLike);
    [_likeButton setTitle:[isLike isEqual:@"1"] ? @"取消赞" : @"赞" forState:UIControlStateNormal];
}

@end
