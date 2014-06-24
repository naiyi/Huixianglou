//
//  JDUserViewController.h
//  HXL
//
//  Created by Roc on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDHXLParentViewController.h"
#import "JDUserModel.h"

@interface JDUserViewController : JDHXLParentViewController<UITextFieldDelegate>
{
    UIImageView *centerView;
    UIView *bottomView;
    UIButton *loginButton;
    UITextField *nameField;
    UITextField *telField;
    UITextField *codeField;
    UIButton *codeButton;
    NSTimer *codeTimer;
    int timerindex;
    BOOL keyBoardShowing;
    
    UIScrollView *userView;
    UIView *userinfoView;
    UIView *currentOrderView;
    UIView *historyOrderView;
    UIView *scoreView;
    
    UILabel *currentTitle;
    UILabel *currentHotel;
    UILabel *currentDate;
    UILabel *currentDetail;
    UILabel *currentMore;
    
    UILabel *historyTitle;
    UILabel *historyHotel;
    UILabel *historyDate;
    UILabel *historyDetail;
    UILabel *historyMore;
    
    UILabel *scoreTitle;
    UILabel *scoreDate1;
    UILabel *scoreNum1;
    UILabel *scoreDate2;
    UILabel *scoreNum2;
    
    UILabel *userName;
    UILabel *userTel;
    UIImageView *userImage;
}

@property (nonatomic, strong)JDUserModel *userModel;

@end
