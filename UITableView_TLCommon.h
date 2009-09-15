//
//  UITableView_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/15/09.
//

#import <Foundation/Foundation.h>


@interface UITableView (TLCommon)

- (void)reloadRowAtRow:(NSUInteger)row section:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

@end
