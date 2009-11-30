//
//  NSDictionary_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSDictionary_TLCommon.h"
#import "NSString_TLCommon.h"

@implementation NSDictionary (TLCommon)

- (NSString *)queryString {
  NSMutableString *queryString = [NSMutableString string];
  for(id key in self) {
    NSString *encodedKey = [[key description] stringByURLEncodingAllCharacters];
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSArray class]]) {
      for(id obj in value) {
        [queryString appendFormat:@"%@=%@",
         encodedKey,
         [[obj description] stringByURLEncodingAllCharacters]
         ];
        [queryString appendString:@"&"];
      }
    } else if([value isKindOfClass:[NSDictionary class]]) {
      for(id subkey in value) {
        [queryString appendFormat:@"%@%5B%@%5D=%@",
         encodedKey,
         [[subkey description] stringByURLEncodingAllCharacters],
         [[[value objectForKey:subkey] description] stringByURLEncodingAllCharacters]
         ];
        [queryString appendString:@"&"];
      }
    } else if([value isKindOfClass:[NSNull class]]) {
      [queryString appendFormat:@"%@=",
       encodedKey
       ];
      [queryString appendString:@"&"];
    } else {
      [queryString appendFormat:@"%@=%@",
       encodedKey,
       [[value description] stringByURLEncodingAllCharacters]
       ];
      [queryString appendString:@"&"];
    }
  }
  if([queryString length] > 0) {
    [queryString deleteCharactersInRange:NSMakeRange([queryString length] - 1, 1)]; // remove trailing &    
  }
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

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  NSArray *components = [queryString componentsSeparatedByString:@"&"];
  for(NSString *component in components) {
    if([component length] > 0) {
      NSRange equalsPosition = [component rangeOfString:@"="];
      NSString *key = nil;
      NSString *value = nil;
      if(equalsPosition.location == NSNotFound) {
        key = [key stringByURLDecodingAllCharacters];
      } else {
        key = [[component substringToIndex:equalsPosition.location] stringByURLDecodingAllCharacters];
        value = [[component substringFromIndex:NSMaxRange(equalsPosition)] stringByURLDecodingAllCharacters];
      }

      if(!value) {
        value = @"";
      }

      if(key) {
        [dict setObject:value forKey:key];        
      }
    }
  }
  return dict;
}

@end
