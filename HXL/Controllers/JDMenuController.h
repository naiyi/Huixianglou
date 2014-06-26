//
//  JDMenuController.h
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDHXLParentViewController.h"
#import "JDDishDetailView.h"

@interface JDMenuController : JDHXLParentViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIView *bg_view;
@property (nonatomic,strong) UIView *detail_bg;
@property (nonatomic,strong) JDDishDetailView *detailView;

@property (nonatomic,strong) UILabel *total;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UILabel *price_avg;
@property (nonatomic,strong) UIButton *sort;
@property (nonatomic,strong) UIButton *sort_bysale;
@property (nonatomic,strong) UIButton *sort_bycomment;
@property (nonatomic,strong) UITableView *left;
@property (nonatomic,strong) UITableView *right;
@property (nonatomic,strong) UIButton *submit;
@property (nonatomic) int people;
@end
