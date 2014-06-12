//
//  JDHXLMainViewController.h
//  HXL
//
//  Created by Roc on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDHXLParentViewController.h"
#import "DCArrayMapping.h"
#import "JDHotelModel.h"
#import "JDHXLModel.h"

@interface JDMainViewController : JDHXLParentViewController
{
    UIScrollView *centerScrollView;
    UIView *addrAndTelView;
    UIView *bottomView;
}

@property (nonatomic, strong) NSMutableArray *centerImageViews;
@property (nonatomic, strong) JDHotelModel *hotelModel;

@end
