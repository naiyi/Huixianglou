//
//  JDDishTypeModel.m
//  HXL
//
//  Created by 刘斌 on 14-6-13.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDDishTypeModel.h"

@implementation JDDishTypeModel
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        self.id = [aDecoder decodeIntForKey:@"id"];
        self.number = [aDecoder decodeIntForKey:@"number"];
        self.type_name = [aDecoder decodeObjectForKey:@"type_name"];
        self.dish_list = [aDecoder decodeObjectForKey:@"dish_list"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.id forKey:@"id"];
    [aCoder encodeInt:self.number forKey:@"number"];
    [aCoder encodeObject:self.type_name forKey:@"type_name"];
    [aCoder encodeObject:self.dish_list forKey:@"dish_list"];
}
@end
