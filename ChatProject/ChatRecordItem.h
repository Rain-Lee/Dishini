//
//  ChatRecordItem.h
//  ChatProject
//
//  Created by Rain on 16/12/6.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRecordItem : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *portraitUri;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *sendTime;
@property (nonatomic, strong) NSString *messageId;

@end
