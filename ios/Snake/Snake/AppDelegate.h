//
//  AppDelegate.h
//  Snake
//
//  Created by Charles Key on 8/25/11.
//  Copyright Paranoid Ferret Productions 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
