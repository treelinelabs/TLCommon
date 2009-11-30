//
//  NSDictionary_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (TLCommon)

- (NSString *)queryString; // dictionary may contain strings, dicts, arrays; else it uses -description

// All the following functions take care of ensuring that objectForKey: returns a particular
// kind of object. If it isn't the right kind of object, they return nil;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSError *)errorForKey:(NSString *)key;
- (id)objectOfClass:(Class)desiredClass forKey:(NSString *)key;

// Returns anything but NSNull; returns nil instead of NSNull
- (id)nonNullObjectForKey:(NSString *)key;

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;

@end
