//
//  JDMenuItemView.h
//  HXL
//
//  Created by 刘斌 on 14-6-17.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDDishModel.h"

@interface JDMenuItemView : UITableViewCell
@property (nonatomic,strong) JDDishModel *dishModel;
@property (nonatomic,strong) UIImageView *dish_img;

- (void)setModel:(JDDishModel *)dishModel;
@end
