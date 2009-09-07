//
//  UIImage_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/7/09.
//

#import "UIImage_TLCommon.h"


@implementation UIImage (TLCommon)

+ (UIImage *)imageWithName:(NSString *)fileName {
  return [[self class] imageWithName:fileName extension:@"png"];
}

+ (UIImage *)imageWithName:(NSString *)fileName extension:(NSString *)fileExtension {
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExtension];
  return [[self class] imageWithContentsOfFile:imagePath];
}

@end
