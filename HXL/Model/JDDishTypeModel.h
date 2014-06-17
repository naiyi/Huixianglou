//
//  JDDishTypeModel.h
//  HXL
//
//  Created by 刘斌 on 14-6-13.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDDishTypeModel : NSObject<NSCoding>
@property (nonatomic) int id;
@property (nonatomic,strong) NSString *type_name;
@property (nonatomic) int number;
@property (nonatomic,strong) NSArray *dish_list;
@end
