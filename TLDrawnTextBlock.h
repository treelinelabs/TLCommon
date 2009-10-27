//
//  TLDrawnTextBlock.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import <Foundation/Foundation.h>

@class TLDrawnTextFragment;

@interface TLDrawnTextBlock : NSObject {
@private
  NSMutableArray *lines; // each of these is an array of TLDrawnTextFragments
  NSMutableDictionary *originalFragmentForNewFragment;
  NSMutableDictionary *newFragmentsForOriginalFragment;
}

+ (TLDrawnTextBlock *)blockWithFragments:(NSArray *)textFragments width:(CGFloat)lineWidth;
- (CGFloat)height;

- (NSArray *)siblingFragmentsForFragment:(TLDrawnTextFragment *)fragment;
- (TLDrawnTextFragment *)originalFragmentForFragment:(TLDrawnTextFragment *)fragment;

- (void)renderAtPoint:(CGPoint)point textAlignment:(UITextAlignment)textAlignment;
- (TLDrawnTextFragment *)fragmentAtPoint:(CGPoint)pointWithinTextBlock;

@end
