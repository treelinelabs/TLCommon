//
//  NSString_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <Foundation/Foundation.h>


@interface NSString (TLCommon)

- (NSString *)md5;
- (NSString *)stringByURLEncodingAllCharacters; // including &, %, ?, =, and other url "safe" characters

@end
