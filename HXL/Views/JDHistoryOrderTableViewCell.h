//
//  JDCurrentOrderTableViewCell.h
//  HXL
//
//  Created by Roc on 14-6-27.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDOrderModel.h"

@interface JDHistoryOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIImageView *orderImage;
@property (strong, nonatomic) UILabel *orderTitle;
@property (strong, nonatomic) UILabel *orderTime;
@property (strong, nonatomic) UILabel *orderName;
@property (strong, nonatomic) UILabel *orderDetail;
@property (strong, nonatomic) JDOrderModel *orderModel;
@property (nonatomic, strong) UILabel *orderState;

- (void)setModel:(JDOrderModel *)model andBG:(int)index;

@end
