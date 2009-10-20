//
//  UIBarButtonItem_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import "UIBarButtonItem_TLCommon.h"
#import "UIActivityIndicatorView_TLCommon.h"

@implementation UIBarButtonItem (TLCommon)

+ (UIBarButtonItem *)spinnerBarButtonItem {
  UIActivityIndicatorView *spinner = [UIActivityIndicatorView animatingActivityIndicatorViewWithStyle:UIActivityIndicatorViewStyleWhite];
  
  UIBarButtonItem *spinnerBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:spinner] autorelease];
  spinnerBarButtonItem.enabled = NO;
  
  return spinnerBarButtonItem;
}

+ (UIBarButtonItem *)barButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action {
  return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action] autorelease];
}


@end
