//
//  TLScrollingSegmentedControl.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <UIKit/UIKit.h>

@protocol TLScrollingSegmentedControlDelegate;

@interface TLScrollingSegmentedControl : UIView<UIScrollViewDelegate> {
@private
  UIScrollView *scrollView;
  UISegmentedControl *segmentedControl;
  NSArray *segmentTitles;
  id<TLScrollingSegmentedControlDelegate> delegate;
  CAGradientLayer *leftFog;
  CAGradientLayer *rightFog;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (BOOL)setSelectedTitle:(NSString *)title animated:(BOOL)animated;
- (void)setTintColor:(UIColor *)tintColor;
+ (CGFloat)recommendedHeight; // if you make this view have a different height than this, it'll be ugly!

@property(nonatomic, assign, readwrite) id<TLScrollingSegmentedControlDelegate> delegate;

@end
