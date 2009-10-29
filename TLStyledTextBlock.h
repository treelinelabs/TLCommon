//
//  TLStyledTextBlock.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import <Foundation/Foundation.h>

@class TLStyledTextFragment;

@interface TLStyledTextBlock : NSObject {
@private
  NSMutableArray *lines; // each of these is an array of TLDrawnTextFragments
  CGFloat lineWidth;
  NSMutableDictionary *originalFragmentForNewFragment;
  NSMutableDictionary *newFragmentsForOriginalFragment;
}

+ (TLStyledTextBlock *)blockWithFragments:(NSArray *)textFragments lineWidth:(CGFloat)width;
- (CGFloat)height;

- (NSArray *)siblingFragmentsForFragment:(TLStyledTextFragment *)fragment;
- (TLStyledTextFragment *)originalFragmentForFragment:(TLStyledTextFragment *)fragment;

- (void)renderAtPoint:(CGPoint)point textAlignment:(UITextAlignment)textAlignment;
- (TLStyledTextFragment *)fragmentAtPoint:(CGPoint)pointWithinTextBlock;

@end
