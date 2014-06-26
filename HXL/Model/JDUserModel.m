//
//  JDONewsModel.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-31.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDUserModel.h"
#import "JDOWebClient.h"

@implementation JDUserModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.currentOrderCount = [aDecoder decodeObjectForKey:@"currentOrderCount"];
        self.currentOrderDate = [aDecoder decodeObjectForKey:@"currentOrderDate"];
        self.currentOrderDetail = [aDecoder decodeObjectForKey:@"currentOrderDetail"];
        self.currentOrderHotel = [aDecoder decodeObjectForKey:@"currentOrderHotel"];
        self.currentOrderTime = [aDecoder decodeObjectForKey:@"currentOrderTime"];
        self.headPic = [aDecoder decodeObjectForKey:@"headPic"];
        self.historyOrderCount = [aDecoder decodeObjectForKey:@"historyOrderCount"];
        self.historyOrderDate = [aDecoder decodeObjectForKey:@"historyOrderDate"];
        self.historyOrderDetail = [aDecoder decodeObjectForKey:@"historyOrderDetail"];
        self.historyOrderHotel = [aDecoder decodeObjectForKey:@"historyOrderHotel"];
        self.historyOrderTime = [aDecoder decodeObjectForKey:@"historyOrderTime"];
        self.scoreDate1 = [aDecoder decodeObjectForKey:@"scoreDate1"];
        self.scoreDate2 = [aDecoder decodeObjectForKey:@"scoreDate2"];
        self.scoreNum1 = [aDecoder decodeObjectForKey:@"scoreNum1"];
        self.scoreNum2 = [aDecoder decodeObjectForKey:@"scoreNum2"];
        self.scoreTime1 = [aDecoder decodeObjectForKey:@"scoreTime1"];
        self.scoreTime2 = [aDecoder decodeObjectForKey:@"scoreTime2"];
        self.scoreTotal = [aDecoder decodeObjectForKey:@"scoreTotal"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.currentOrderCount forKey:@"currentOrderCount"];
    [aCoder encodeObject:self.currentOrderDate forKey:@"currentOrderDate"];
    [aCoder encodeObject:self.currentOrderDetail forKey:@"currentOrderDetail"];
    [aCoder encodeObject:self.currentOrderHotel forKey:@"currentOrderHotel"];
    [aCoder encodeObject:self.currentOrderTime forKey:@"currentOrderTime"];
    [aCoder encodeObject:self.headPic forKey:@"headPic"];
    [aCoder encodeObject:self.historyOrderCount forKey:@"historyOrderCount"];
    [aCoder encodeObject:self.historyOrderDate forKey:@"historyOrderDate"];
    [aCoder encodeObject:self.historyOrderDetail forKey:@"historyOrderDetail"];
    [aCoder encodeObject:self.historyOrderHotel forKey:@"historyOrderHotel"];
    [aCoder encodeObject:self.historyOrderTime forKey:@"historyOrderTime"];
    [aCoder encodeObject:self.scoreDate1 forKey:@"scoreDate1"];
    [aCoder encodeObject:self.scoreDate2 forKey:@"scoreDate2"];
    [aCoder encodeObject:self.scoreNum1 forKey:@"scoreNum1"];
    [aCoder encodeObject:self.scoreNum2 forKey:@"scoreNum2"];
    [aCoder encodeObject:self.scoreTime1 forKey:@"scoreTime1"];
    [aCoder encodeObject:self.scoreTime2 forKey:@"scoreTime2"];
    [aCoder encodeObject:self.scoreTotal forKey:@"scoreTotal"];
}

@end
