//
//  AppDelegate.h
//  ThePickledFrog
//
//  Created by Ashley Templeman on 26/9/17.
//  Copyright © 2017 Keep It Simple Travel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) HomeViewController *viewController;

@end
