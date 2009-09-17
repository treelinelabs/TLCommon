//
//  NSMutableDictionary_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/17/09.
//

#import <Foundation/Foundation.h>


@interface NSMutableDictionary (TLCommon)

- (void)ifNotNilSetObject:(id)obj forKey:(NSString *)key; // ignores the request if object is nil, else calls setObject:forKey:
- (void)setDouble:(double)d forKey:(NSString *)key; // creates an NSNumber to wrap the double, sets it
- (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key; // creates NSNumber

@end
