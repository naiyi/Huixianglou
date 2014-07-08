//
//  JDSubmitOrderController.h
//  HXL
//
//  Created by Roc on 14-6-30.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"
#import "IZValueSelectorView.h"
#import "JDDishModel.h"

@interface JDSubmitOrderController : JDHXLParentViewController<IZValueSelectorViewDataSource, IZValueSelectorViewDelegate, UITextViewDelegate>
{
    UIImageView *centerView;
    UIView *bottomView;
    UIButton *submitButton;
    NSString *requestroom;
    
    NSDate *lastTime;
    
    NSMutableArray *dateArray;
    NSMutableArray *timeArray;
    
    UITextView *moreField;
    
    IZValueSelectorView *dateSelector;
    IZValueSelectorView *timeSelector;
    
    UIButton *room_no;
    UIButton *room_yes;
    
    BOOL keyBoardShowing;
    
    UILabel *nameEdit;
}

@property (nonatomic, strong)NSArray *orderedDishes;
@property (nonatomic, strong)JDHotelModel *hotelModel;
@property (nonatomic, strong)NSString *currentSelectedRoom;
@property (nonatomic, strong)NSString *currentSelectedDate;
@property (nonatomic, strong)NSString *currentSelectedTime;
@property (nonatomic) int people;

@end
