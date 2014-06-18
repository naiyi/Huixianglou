//
//  JDDishTypeView.h
//  HXL
//
//  Created by 刘斌 on 14-6-18.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDDishTypeModel.h"

@interface JDDishTypeView : UITableViewCell
@property (nonatomic, strong) JDDishTypeModel *model;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *count_bg;

@end
