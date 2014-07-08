//
//  JDOrderDetailBottomCell.h
//  HXL
//
//  Created by Roc on 14-7-8.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDOrderDetailBottomCell : UITableViewCell
{
    UIView *centerView;
    UILabel *totalLabel;
    UILabel *detailLabel;
}

- (void)setModel:(NSString *)price andCount:(NSString *)count;

@end
