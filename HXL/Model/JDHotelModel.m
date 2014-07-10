//
//  JDONewsModel.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-5-31.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDHotelModel.h"
#import "JDOWebClient.h"

@implementation JDHotelModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.max = [aDecoder decodeIntForKey:@"max"];
        self.lon = [aDecoder decodeObjectForKey:@"lon"];
        self.lat = [aDecoder decodeObjectForKey:@"lat"];
        self.about_us = [aDecoder decodeObjectForKey:@"about_us"];
        self.time = [aDecoder decodeObjectForKey:@"times"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeInt:self.max forKey:@"max"];
    [aCoder encodeObject:self.lon forKey:@"lon"];
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.about_us forKey:@"about_us"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.img forKey:@"img"];
}

@end
