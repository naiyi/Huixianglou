//
//  JDAppDelegate.h
//  HXL
//
//  Created by zhang yi on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDAppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>
{
    BOOL manualCheckUpdate;
    UIImageView *image;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;

@end
