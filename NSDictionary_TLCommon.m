//
//  NSDictionary_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSDictionary_TLCommon.h"



@implementation NSDictionary (TLCommon)

- (NSString *)queryString {
  NSMutableString *queryString = [NSMutableString string];
  for(NSString *key in self) {
    NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSArray class]]) {
      for(id obj in value) {
        [queryString appendFormat:@"%@=%@",
         encodedKey,
         [[value description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
         ];
      }
    } else if([value isKindOfClass:[NSDictionary class]]) {
      for(NSString *subkey in value) {
        [queryString appendFormat:@"%@%5B%@%5D=%@",
         encodedKey,
         [subkey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
         [[[value objectForKey:subkey] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
         ];
      }
    } else if([value isKindOfClass:[NSNull class]]) {
      [queryString appendFormat:@"%@=",
       encodedKey
       ];
    } else {
      [queryString appendFormat:@"%@=%@",
       encodedKey,
       [[value description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
       ];
    }
    [queryString appendString:@"&"];
  }
  [queryString deleteCharactersInRange:NSMakeRange([queryString length] - 1, 1)]; // remove trailing &
  return queryString;
}

- (id)objectOfClass:(Class)desiredClass forKey:(NSString *)key {
  id obj = [self objectForKey:key];
  if(![obj isKindOfClass:desiredClass]) {
    obj = nil;
  }
  return obj;
}

- (NSString *)stringForKey:(NSString *)key {
  return (NSString *)[self objectOfClass:[NSString class] forKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key {
  return (NSArray *)[self objectOfClass:[NSArray class] forKey:key];
}

- (NSNumber *)numberForKey:(NSString *)key {
  return (NSNumber *)[self objectOfClass:[NSNumber class] forKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key {
  return (NSDictionary *)[self objectOfClass:[NSDictionary class] forKey:key];
}

- (NSError *)errorForKey:(NSString *)key {
  return (NSError *)[self objectOfClass:[NSError class] forKey:key];
}

- (id)nonNullObjectForKey:(NSString *)key {
  id obj = [self objectForKey:key];
  if(obj == [NSNull null]) {
    obj = nil;
  }
  return obj;
}

@end
