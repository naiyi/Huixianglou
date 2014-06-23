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
}

@property (nonatomic, strong)JDUserModel *userModel;

@end
