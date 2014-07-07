//
//  JDOrderViewController.m
//  HXL
//
//  Created by 刘斌 on 14-6-26.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDOrderViewController.h"
#import "JDDishModel.h"
#import "JDMenuItemView2.h"
#import "JDSubmitOrderController.h"
#import "JDUserViewController.h"
#import "JDGestureRecognizer.h"

@implementation JDOrderViewController{
    UITableView *scrollView;
    UILabel *totalLabel;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationTitle:@"您的订单"];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    [self setNetworkState:NETWORK_STATE_NORMAL];
}
- (void)setContentView{
    _bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    float scroll_height = _bg_view.frame.size.height-99;
    scrollView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _bg_view.frame.size.width, scroll_height)];
    scrollView.backgroundColor = [UIColor colorWithRed:1.0 green:250.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    scrollView.delegate = self;
    scrollView.dataSource = self;
    scrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
    scrollView.bounces = NO;
    [self.bg_view addSubview:scrollView];
    
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, scroll_height, self.contentView.frame.size.width, 50)];
    totalLabel.textColor = [UIColor redColor];
    totalLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"order_total_bg"]];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.font = [UIFont boldSystemFontOfSize:18];
    [self refreshPrice];
    [self.bg_view addSubview:totalLabel];
    
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"menu_submit_bg.png"]];
    UIView *submit_frame = [[UIView alloc] initWithFrame:CGRectMake(0, totalLabel.frame.origin.y+totalLabel.frame.size.height, self.contentView.frame.size.width, 49)];
    submit_frame.backgroundColor = bgColor;
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 94, 29)];
    [submit setTitle:@"确认菜单" forState:UIControlStateNormal];
    [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [submit setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_btn_bg_r"]]];
    [submit addTarget:self action:@selector(onSubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [submit_frame addSubview:submit];
    
    [self.bg_view addSubview:submit_frame];
    [self.contentView addSubview:_bg_view];
}
- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showToast:(NSString *)message
{
    iToast *toast = [iToast makeText:message];
    [toast setDuration:3000];
    [toast setGravity:iToastGravityBottom];
    [toast show];
}

- (void)onSubmitButtonClicked {
    if ((!self.orderedDishes)||(self.orderedDishes.count == 0)) {
        [self showToast:@"您还未点菜"];
        return;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_info"]) {
        JDSubmitOrderController *submitController = [[JDSubmitOrderController alloc] initWithNibName:nil bundle:nil];
        submitController.orderedDishes = self.orderedDishes;
        submitController.hotelModel = self.hotelModel;
        submitController.people = self.people;
        [self.navigationController pushViewController:submitController animated:YES];
    } else {
        JDUserViewController *userController = [[JDUserViewController alloc] initWithNibName:nil bundle:nil];
        userController.orderedDishes = self.orderedDishes;
        userController.hotelModel = self.hotelModel;
        [self.navigationController pushViewController:userController animated:YES];
    }
}

- (void) refreshPrice{
    int p = 0;
    for (int i=0; i<_orderedDishes.count; i++) {
        JDDishModel *dish = ((JDDishModel *)[_orderedDishes objectAtIndex:i]);
        p+=dish.price_show*dish.count;
    }
    totalLabel.text = [NSString stringWithFormat:@"共计%i个菜,￥%i",self.orderedDishes.count,p];
}

- (void)clickAdd:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[_orderedDishes objectAtIndex:indexPath.row];
    if (dish.price_type==1) {
        dish.checked_weight+=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_weight"] intValue];
        dish.price_show+=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_price"] intValue];
    } else {
        dish.count+=1;
    }
    [_orderedDishes setObject:dish atIndexedSubscript:indexPath.row];
    [scrollView reloadData];
    [self refreshPrice];
}

- (void)clickSub:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[_orderedDishes objectAtIndex:indexPath.row];
    if (dish.price_type==1) {
        if (dish.checked_weight<=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_weight"] intValue]) {
            [_orderedDishes removeObject:dish];
            [scrollView reloadData];
        } else {
            dish.checked_weight-=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_weight"] intValue];
            dish.price_show-=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_price"] intValue];
            [_orderedDishes setObject:dish atIndexedSubscript:indexPath.row];
            [scrollView reloadData];
        }
    } else {
        if (dish.count <= 1) {
            [_orderedDishes removeObject:dish];
            [scrollView reloadData];
        } else {
            dish.count-=1;
            [_orderedDishes setObject:dish atIndexedSubscript:indexPath.row];
            [scrollView reloadData];
        }
    }
    [self refreshPrice];
}


-(BOOL)automaticallyAdjustsScrollViewInsets{
    return false;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%i",_orderedDishes.count);
    return _orderedDishes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseId1 = @"Right";
    JDMenuItemView2 *cell1 = [tableView dequeueReusableCellWithIdentifier:reuseId1];
    if (cell1 == nil) {
        cell1 = [[JDMenuItemView2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId1];
    }
    JDDishModel *dish = [_orderedDishes objectAtIndex:indexPath.row];
    [cell1 setModel:dish];
    cell1.dish_img.userInteractionEnabled = YES;
    JDGestureRecognizer *tapGesture2 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdd:)];
    tapGesture2.obj = indexPath;
    [cell1.add_btn addGestureRecognizer:tapGesture2];
    JDGestureRecognizer *tapGesture3 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickSub:)];
    tapGesture3.obj = indexPath;
    [cell1.sub_btn addGestureRecognizer:tapGesture3];
    return cell1;
}
@end
