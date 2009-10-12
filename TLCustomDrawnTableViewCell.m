//
//  TLCustomDrawnTableViewCell.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "TLCustomDrawnTableViewCell.h"
#import "CGGeometry_TLCommon.h"
#import "CGContext_TLCommon.h"

#pragma mark -

@interface TLCustomDrawnTableViewCellCustomView : UIView {
  TLCustomDrawnTableViewCell *parentCell;
}

@property(nonatomic, assign, readwrite) TLCustomDrawnTableViewCell *parentCell;

@end


#pragma mark -

@implementation TLCustomDrawnTableViewCellCustomView

@synthesize parentCell;

- (id)initWithFrame:(CGRect)frame {
  if(self = [super initWithFrame:frame]) {
    self.opaque = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  if(self.parentCell.selected || self.parentCell.highlighted) {
    // Paint a white background first to show through, so any alpha does something
    if(self.parentCell.selectedCellColor) {
      [[UIColor whiteColor] setFill];
      UIRectFill(rect);
      [self.parentCell.selectedCellColor setFill];
      UIRectFillUsingBlendMode(rect, kCGBlendModeMultiply);      
    }
  } else {
    if(self.parentCell.cellColor) {
      [[UIColor whiteColor] setFill];
      UIRectFill(rect);
      [self.parentCell.cellColor setFill];
      UIRectFillUsingBlendMode(rect, kCGBlendModeMultiply);      
    }
  }
  CGContextRestoreGState(context);
  [self.parentCell drawContentsInRect:rect];
}

@end


#pragma mark -

@implementation TLCustomDrawnTableViewCell

@synthesize customView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil {
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGRect customViewFrame = CGRectZeroWithSize(self.contentView.bounds.size);
    customView = [[[TLCustomDrawnTableViewCellCustomView alloc] initWithFrame:customViewFrame] autorelease];
    ((TLCustomDrawnTableViewCellCustomView *)customView).parentCell = self;
    [self.contentView addSubview:self.customView];
    keyPathsRequiringRedisplay = [redisplayRequiringKeyPathsOrNil retain];
    for(NSString *keyPath in keyPathsRequiringRedisplay) {
      [self addObserver:self forKeyPath:keyPath options:0 context:NULL];   
    }
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if((self == object) && [keyPathsRequiringRedisplay containsObject:keyPath]) {
    [self.customView setNeedsDisplay];
  }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
  [super didTransitionToState:state];
  [self.customView setNeedsDisplay];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
  [super willTransitionToState:state];
  [self.customView setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[self.customView setNeedsDisplay];
}

- (void)drawContentsInRect:(CGRect)rect {
  // subclasses override this  
}

- (void)dealloc {
  for(NSString *keyPath in keyPathsRequiringRedisplay) {
    [self removeObserver:self forKeyPath:keyPath];
  }
  [keyPathsRequiringRedisplay release], keyPathsRequiringRedisplay = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Drawing utilities for subclasses' use

- (CGFloat)drawLeftImage:(UIImage *)image
                    size:(CGSize)size
             leftPadding:(CGFloat)leftPadding
            rightPadding:(CGFloat)rightPadding
            cornerRadius:(CGFloat)cornerRadius
             contentMode:(UIViewContentMode)contentMode {

  // Calculate two rects: The image drawing rect, and
  // the clipping rect.
  
  CGRect clippingRect = CGRectWithXYAndSize(leftPadding,
                                            OffsetToCenterFloatInFloat(size.height, self.customView.bounds.size.height),
                                            size);
  

  // some handy precalculations
  CGFloat destinationAspectRatio = size.width / size.height;
  CGFloat imageAspectRatio = image.size.width / image.size.height;

  CGSize imageDrawingSize = CGSizeZero;  
  switch(contentMode) {
    case UIViewContentModeScaleToFill:;
      imageDrawingSize = size;
      break;
    case UIViewContentModeScaleAspectFit:;
      CGFloat fitScalingFactor = 1;
      if(destinationAspectRatio > imageAspectRatio) {
        fitScalingFactor = size.height / image.size.height;
      } else {
        fitScalingFactor = size.width / image.size.width;
      }
      imageDrawingSize = ScaledSize(image.size, fitScalingFactor);
      break;
    case UIViewContentModeScaleAspectFill:;
      CGFloat fillScalingFactor = 1;
      if(destinationAspectRatio > imageAspectRatio) {
        fillScalingFactor = size.width / image.size.width;
      } else {
        fillScalingFactor = size.height / image.size.height;
      }
      imageDrawingSize = ScaledSize(image.size, fillScalingFactor);
      break;
    default:
      NSLog(@"Content mode %i not supported!", contentMode);
      break;
  }
  
  // Now that we have the size, pick a drawing rect that centers the drawn image size in its clipping rect
  CGRect imageDrawingRect = CenteredRectInRectWithSize(clippingRect, imageDrawingSize);
  
  // Set up the rounded corners and draw!

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextBeginPath(context);
  CGContextAddRoundedRectToPath(context, clippingRect, cornerRadius, cornerRadius);
  CGContextClosePath(context);
  CGContextClip(context);
  [image drawInRect:imageDrawingRect];
  CGContextRestoreGState(context);

  return CGRectGetMaxX(clippingRect) + rightPadding;
}



@end
