//
//  JDDishDetailView.m
//  HXL
//
//  Created by 刘斌 on 14-6-24.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//
#define PADDING 3
#import "JDDishDetailView.h"
#import "JDDishModel.h"

@implementation JDDishDetailView{
    UIImageView *tuijian;
    UILabel *nameLabel;
    UILabel *tasteLabel;
    UIImageView *taste_bg;
    UILabel *eat_countLable;
    UILabel *like_countLable;
    UILabel *priceLable;
    UILabel *weightLable;
    UILabel *min_weightLabel;
}
-(id)initWithFrame:(CGRect)frame andDish:(JDDishModel *)dish{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIColor *textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        UILabel *topNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 35)];
        topNameLabel.text = dish.name;
        topNameLabel.textColor = textColor;
        topNameLabel.textAlignment = UITextAlignmentCenter;
        topNameLabel.font = [UIFont boldSystemFontOfSize:22];
        
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30, 7, 20, 20)];
        [_closeBtn setImage:[UIImage imageNamed:@"dish_detail_close_btn"] forState:UIControlStateNormal];
        [self addSubview:topNameLabel];
        [self addSubview:_closeBtn];
        
        UIImageView *dish_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, topNameLabel.frame.size.height, frame.size.width, frame.size.width)];
        [self addSubview:dish_img];
        __block UIImageView *blockImageView = dish_img;
        [dish_img setImageWithURL:[NSURL URLWithString:dish.img_big] placeholderImage:nil noImage:false options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [blockImageView.layer addAnimation:transition forKey:nil];
            }
        } failure:^(NSError *error) {
            
        }];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, dish_img.frame.origin.y+dish_img.frame.size.height, frame.size.width, 200)];
        [self addSubview:contentView];
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 10, 80, 30)];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"dishtype_item_bg"] forState:UIControlStateNormal];
        [_addBtn setTitle:@"加入菜单" forState:UIControlStateNormal];
        [contentView addSubview:_addBtn];
        float y0 = 5.0f;
        tuijian = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, y0, 12, 18)];
        tuijian.image = [UIImage imageNamed:@"dish_tuijian"];
        [contentView addSubview:tuijian];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(tuijian.frame.size.width+tuijian.frame.origin.x, y0, 90, tuijian.frame.size.height)];
        nameLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.text = dish.name;
        [contentView addSubview:nameLabel];
        tasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, y0, 40, tuijian.frame.size.height)];
        tasteLabel.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
        tasteLabel.textAlignment = UITextAlignmentCenter;
        tasteLabel.font = [UIFont systemFontOfSize:12];
        taste_bg = [[UIImageView alloc] initWithFrame:tasteLabel.frame];
        taste_bg.image = [UIImage imageNamed:@"dish_taste_bg"];
        [contentView addSubview:taste_bg];
        [contentView addSubview:tasteLabel];
        
        float y1 = y0+tuijian.frame.size.height+PADDING*2;
        UIImageView *eat_img = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, y1, 14, 14)];
        eat_img.image = [UIImage imageNamed:@"dish_eat"];
        [contentView addSubview:eat_img];
        eat_countLable = [[UILabel alloc] initWithFrame:CGRectMake(eat_img.frame.origin.x+eat_img.frame.size.width+PADDING, y1, 58, eat_img.frame.size.height)];
        eat_countLable.font = [UIFont systemFontOfSize:12];
        eat_countLable.textColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
        [contentView addSubview:eat_countLable];
        UIImageView *like_img = [[UIImageView alloc] initWithFrame:CGRectMake(eat_countLable.frame.origin.x+eat_countLable.frame.size.width+PADDING, y1, 14, 14)];
        like_img.image = [UIImage imageNamed:@"dish_like"];
        [contentView addSubview:like_img];
        like_countLable = [[UILabel alloc] initWithFrame:CGRectMake(like_img.frame.origin.x+like_img.frame.size.width+PADDING, y1, 58, like_img.frame.size.height)];
        like_countLable.textColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
        like_countLable.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:like_countLable];
        
        float y2 = y1+eat_img.frame.size.height+PADDING*2;
        priceLable = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y2, 50, 25)];
        priceLable.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
        priceLable.font = [UIFont boldSystemFontOfSize:16];
        [contentView addSubview:priceLable];
        
        weightLable = [[UILabel alloc] initWithFrame:CGRectMake(priceLable.frame.size.width+priceLable.frame.origin.x, y2+PADDING, 40, 20)];
        weightLable.font = [UIFont systemFontOfSize:13];
        [contentView addSubview:weightLable];
        
        min_weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLable.frame.origin.x+weightLable.frame.size.width, y2+PADDING, 200, 20)];
        min_weightLabel.font = [UIFont systemFontOfSize:13];
        [contentView addSubview:min_weightLabel];
        
        float y3 = y2+priceLable.frame.size.height;
        UIImageView *devider = [[UIImageView alloc] initWithFrame:CGRectMake(0, y3, frame.size.width, 1)];
        devider.image = [UIImage imageNamed:@"dish_detail_devider"];
        [contentView addSubview:devider];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y3+PADDING, frame.size.width, 50)];
        contentLabel.textColor = textColor;
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        [contentView addSubview:contentLabel];
        
        tuijian.hidden = dish.recommend==1?false:true;
        if ([dish.status isEqualToString:@"正常"]) {
            _addBtn.hidden = false;
        } else {
            _addBtn.hidden = true;
        }
        if (dish.taste.count == 0) {
            tasteLabel.hidden = true;
            taste_bg.hidden = true;
        } else {
            taste_bg.hidden = false;
            tasteLabel.hidden = false;
            NSMutableString *tastestr = [[NSMutableString alloc] init];
            for (int i = 0; i<dish.taste.count; i++) {
                [tastestr appendString:[dish.taste objectAtIndex:i]];
            }
            tasteLabel.text = tastestr;
        }
        eat_countLable.text = [NSString stringWithFormat:@"%i人点过",dish.order_number];
        like_countLable.text = [NSString stringWithFormat:@"%i人喜欢",dish.zan];
        priceLable.text = [NSString stringWithFormat:@"￥%i",dish.price_show];
        if (dish.checked_weight != 0) {
            weightLable.hidden = false;
            weightLable.text = [NSString stringWithFormat:@"/%ig",dish.checked_weight];
        } else {
            weightLable.hidden = true;
        }
        
        if(dish.price_type == 1){
            int min = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_weight"] intValue];
            int addp = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_price"] intValue];
            int addw = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_weight"] intValue];
            min_weightLabel.text = [NSString stringWithFormat:@"%ig起订 %i元/%ig续订",min,addp,addw];
            min_weightLabel.hidden = false;
        } else {
            min_weightLabel.hidden = true;
        }
        contentLabel.text = [NSString stringWithFormat:@"食材：%@",dish.content];
    }
    return self;
}
@end
