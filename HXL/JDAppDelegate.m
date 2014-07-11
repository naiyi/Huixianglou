//
//  JDAppDelegate.m
//  HXL
//
//  Created by zhang yi on 14-6-6.
//  Copyright (c) 2014年 胶东在线. All rights reserved.
//

#import "JDAppDelegate.h"
#import "JDMainViewController.h"
#import "iVersion.h"
#import "iRate.h"
#import <MAMapKit/MAMapKit.h>

@implementation JDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [self checkForUpdate];
    
    [MAMapServices sharedServices].apiKey = @"eb36708956f817a1bd9b65af142918c4";
    
    return YES;
}

-(void)checkForUpdate
{
    manualCheckUpdate = true;
    JDOHttpClient *httpclient = [JDOHttpClient sharedClient];
    [httpclient getPath:GET_VERSION parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = [(NSData *)responseObject objectFromJSONData];
        float jsonvalue = [[json objectForKey:@"data"] floatValue];
        if (jsonvalue > 1.0) {
            manualCheckUpdate = false;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"您当前使用的版本过低，请更新后使用"
                                                           delegate:self
                                                  cancelButtonTitle:@"更新"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            [self toMainCOntroller];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [iVersion sharedInstance].ignoredVersion = nil;
        [[iVersion sharedInstance] checkForNewVersion];
    }
}

- (void)toMainCOntroller
{
    if (manualCheckUpdate) {
        manualCheckUpdate = false;
        [[iVersion sharedInstance] checkForNewVersion];
    }
    JDMainViewController *mainController = [[JDMainViewController alloc] init];
    self.navigation = [[UINavigationController alloc] initWithRootViewController:mainController];
    //[self.navigation setNavigationBarHidden:YES];
    // Override point for customization after application launch.
    self.window.rootViewController = self.navigation;
}

+ (void)initialize{
    //发布时替换bundleId,注释掉就可以
    //NSString *bundleID = @"com.glavesoft.app.17lu";
    //[iVersion sharedInstance].applicationBundleID = bundleID;
    //[iVersion sharedInstance].applicationVersion = @"1.0.0.0"; // 覆盖bundle中的版本信息,测试用
    
    [iVersion sharedInstance].verboseLogging = true;   // 调试信息
    [iVersion sharedInstance].appStoreCountry = @"CN";
    [iVersion sharedInstance].showOnFirstLaunch = false; // 不显示当前版本特性
    [iVersion sharedInstance].remindPeriod = 1.0f;
    [iVersion sharedInstance].ignoreButtonLabel = @"忽略此版本";
    [iVersion sharedInstance].remindButtonLabel = @"以后提醒";
    // 由于视图层级的原因,在程序内弹出appstore会被覆盖到下层导致看不到
    [iVersion sharedInstance].displayAppUsingStorekitIfAvailable = false;
    //[iVersion sharedInstance].checkAtLaunch = NO;
    
    [iRate sharedInstance].verboseLogging = false;
    [iRate sharedInstance].appStoreCountry = @"CN";
    [iRate sharedInstance].applicationName = @"汇湘楼客户端";
    //    [iRate sharedInstance].daysUntilPrompt = 10;
    //    [iRate sharedInstance].usesUntilPrompt = 10;
	[iRate sharedInstance].onlyPromptIfLatestVersion = false;
    [iRate sharedInstance].displayAppUsingStorekitIfAvailable = false;
    [iRate sharedInstance].promptAtLaunch = NO;
}


#pragma mark - 版本检查相关

- (void)iVersionUserDidIgnoreUpdate:(NSString *)version{

}

- (void)iVersionVersionCheckDidFailWithError:(NSError *)error{

}

- (void)iVersionDidNotDetectNewVersion{

}

- (void)iVersionDidDetectNewVersion:(NSString *)version details:(NSString *)versionDetails{

}

- (BOOL)iVersionShouldDisplayNewVersion:(NSString *)version details:(NSString *)versionDetails{
	return !manualCheckUpdate;
}

// 不显示当前版本信息
- (BOOL)iVersionShouldDisplayCurrentVersionDetails{
    return false;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
