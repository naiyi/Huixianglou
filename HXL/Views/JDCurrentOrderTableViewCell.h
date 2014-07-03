//
//  JDCurrentOrderTableViewCell.h
//  HXL
//
//  Created by Roc on 14-6-27.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDOrderModel.h"
#import "JDCurrentOrdersController.h"

@interface JDCurrentOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *centerView;
@property (strong, nonatomic) UIImageView *orderImage;
@property (strong, nonatomic) UILabel *orderTitle;
@property (strong, nonatomic) UILabel *orderTime;
@property (strong, nonatomic) UILabel *orderDetail;
@property (strong, nonatomic) UIImageView *orderDail;
@property (strong, nonatomic) UIImageView *orderState;
@property (strong, nonatomic) JDOrderModel *orderModel;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) JDCurrentOrdersController *controller;

- (void)setModel:(JDOrderModel *)model andTel:(NSString *)tel;

@end
