//
//  JDOrderDetailCell.h
//  HXL
//
//  Created by Roc on 14-7-7.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDOrderDetailModel.h"

@interface JDOrderDetailCell : UITableViewCell
{
    UIView *centerView;
    UILabel *titleLabel;
    UILabel *priceLabel;
    UILabel *countLabel;
    UIButton *goodButton;
    UIButton *badButton;
}

- (void)setModel:(JDOrderDetailModel *)model andOrderID:(NSString *)order_id andIndex:(int)index;

@property (nonatomic)BOOL needGoodBad;
@property (nonatomic, strong)JDOrderDetailModel *model;
@property (nonatomic, strong)NSString *order_id;

@end
