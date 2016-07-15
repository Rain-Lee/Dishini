//
//  MyFooterView.m
//  UICollectionViewTest
//
//  Created by ibokan on 15/1/5.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MyFooterView.h"

@implementation MyFooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _quitBtn = [[UIButton alloc]init];
        _quitBtn.frame = CGRectMake(15, 15, self.frame.size.width - 30, self.frame.size.height);
        _quitBtn.backgroundColor = [UIColor colorWithRed:0.94 green:0.00 blue:0.03 alpha:1.00];
        [_quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _quitBtn.layer.masksToBounds = true;
        _quitBtn.layer.cornerRadius = 6;
        [self addSubview:_quitBtn];
        
    }
    return self;
}

@end
