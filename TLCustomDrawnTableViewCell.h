//
//  TLCustomDrawnTableViewCell.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <UIKit/UIKit.h>

@interface TLCustomDrawnTableViewCell : UITableViewCell {
@private
  UIView *customView;
  NSSet *keyPathsRequiringRedisplay;
  UIColor *cellColor;
  UIColor *selectedCellColor;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil;

- (void)drawContentsInRect:(CGRect)rect; // subclasses should override this

@property(nonatomic, assign, readonly) UIView *customView;
@property(nonatomic, retain, readwrite) UIColor *cellColor;
@property(nonatomic, retain, readwrite) UIColor *selectedCellColor;

@end
