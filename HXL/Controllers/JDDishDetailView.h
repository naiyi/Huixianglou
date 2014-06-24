//
//  JDDishDetailView.h
//  HXL
//
//  Created by 刘斌 on 14-6-24.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDDishModel.h"

@interface JDDishDetailView : UIView
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *addBtn;
-(id)initWithFrame:(CGRect)frame andDish:(JDDishModel *)dish;
@end
