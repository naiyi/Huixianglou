//
//  JDMenuController.m
//  HXL
//
//  Created by 刘斌 on 14-6-10.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDMenuController.h"
#import "JDOHttpClient.h"
#import "JDOArrayModel.h"
#import "JDDishModel.h"
#import "JDDishTypeModel.h"
#import "JDMenuItemView.h"
#import "JDDishDetailView.h"
#import "JDDishTypeView.h"
#import "DCKeyValueObjectMapping.h"
#import "JDHXLUtil.h"
#import "JDOrderViewController.h"
#import "JDGestureRecognizer.h"

@implementation JDMenuController
{
    NSMutableArray *dish_types;
    NSMutableArray *allDishes;//所有菜的集合
    NSMutableArray *dishes;//所有菜的分类集合
    NSMutableArray *orderedDishes;//已经点过的菜集合
    int selectPos;//左侧listview的选中位置
}
int orderedDishesCount[5] = {0,0,0,0,0};//已经点过的菜计数，显示在左侧菜系表中
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
    dish_types = [[NSMutableArray alloc] init];
    dishes = [[NSMutableArray alloc] init];
    allDishes = [[NSMutableArray alloc] init];
    orderedDishes = [[NSMutableArray alloc] init];
    
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    //[self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    _total = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 20)];
    _total.text = @"已点0个菜";
    _total.textColor = [UIColor blackColor];
    _total.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [titleView addSubview:_total];
    _price = [[UILabel alloc] initWithFrame:CGRectMake(0, _total.frame.size.height, 50, 20)];
    _price.text = @"￥0";
    _price.textColor = [UIColor redColor];
    [titleView addSubview:_price];
    _price_avg = [[UILabel alloc] initWithFrame:CGRectMake(_price.frame.size.width, _total.frame.size.height, 150, 20)];
    _price_avg.text = [NSString stringWithFormat:@"，%i人，人均￥0",_people];
    _price_avg.textColor = [UIColor grayColor];
    [titleView addSubview:_price_avg];
    [self setNavigationTitleView:titleView];
    [self setNetworkState:NETWORK_STATE_LOADING];
    NSDictionary *params = @{@"id": @"1"};
    [[JDOHttpClient sharedClient] getJSONByServiceName:GET_DISH_TYPE_AND_LIST modelClass:@"JDOArrayModel" params:params success:^(JDOArrayModel *dataModel) {
        NSArray *dataList = (NSArray *)dataModel.data;
        if(dataList == nil || dataList.count==0){
            [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
        } else {
            for (int i = 0; i < dataList.count; i++) {
                DCKeyValueObjectMapping *mapper = [DCKeyValueObjectMapping mapperForClass:[JDDishTypeModel class]];
                DCKeyValueObjectMapping *mapper1 = [DCKeyValueObjectMapping mapperForClass:[JDDishModel class]];
                JDDishTypeModel *dishType = [mapper parseDictionary:[dataList objectAtIndex:i]];
                [dish_types addObject:dishType];
                NSArray *innerDishes = [mapper1 parseArray:dishType.dish_list];
                NSMutableArray *innerDishes1 = [[NSMutableArray alloc] init];
                for (int k=0; k<innerDishes.count; k++) {
                    JDDishModel *dish = [innerDishes objectAtIndex:k];
                    if (dish.price_type == 1) {//按重量计价
                        dish.price_show = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_price"] intValue];
                        dish.checked_weight = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_weight"] intValue];
                    } else if(dish.price_type == 2){//按份数计价
                        dish.price_show = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"price"] intValue];
                        dish.checked_weight = [(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"weight"] intValue];
                    } else {
                        dish.price_show = dish.price;
                        dish.checked_weight = dish.weight;
                    }
                    dish.sort = (i+1)*(k+1);
                    dish.count = 1;
                    [innerDishes1 addObject:dish];
                }
                [dishes addObject:innerDishes1];
                [allDishes addObjectsFromArray:innerDishes1];
            }
            [self setNetworkState:NETWORK_STATE_NORMAL];
        }
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
    
}

- (void)setContentView
{
    _bg_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    UIView *sortView =[[UIView alloc] initWithFrame:CGRectMake(0, 0.0, self.contentView.frame.size.width, 40)];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"menu_submit_bg.png"]];
    [sortView setBackgroundColor:bgColor];
    float sort_width = sortView.frame.size.width/3;
    float sort_height = sortView.frame.size.height;
    UIColor *color_normal = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
    UIColor *color_selected = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
    _sort = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sort_width, sort_height)];
    _sort.selected = true;
    [_sort setTitle:@"综合" forState:UIControlStateNormal];
    [_sort setTitleColor:color_selected forState:UIControlStateHighlighted];
    [_sort setTitleColor:color_normal forState:UIControlStateNormal];
    [_sort setTitleColor:color_selected forState:UIControlStateSelected];
    [_sort addTarget:self action:@selector(onSortByButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [sortView addSubview:_sort];
    
    _sort_bysale = [[UIButton alloc] initWithFrame:CGRectMake(sort_width, 0, sort_width, sort_height)];
    [_sort_bysale setTitle:@"销量" forState:UIControlStateNormal];
    [_sort_bysale setTitleColor:color_selected forState:UIControlStateHighlighted];
    [_sort_bysale setTitleColor:color_selected forState:UIControlStateSelected];
    [_sort_bysale setTitleColor:color_normal forState:UIControlStateNormal];
    _sort_bysale.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_sort_bysale addTarget:self action:@selector(onSortBySaleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *devider1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_orderby_devider"]];
    devider1.frame = CGRectMake(0, 6, 1, 30);
    UIImageView *devider2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_orderby"]];
    devider2.frame = CGRectMake(72, 13, 20, 14);
    [_sort_bysale addSubview:devider1];
    [_sort_bysale addSubview:devider2];
    [sortView addSubview:_sort_bysale];
    
    _sort_bycomment = [[UIButton alloc] initWithFrame:CGRectMake(sort_width*2,0,  sort_width, sort_height)];
    [_sort_bycomment setTitle:@"好评" forState:UIControlStateNormal];
    [_sort_bycomment setTitleColor:color_selected forState:UIControlStateHighlighted];
    [_sort_bycomment setTitleColor:color_selected forState:UIControlStateSelected];
    [_sort_bycomment setTitleColor:color_normal forState:UIControlStateNormal];
    _sort_bycomment.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_sort_bycomment addTarget:self action:@selector(onSortByCommentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *devider3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_orderby_devider"]];
    devider3.frame = CGRectMake(0, 6, 1, 30);
    UIImageView *devider4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_orderby"]];
    devider4.frame = CGRectMake(72, 13, 20, 14);
    [_sort_bycomment addSubview:devider3];
    [_sort_bycomment addSubview:devider4];
    [sortView addSubview:_sort_bycomment];
    [self.bg_view addSubview:sortView];
    
    float scroll_height = self.contentView.frame.size.height-sortView.frame.size.height-sortView.frame.origin.y-60;
    float scroll_y = sortView.frame.origin.y+sortView.frame.size.height;
    _left = [[UITableView alloc] initWithFrame:CGRectMake(0, scroll_y, 90, scroll_height)];
    _left.delegate = self;
    _left.dataSource = self;
    _left.separatorStyle = UITableViewCellSeparatorStyleNone;
    _left.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dishtype_item_bg"]];
    [self.bg_view addSubview:_left];
    _right = [[UITableView alloc] initWithFrame:CGRectMake(_left.frame.size.width, scroll_y, self.contentView.frame.size.width-_left.frame.size.width, scroll_height)];
    _right.delegate = self;
    _right.dataSource = self;
    _right.separatorStyle = UITableViewCellSeparatorStyleNone;
    _right.backgroundColor = [UIColor whiteColor];
    [self.bg_view addSubview:_right];
    
    UIView *submit_frame = [[UIView alloc] initWithFrame:CGRectMake(0, _left.frame.origin.y+scroll_height, self.contentView.frame.size.width, 60)];
    submit_frame.backgroundColor = bgColor;
    _submit = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 100, 40)];
    [_submit setTitle:@"预览菜单" forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_submit setBackgroundColor:color_selected];
    [_submit addTarget:self action:@selector(onSubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [submit_frame addSubview:_submit];
    [self.bg_view addSubview:submit_frame];
    [self.contentView addSubview:_bg_view];
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onSortByButtonClicked {
    _sort.selected = TRUE;
    _sort_bycomment.selected = false;
    _sort_bysale.selected = false;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"sort" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:sorter,nil];
    for (int i=0; i<dishes.count; i++) {
        [[dishes objectAtIndex:i] sortUsingDescriptors:descriptors];
    }
    [_right reloadData];
}
- (void)onSortBySaleButtonClicked {
    _sort.selected = false;
    _sort_bycomment.selected = false;
    _sort_bysale.selected = TRUE;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"order_number" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:sorter,nil];
    for (int i=0; i<dishes.count; i++) {
        [[dishes objectAtIndex:i] sortUsingDescriptors:descriptors];
    }
    [_right reloadData];
}
- (void)onSortByCommentButtonClicked {
    _sort.selected = false;
    _sort_bycomment.selected = TRUE;
    _sort_bysale.selected = false;
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"zan" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObjects:sorter,nil];
    for (int i=0; i<dishes.count; i++) {
        [[dishes objectAtIndex:i] sortUsingDescriptors:descriptors];
    }
    [_right reloadData];
}
- (void)onSubmitButtonClicked {
    JDOrderViewController *orderController = [[JDOrderViewController alloc] initWithNibName:nil bundle:nil];
    orderController.orderedDishes = orderedDishes;
    orderController.hotelModel = self.hotelModel;
    [self.navigationController pushViewController:orderController animated:YES];
}

-(void)refreshTop{
    _total.text = [NSString stringWithFormat:@"已点%i个菜",orderedDishes.count];
    int p = 0;
    for (int i=0; i<orderedDishes.count; i++) {
        JDDishModel *dish = ((JDDishModel *)[orderedDishes objectAtIndex:i]);
        p+=dish.price_show*dish.count;
    }
    _price.text = [NSString stringWithFormat:@"￥%i",p];
    _price_avg.text = [NSString stringWithFormat:@"，%i人，人均￥%i",_people,p/_people];
}

- (void)addDish:(JDDishModel *)dish indexPath:(NSIndexPath *)indexPath{
    dish.ifOrdered = !dish.ifOrdered;
    [[dishes objectAtIndex:indexPath.section] setObject:dish atIndex:indexPath.row];
    if (dish.ifOrdered) {
        [orderedDishes addObject:dish];
        orderedDishesCount[indexPath.section]++;
    } else {
        [orderedDishes removeObject:dish];
        orderedDishesCount[indexPath.section]--;
    }
    [self refreshTop];
    [_left reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _left) {
        static NSString *reuseId = @"Left";
        JDDishTypeView *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[JDDishTypeView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        if (orderedDishesCount[indexPath.row] == 0) {
            cell.countLabel.hidden = true;
            cell.count_bg.hidden = true;
        } else {
            cell.countLabel.hidden = false;
            cell.count_bg.hidden = false;
            cell.countLabel.text = [NSString stringWithFormat:@"%i",orderedDishesCount[indexPath.row]];
        }
        if (indexPath.row == selectPos) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
            cell.countLabel.textColor = [UIColor whiteColor];
            cell.count_bg.image = [UIImage imageNamed:@"dishtype_ordernumber_bg"];
        } else {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor colorWithRed:250.0f/255.0f green:235.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
            cell.countLabel.textColor = [UIColor colorWithRed:195.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
            cell.count_bg.image = [UIImage imageNamed:@"dishtype_ordernumber_bg2"];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = ((JDDishTypeModel *)[dish_types objectAtIndex:indexPath.row]).type_name;
        return cell;
    } else if(tableView == _right){
        static NSString *reuseId1 = @"Right";
        JDMenuItemView *cell1 = [tableView dequeueReusableCellWithIdentifier:reuseId1];
        if (cell1 == nil) {
            cell1 = [[JDMenuItemView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId1];
        }
        JDDishModel *dish = [[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell1 setModel:dish];
        cell1.dish_img.userInteractionEnabled = YES;
        JDGestureRecognizer *tapGesture1 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickDishImage:)];
        tapGesture1.obj = indexPath;
        [cell1.dish_img addGestureRecognizer:tapGesture1];
        JDGestureRecognizer *tapGesture2 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickAdd:)];
        tapGesture2.obj = indexPath;
        [cell1.add_btn addGestureRecognizer:tapGesture2];
        JDGestureRecognizer *tapGesture3 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickSub:)];
        tapGesture3.obj = indexPath;
        [cell1.sub_btn addGestureRecognizer:tapGesture3];
        if (dish.ifOrdered && dish.price_type == 2) {
            for (int i=0; i<dish.price_list.count; i++) {
                JDGestureRecognizer *tapGesture4 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickFenliang:)];
                tapGesture4.obj = indexPath;
                tapGesture4.what = i;
                [[cell1.btns objectAtIndex:i] addGestureRecognizer:tapGesture4];
            }
        }
        return cell1;
    }
    return nil;
}

-(void)clickFenliang:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    dish.checked_fenliang = gesture.what;
    dish.checked_weight = [(NSNumber *)[[dish.price_list objectAtIndex:gesture.what] objectForKey:@"weight"] intValue];
    dish.price_show = [(NSNumber *)[[dish.price_list objectAtIndex:gesture.what] objectForKey:@"price"] intValue];
    [[dishes objectAtIndex:indexPath.section] setObject:dish atIndex:indexPath.row];
    [self refreshTop];
    [_right reloadData];
}

-(void)closeDishDetail {
    [_detail_bg removeFromSuperview];
    [_detailView removeFromSuperview];
}

- (void)clickDishImage:(JDGestureRecognizer *)gesture  {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    _detail_bg = [[UIView alloc] initWithFrame:_bg_view.frame];
    _detail_bg.backgroundColor = [UIColor blackColor];
    [_detail_bg setBackgroundColor:[UIColor blackColor]];
    _detail_bg.alpha = 0.1f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDishDetail)];
    [_detail_bg addGestureRecognizer:g];
    [self.contentView insertSubview:_detail_bg aboveSubview:_bg_view];
    _detailView = [[JDDishDetailView alloc] initWithFrame:CGRectMake(20, 10, _detail_bg.frame.size.width-40, 450) andDish:dish];
    _detailView.userInteractionEnabled = true;
    JDGestureRecognizer *g1 = [[JDGestureRecognizer alloc] initWithTarget:self action:@selector(clickAddDish:)];
    g1.obj = indexPath;
    _detailView.addBtn.userInteractionEnabled = true;
    _detailView.closeBtn.userInteractionEnabled = true;
    [_detailView.addBtn addGestureRecognizer:g1];
    [_detailView.closeBtn addGestureRecognizer:g];
    [self.contentView insertSubview:_detailView aboveSubview:_detail_bg];
    
}

- (void)clickAddDish:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self closeDishDetail];
    [self addDish:dish indexPath:indexPath];
    [_right reloadData];
}

- (void)clickAdd:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (dish.price_type==1) {
        dish.checked_weight+=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_weight"] intValue];
        dish.price_show+=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_price"] intValue];
    } else {
        dish.count+=1;
    }
   
    [[dishes objectAtIndex:indexPath.section] setObject:dish atIndex:indexPath.row];
    [_right reloadData];
    [self refreshTop];
}

- (void)clickSub:(JDGestureRecognizer *)gesture {
    NSIndexPath *indexPath = (NSIndexPath *)gesture.obj;
    JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (dish.price_type==1) {
        if (dish.checked_weight<=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"first_weight"] intValue]) {
            [self addDish:dish indexPath:indexPath];
            [_right reloadData];
        } else {
            dish.checked_weight-=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_weight"] intValue];
            dish.price_show-=[(NSNumber *)[[dish.price_list objectAtIndex:0] objectForKey:@"add_price"] intValue];
            [[dishes objectAtIndex:indexPath.section] setObject:dish atIndex:indexPath.row];
            [_right reloadData];
        }
    } else {
        if (dish.count <= 1) {
            [self addDish:dish indexPath:indexPath];
            [_right reloadData];
        } else {
            dish.count-=1;
            [[dishes objectAtIndex:indexPath.section] setObject:dish atIndex:indexPath.row];
            [_right reloadData];
        }
    }
    [self refreshTop];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _right) {
        JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (dish.price_type==2&&dish.ifOrdered) {
            return 100;
        }
        return 80;
    }
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == _right) {
        return [(JDDishTypeModel *)[dish_types objectAtIndex:section] type_name];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView == _left) {
        return 1;
    } else {
        return dish_types.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _left) {
        return dish_types.count;
    } else if(tableView == _right){
        return ((NSArray *)[dishes objectAtIndex:section]).count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _right) {
        selectPos = indexPath.section;
        [_left reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _left) {
        selectPos = indexPath.row;
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        [_right scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:true];
        [_left reloadData];
    } else if(tableView == _right){
        JDDishModel *dish = (JDDishModel *)[[dishes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if ([dish.status isEqualToString:@"正常"]) {
            [self addDish:dish indexPath:indexPath];
            [_right reloadData];
        } else {
            [JDHXLUtil showHintHUD:dish.status_reason inView:self.contentView withSlidingMode:WBNoticeViewSlidingModeUp];
        }
    }
}
-(BOOL)automaticallyAdjustsScrollViewInsets{
    return false;
}
@end
