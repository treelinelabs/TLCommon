//
//  UITabBarItem_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/4/09.
//

#import <Foundation/Foundation.h>


@interface UITabBarItem (TLCommon)

// Assumes imageExtension == @"png"
+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName;

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName imageExtension:(NSString *)imageExtension;

@end
