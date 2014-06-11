//
//  JDMenuController.h
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDHXLParentViewController.h"

@interface JDMenuController : JDHXLParentViewController
@property (nonatomic,strong) UILabel *total;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIScrollView *left;
@property (nonatomic,strong) UIScrollView *right;
@property (nonatomic,strong) UIButton *submit;
@end
