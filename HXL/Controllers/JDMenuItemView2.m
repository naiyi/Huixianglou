//
//  JDMenuItemView.m
//  HXL
//
//  Created by 刘斌 on 14-6-17.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//
#define PADDING 3
#import "JDMenuItemView2.h"

@implementation JDMenuItemView2{
    UILabel *nameLabel;
    UILabel *priceLable;
    UILabel *weightLable;
    UIView *count_view;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        _dish_img = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 10.0f, 60, 60)];
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
        
        float x2 =_dish_img.frame.size.width+_dish_img.frame.origin.x+PADDING;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, 12, 160, 20)];
        nameLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        nameLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:nameLabel];
        
        float y2 = 40;
        
        priceLable = [[UILabel alloc] initWithFrame:CGRectMake(x2, y2, 70, 25)];
        priceLable.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
        priceLable.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:priceLable];
        
        weightLable = [[UILabel alloc] initWithFrame:CGRectMake(priceLable.frame.size.width+priceLable.frame.origin.x+PADDING, y2+PADDING, 40, 20)];
        weightLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:weightLable];

        UIImageView *devider = [[UIImageView alloc] initWithFrame:CGRectMake(0, _dish_img.frame.size.height+_dish_img.frame.origin.y+9, self.contentView.frame.size.width, 1)];
        devider.image = [UIImage imageNamed:@"menu_devider"];
        [self.contentView addSubview:devider];
    }
    return self;
}

- (void)setModel:(JDDishModel *)dish{
    self.dishModel = dish;
    if (dish.price_type==1) {//按重量计价
        [_countLabel setTitle:[NSString stringWithFormat:@"%ig",dish.checked_weight] forState:UIControlStateNormal];
    } else {
        [_countLabel setTitle:[NSString stringWithFormat:@"%i",dish.count] forState:UIControlStateNormal];
    }
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
    if (dish.price_type==2) {
        nameLabel.text = [NSString stringWithFormat:@"%@(%@)",dish.name,[[dish.price_list objectAtIndex:dish.checked_fenliang] objectForKey:@"name"]];
    } else {
        nameLabel.text = dish.name;
    }
    
    priceLable.text = [NSString stringWithFormat:@"￥%i*%i",dish.price_show,dish.count];
    weightLable.text = [NSString stringWithFormat:@"/%ig",dish.checked_weight];
    
}
@end
