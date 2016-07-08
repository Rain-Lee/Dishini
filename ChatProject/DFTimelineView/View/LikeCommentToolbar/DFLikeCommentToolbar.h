//
//  DFLikeCommentToolbar.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

@protocol DFLikeCommentToolbarDelegate <NSObject>

@required

-(void) onLike:(BOOL)isLike;
-(void) onComment;

@end

@interface DFLikeCommentToolbar : UIImageView


@property (nonatomic, weak) id<DFLikeCommentToolbarDelegate> delegate;

-(void)updateClickZan;


@end
