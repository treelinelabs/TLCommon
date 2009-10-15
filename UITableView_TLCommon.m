//
//  UITableView_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/15/09.
//

#import "UITableView_TLCommon.h"

@implementation UITableView (TLCommon)

- (void)reloadRowAtRow:(NSUInteger)row section:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
  [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:section]]
              withRowAnimation:animation];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
  [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
              withRowAnimation:animation];  
}


@end
