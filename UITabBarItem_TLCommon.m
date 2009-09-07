//
//  UITabBarItem_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/4/09.
//

#import "UITabBarItem_TLCommon.h"
#import "UIImage_TLCommon.h"

@implementation UITabBarItem (TLCommon)

+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName {
  return [[self class] tabBarItemWithTitle:title imageName:imageName imageExtension:@"png"];
}


+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title imageName:(NSString *)imageName imageExtension:(NSString *)imageExtension  {
  UIImage *tabBarImage = [UIImage imageWithName:imageName extension:imageExtension];
  UITabBarItem *tabBarItem = [[[[self class] alloc] initWithTitle:title
                                                            image:tabBarImage
                                                              tag:0]
                              autorelease];
  return tabBarItem;
}

@end
