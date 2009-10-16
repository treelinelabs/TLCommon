//
//  NSMutableString_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/16/09.
//

#import <Foundation/Foundation.h>


@interface NSMutableString (TLCommon)

- (void)deleteSuffix:(NSString *)suffix; // if receiver has given suffix, that suffix is removed; otherwise, receiver is unchanged

@end
