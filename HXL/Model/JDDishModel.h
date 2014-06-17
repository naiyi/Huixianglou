//
//  JDDishModel.h
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDDishModel : NSObject<NSCoding>
@property (nonatomic) int id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *img_small;
@property (nonatomic,strong) NSString *img_big;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *status_reason;
@property (nonatomic,strong) NSArray *taste;
@property (nonatomic) int price;
@property (nonatomic) int weight;
@property (nonatomic) int show;
@property (nonatomic) int count;
@property (nonatomic) int onep;//等于1时,表示每人一份
@property (nonatomic) int recommend;//是否推荐
@property (nonatomic) int zan;
@property (nonatomic) int order_number;//服务器点菜计数
@property (nonatomic) int price_type;//计价方式，0正常1按重量计价2按份量计价（大中小份）
@property (nonatomic) int sort;
@property (nonatomic) int checked_fenliang;
@property (nonatomic) int checked_weight;
@property (nonatomic) int price_show;
@property (nonatomic) bool ifOrdered;
@property (nonatomic,strong) NSArray *price_list;
@end
