//
//  TLScrollingSegmentedControlDelegate.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

@class TLScrollingSegmentedControl;

@protocol TLScrollingSegmentedControlDelegate<NSObject>

@optional

- (void)scrollingSegmentedControl:(TLScrollingSegmentedControl *)strip
                   didSelectTitle:(NSString *)newlySelectedTitle;

@end
