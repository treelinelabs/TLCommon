//
//  NSDate_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <Foundation/Foundation.h>


@interface NSDate (TLCommon)

+ (NSString *)unixTimestamp; // No 2037 failures for us!

@end
