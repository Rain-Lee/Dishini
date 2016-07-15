//
//  MyHeaderView.m
//  UICollectionViewTest
//
//  Created by ibokan on 15/1/5.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyHeaderView.h"

@implementation MyHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // _groupNameTxt
        _groupNameTxt = [[UITextField alloc] init];
        _groupNameTxt.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _groupNameTxt.textAlignment = NSTextAlignmentCenter;
        _groupNameTxt.font = [UIFont systemFontOfSize:20];
        [self addSubview:_groupNameTxt];
    }
    return self;
}

@end
