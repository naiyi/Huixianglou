//
//  JDOrderViewController.h
//  HXL
//
//  Created by 刘斌 on 14-6-26.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDHXLParentViewController.h"

@interface JDOrderViewController : JDHXLParentViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *orderedDishes;//已经点过的菜集合
@property (nonatomic,strong) UIView *bg_view;
@property (nonatomic,strong) JDHotelModel *hotelModel;
@property (nonatomic) int people;

@end
