//
//  JDMenuItemView.m
//  HXL
//
//  Created by 刘斌 on 14-6-17.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//
#define PADDING 3
#import "JDMenuItemView.h"

@implementation JDMenuItemView{
    UIImageView *tuijian;
    UILabel *nameLabel;
    UILabel *tasteLabel;
    UIImageView *taste_bg;
    UILabel *eat_countLable;
    UILabel *like_countLable;
    UILabel *priceLable;
    UILabel *weightLable;
    UILabel *min_weightLabel;
    UIView *count_view;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        float y0 = 5.0f;
        _dish_img = [[UIImageView alloc] initWithFrame:CGRectMake(165.0f, 10.0f, 60, 60)];
        [self.contentView addSubview:_dish_img];
        
        count_view = [[UIView alloc] initWithFrame:CGRectMake(165.0f, 5.0f, 50, 70)];
        count_view.hidden = true;
        _add_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _dish_img.frame.size.width, 25)];
        [_add_btn setBackgroundImage:[UIImage imageNamed:@"dish_add1"] forState:UIControlStateNormal];
        _countLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, _add_btn.frame.size.height, _dish_img.frame.size.width, 20)];
        [_countLabel setTitle:@"1" forState:UIControlStateNormal];
        _countLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_countLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_countLabel setBackgroundImage:[UIImage imageNamed:@"dish_edt_bg1"] forState:UIControlStateNormal];
        _sub_btn = [[UIButton alloc] initWithFrame:CGRectMake(0, _countLabel.frame.origin.y+_countLabel.frame.size.height, _dish_img.frame.size.width, 25)];
        [_sub_btn setBackgroundImage:[UIImage imageNamed:@"dish_sub1"] forState:UIControlStateNormal];
        [count_view addSubview:_add_btn];
        [count_view addSubview:_countLabel];
        [count_view addSubview:_sub_btn];
        [self.contentView addSubview:count_view];
        
        tuijian = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, y0, 12, 18)];
        tuijian.image = [UIImage imageNamed:@"dish_tuijian"];
        [self.contentView addSubview:tuijian];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(tuijian.frame.size.width+tuijian.frame.origin.x, y0, 90, tuijian.frame.size.height)];
        nameLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:nameLabel];
        tasteLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, y0, 40, tuijian.frame.size.height)];
        tasteLabel.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
        tasteLabel.textAlignment = UITextAlignmentCenter;
        tasteLabel.font = [UIFont systemFontOfSize:12];
        taste_bg = [[UIImageView alloc] initWithFrame:tasteLabel.frame];
        taste_bg.image = [UIImage imageNamed:@"dish_taste_bg"];
        [self.contentView addSubview:taste_bg];
        [self.contentView addSubview:tasteLabel];
        
        float y1 = y0+tuijian.frame.size.height+PADDING*2;
        UIImageView *eat_img = [[UIImageView alloc] initWithFrame:CGRectMake(PADDING, y1, 14, 14)];
        eat_img.image = [UIImage imageNamed:@"dish_eat"];
        [self.contentView addSubview:eat_img];
        eat_countLable = [[UILabel alloc] initWithFrame:CGRectMake(eat_img.frame.origin.x+eat_img.frame.size.width+PADDING, y1, 58, eat_img.frame.size.height)];
        eat_countLable.font = [UIFont systemFontOfSize:12];
        eat_countLable.textColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
        [self.contentView addSubview:eat_countLable];
        UIImageView *like_img = [[UIImageView alloc] initWithFrame:CGRectMake(eat_countLable.frame.origin.x+eat_countLable.frame.size.width+PADDING, y1, 14, 14)];
        like_img.image = [UIImage imageNamed:@"dish_like"];
        [self.contentView addSubview:like_img];
        like_countLable = [[UILabel alloc] initWithFrame:CGRectMake(like_img.frame.origin.x+like_img.frame.size.width+PADDING, y1, 58, like_img.frame.size.height)];
        like_countLable.textColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
        like_countLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:like_countLable];
        
        float y2 = y1+eat_img.frame.size.height+PADDING*2;
        priceLable = [[UILabel alloc] initWithFrame:CGRectMake(PADDING, y2, 50, 25)];
        priceLable.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
        priceLable.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:priceLable];
        
        weightLable = [[UILabel alloc] initWithFrame:CGRectMake(priceLable.frame.size.width+priceLable.frame.origin.x, y2+PADDING, 40, 20)];
        weightLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:weightLable];
        
        min_weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLable.frame.origin.x+weightLable.frame.size.width, y2+PADDING, 60, 20)];
        min_weightLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:min_weightLabel];
    }
    return self;
}

- (void)setModel:(JDDishModel *)dish{
    self.dishModel = dish;
    if (dish.ifOrdered) {
        self.contentView.backgroundColor = [UIColor colorWithRed:1.0f green:250.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        _dish_img.hidden = true;
        count_view.hidden = false;
        if (dish.price_type==1) {//按重量计价
            [_countLabel setTitle:[NSString stringWithFormat:@"%ig",dish.checked_weight] forState:UIControlStateNormal];
        } else {
            [_countLabel setTitle:[NSString stringWithFormat:@"%i",dish.count] forState:UIControlStateNormal];
        }
        
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        _dish_img.hidden = false;
        count_view.hidden = true;
        __block UIImageView *blockImageView = self.imageView;
        [_dish_img setImageWithURL:[NSURL URLWithString:dish.img_small] placeholderImage:nil noImage:false options:SDWebImageOption success:^(UIImage *image, BOOL cached) {
            if(!cached){    // 非缓存加载时使用渐变动画
                CATransition *transition = [CATransition animation];
                transition.duration = 0.3;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                [blockImageView.layer addAnimation:transition forKey:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    if (dish.recommend==1) {
        tuijian.hidden = false;
        [nameLabel setFrame:CGRectMake(tuijian.frame.size.width+PADDING, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
        [tasteLabel setFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, tasteLabel.frame.origin.y, 40, tuijian.frame.size.height)];
        [taste_bg setFrame:tasteLabel.frame];
    } else {
        tuijian.hidden = true;
        [nameLabel setFrame:CGRectMake(PADDING, nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
        [tasteLabel setFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width, tasteLabel.frame.origin.y, 40, tuijian.frame.size.height)];
        [taste_bg setFrame:tasteLabel.frame];
    }
    if ([dish.status isEqualToString:@"正常"]) {
        nameLabel.text = dish.name;
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 90, nameLabel.frame.size.height);
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
    } else {
        nameLabel.text = [dish.name stringByAppendingString:@"(售罄)"];
        nameLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, 140, nameLabel.frame.size.height);
        tasteLabel.hidden = true;
        taste_bg.hidden = true;
    }
    
    
    eat_countLable.text = [NSString stringWithFormat:@"%i人点过",dish.order_number];
    like_countLable.text = [NSString stringWithFormat:@"%i人喜欢",dish.zan];
    priceLable.text = [NSString stringWithFormat:@"￥%i",dish.price_show];
    weightLable.text = [NSString stringWithFormat:@"/%ig",dish.checked_weight];
    if(dish.price_type == 1){
        int min = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_weight"] intValue];
        min_weightLabel.text = [NSString stringWithFormat:@"%ig起订",min];
        min_weightLabel.hidden = false;
    } else {
        min_weightLabel.hidden = true;
    }
}
@end
