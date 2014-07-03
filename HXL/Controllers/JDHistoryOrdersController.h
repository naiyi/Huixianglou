//
//  JDHistoryOrdersController.h
//  HXL
//
//  Created by Roc on 14-6-24.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"
#import "JDOrderModel.h"
#import "JDHXLArrayModel.h"

@interface JDHistoryOrdersController : JDHXLParentViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *orderDatas;
    UITableView *orderTableView;
}
@end
