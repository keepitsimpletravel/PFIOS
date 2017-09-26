//
//  AppDelegate.m
//  ThePickledFrog
//
//  Created by Ashley Templeman on 26/9/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

//
//  AppDelegate.m
//  HostelBlocks
//
//  Created by Ashley Templeman on 12/4/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "RightViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    
    // Set from Configuration PList
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    NSDictionary *configurationValues = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSString *appTitle = [configurationValues objectForKey:@"AppTitle"];
    homeViewController.title = appTitle;
    
    
    RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rightViewController frontViewController:frontNavigationController];
    revealController.delegate = self;

    revealController.rightViewController = rightViewController;

    self.viewController = revealController;
    
    //PushNotificaiton
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    
    NSDictionary *aps = (NSDictionary *)[userInfo objectForKey:@"aps"];
    NSString* alertValue = [aps valueForKey:@"badge"];
    NSInteger badgeValue= [alertValue integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeValue];
    
    NSLog(@"Push Notification Information : %@",userInfo);
}


@end
