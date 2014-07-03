//
//  JDCurrentOrdersController.h
//  HXL
//
//  Created by Roc on 14-6-24.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"

@interface JDCurrentOrdersController : JDHXLParentViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *orderDatas;
    UITableView *orderTableView;
}

@property (nonatomic, strong) JDHotelModel *hotelModel;

- (void)reloadData;

@end
