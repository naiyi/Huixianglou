//
//  JDHXLParentViewController.h
//  HXL
//
//  Created by Roc on 14-6-9.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDHXLParentViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *notavilableView;
@property (nonatomic, strong) UIView *contentView;

- (void)setNavigationLeftButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector;
- (void)setNavigationRightButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector;
- (void)setNavigationTitle:(NSString *)title;
- (void)setNavigationTitleView:(UIView *)view;
- (void)setNetworkState:(int)state;
- (void)setContentView;

@end
