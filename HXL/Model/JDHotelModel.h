//
//  JDONewsModel.h
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-31.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDHotelModel : NSObject <NSCoding>
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *tel;
@property (nonatomic) int max;
@property (nonatomic,strong) NSArray *time;
@property (nonatomic,strong) NSArray *img;
@property (nonatomic) int lon;
@property (nonatomic) int lat;
@property (nonatomic,strong) NSString *about_us;
@property (nonatomic) int hotel_id;

@end
