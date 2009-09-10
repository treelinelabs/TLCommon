//
//  TLModalActivityIndicatorView.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import <UIKit/UIKit.h>

@interface TLModalActivityIndicatorView : UIView {
@private
  UIActivityIndicatorView *spinner;
}

- (id)initWithText:(NSString *)text;
- (void)show;
- (void)dismiss;


@end
