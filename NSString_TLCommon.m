//
//  NSString_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "NSString_TLCommon.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TLCommon)

// Adapted from Three20
- (NSString *)md5 {
  const char *str = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(str, strlen(str), result);
  
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

- (NSString *)stringByURLEncodingAllCharacters {
  NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (CFStringRef)self,
                                                                                NULL,
                                                                                (CFStringRef)@"&()<>@,;:\\\"/[]?=",
                                                                                kCFStringEncodingUTF8);
  [encodedString autorelease];
  return encodedString;
}

@end
