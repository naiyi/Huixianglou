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
#import "DCKeyValueObjectMapping.h"

@implementation JDMenuController
{
    NSMutableArray *dish_types;
    NSMutableArray *allDishes;//所有菜的集合
    NSMutableArray *dishes;//所有菜的分类集合
    int selectPos;//左侧listview的选中位置
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
    dish_types = [[NSMutableArray alloc] init];
    dishes = [[NSMutableArray alloc] init];
    allDishes = [[NSMutableArray alloc] init];
    [self setNavigationLeftButtonWithImage:[UIImage imageNamed:@"back_btn_bg"] Target:self Action:@selector(onBackButtonClicked)];
    //[self setNavigationRightButtonWithImage:[UIImage imageNamed:@"setting_btn_bg"] Target:self Action:@selector(onSettingButtonClicked)];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    _total = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 20)];
    _total.text = @"已点0个菜";
    _total.textColor = [UIColor blackColor];
    _total.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [titleView addSubview:_total];
    _price = [[UILabel alloc] initWithFrame:CGRectMake(0, _total.frame.size.height, 30, 20)];
    _price.text = @"￥0";
    _price.textColor = [UIColor redColor];
    [titleView addSubview:_price];
    _price_avg = [[UILabel alloc] initWithFrame:CGRectMake(_price.frame.size.width, _total.frame.size.height, 150, 20)];
    _price_avg.text = @"，0人，人均￥0";
    _price_avg.textColor = [UIColor grayColor];
    [titleView addSubview:_price_avg];
    [self setNavigationTitleView:titleView];
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
                for (int j=0; j<dishType.number; j++) {
                    NSArray *innerDishes = [mapper1 parseArray:dishType.dish_list];
                    [dishes addObject:innerDishes];
                    [allDishes addObjectsFromArray:innerDishes];
                }
            }
            [self setNetworkState:NETWORK_STATE_NORMAL];
        }
    } failure:^(NSString *errorStr) {
        [self setNetworkState:NETWORK_STATE_NOTAVILABLE];
    }];
    
}

- (void)setContentView
{
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
    [self.contentView addSubview:sortView];
    
    float scroll_height = self.contentView.frame.size.height-sortView.frame.size.height-sortView.frame.origin.y-60;
    float scroll_y = sortView.frame.origin.y+sortView.frame.size.height;
    _left = [[UITableView alloc] initWithFrame:CGRectMake(0, scroll_y, 90, scroll_height)];
    _left.delegate = self;
    _left.dataSource = self;
    _left.separatorStyle = UITableViewCellSeparatorStyleNone;
    _left.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dishtype_item_bg"]];
    [self.contentView addSubview:_left];
    _right = [[UITableView alloc] initWithFrame:CGRectMake(_left.frame.size.width, scroll_y, self.contentView.frame.size.width-_left.frame.size.width, scroll_height)];
    _right.delegate = self;
    _right.dataSource = self;
    _right.separatorStyle = UITableViewCellSeparatorStyleNone;
    _right.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_right];
    
    UIView *submit_frame = [[UIView alloc] initWithFrame:CGRectMake(0, _left.frame.origin.y+scroll_height, self.contentView.frame.size.width, 60)];
    submit_frame.backgroundColor = bgColor;
    _submit = [[UIButton alloc] initWithFrame:CGRectMake(110, 10, 100, 40)];
    [_submit setTitle:@"预览菜单" forState:UIControlStateNormal];
    [_submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [_submit setBackgroundColor:color_selected];
    [_submit addTarget:self action:@selector(onSubmitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [submit_frame addSubview:_submit];
    [self.contentView addSubview:submit_frame];
}

- (void)onBackButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)onSortByButtonClicked {
    _sort.selected = TRUE;
    _sort_bycomment.selected = false;
    _sort_bysale.selected = false;
}
- (void)onSortBySaleButtonClicked {
    _sort.selected = false;
    _sort_bycomment.selected = false;
    _sort_bysale.selected = TRUE;
}
- (void)onSortByCommentButtonClicked {
    _sort.selected = false;
    _sort_bycomment.selected = TRUE;
    _sort_bysale.selected = false;
}
- (void)onSubmitButtonClicked {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _left) {
        static NSString *reuseId = @"Left";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(_left.frame.size.width-15, 2, 15, 15)];
        count.text = @"1";
        [cell addSubview:count];
        NSLog(@"%i",selectPos);
        if (indexPath.row == selectPos) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor colorWithRed:100.0f/255.0f green:60.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
        } else {
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor colorWithRed:250.0f/255.0f green:235.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.text = ((JDDishTypeModel *)[dish_types objectAtIndex:indexPath.row]).type_name;
        return cell;
    } else if(tableView == _right){
        static NSString *reuseId1 = @"Right";
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:reuseId1];
        if (cell1 == nil) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId1];
        }
        return cell1;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _left) {
        return dish_types.count;
    } else if(tableView == _right){
        return ((NSArray *)[dishes objectAtIndex:selectPos]).count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _left) {
        selectPos = indexPath.row;
        [tableView reloadData];
    } else if(tableView == _right){
        
    }
}
@end
