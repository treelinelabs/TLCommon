//
//  NSMutableDictionary_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/17/09.
//

#import "NSMutableDictionary_TLCommon.h"

@implementation NSMutableDictionary (TLCommon)

- (void)ifNotNilSetObject:(id)obj forKey:(NSString *)key {
  if(obj) {
    [self setObject:obj forKey:key];
  }
}

- (void)setDouble:(double)d forKey:(NSString *)key {
  [self setObject:[NSNumber numberWithDouble:d] forKey:key];
}

- (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key {
  [self setObject:[NSNumber numberWithBool:yesOrNo] forKey:key];
}

@end
