//
//  JDONewsModel.h
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-31.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDUserModel : NSObject <NSCoding>

@property (nonatomic) int currentOrderCount;
@property (nonatomic,strong) NSString *currentOrderDate;
@property (nonatomic,strong) NSString *currentOrderDetail;
@property (nonatomic,strong) NSString *currentOrderHotel;
@property (nonatomic,strong) NSString *currentOrderTime;
@property (nonatomic,strong) NSString *headPic;
@property (nonatomic) int historyOrderCount;
@property (nonatomic,strong) NSString *historyOrderDate;
@property (nonatomic,strong) NSString *historyOrderDetail;
@property (nonatomic,strong) NSString *historyOrderHotel;
@property (nonatomic,strong) NSString *historyOrderTime;
@property (nonatomic,strong) NSString *scoreDate1;
@property (nonatomic,strong) NSString *scoreDate2;
@property (nonatomic) int scoreNum1;
@property (nonatomic) int scoreNum2;
@property (nonatomic,strong) NSString *scoreTime1;
@property (nonatomic,strong) NSString *scoreTime2;
@property (nonatomic) int scoreTotal;

@end
