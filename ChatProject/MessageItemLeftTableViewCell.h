//
//  MessageItemLeftTableViewCell.h
//  ChatProject
//
//  Created by Rain on 16/12/9.
//  Copyright © 2016年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageItemLeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;

@end
