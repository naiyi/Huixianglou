//
//  JDSettingsViewController.h
//  HXL
//
//  Created by Roc on 14-6-9.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDHXLParentViewController.h"
#import "iRate.h"
#import "MBProgressHUD.h"

@interface JDSettingsViewController : JDHXLParentViewController<UIAlertViewDelegate>
{
    UIView *settingItem1;
    UIView *settingItem2;
    UIView *settingItem3;
    
    UILabel *nameLabel;
    UILabel *nameEdit;
    UILabel *aboutusLabel;
    UILabel *feedbackLable;
    UILabel *clearLabel;
    UILabel *clearEdit;
    UILabel *checkupdateLabel;
    UILabel *scoreLabel;
    
    UIView *bottomView;
    UIButton *logoutButton;
    
    MBProgressHUD *HUD;
}
@end
