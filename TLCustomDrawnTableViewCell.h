//
//  TLCustomDrawnTableViewCell.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <UIKit/UIKit.h>
#import "TLTableViewCell.h"

@interface TLCustomDrawnTableViewCell : TLTableViewCell {
@private
  UIView *customView;
  NSSet *keyPathsRequiringRedisplay;
}

+ (TLCustomDrawnTableViewCell *)tableViewCellDequeuedIfPossibleFromTableView:(UITableView *)tableView
                                                  keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil;

+ (TLCustomDrawnTableViewCell *)tableViewCellDequeuedIfPossibleFromTableView:(UITableView *)tableView
                                                             reuseIdentifier:(NSString *)reuseIdentifier
                                                  keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil;
  
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil;

- (void)drawContentsInRect:(CGRect)rect; // subclasses should override this

// Draws the provided image at the left of the table view cell,
// leaving some left and right padding, centering the image vertically,
// using the provided size and content view mode. Supported content
// view modes right now are scale fit, aspect fill, and aspect fit.
// Returns the total x dimension of the image + all padding. (Useful
// for subsequent layout.)
- (CGFloat)drawLeftImage:(UIImage *)image
                    size:(CGSize)size
             leftPadding:(CGFloat)leftPadding
            rightPadding:(CGFloat)rightPadding
            cornerRadius:(CGFloat)cornerRadius
             contentMode:(UIViewContentMode)contentMode;

@property(nonatomic, assign, readonly) UIView *customView;

@end
