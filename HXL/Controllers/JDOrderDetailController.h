//
//  JDOrderDetailController.h
//  HXL
//
//  Created by Roc on 14-7-3.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"

@interface JDOrderDetailController : JDHXLParentViewController
{
    NSArray *orderDetailDatas;
    UITableView *orderTableView;
}

@property (nonatomic, strong) NSString *order_id;

@end
