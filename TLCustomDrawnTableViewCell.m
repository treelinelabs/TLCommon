//
//  TLCustomDrawnTableViewCell.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "TLCustomDrawnTableViewCell.h"
#import "CGGeometry_TLCommon.h"

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
@synthesize cellColor;
@synthesize selectedCellColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier keyPathsRequiringRedisplay:(NSSet *)redisplayRequiringKeyPathsOrNil {
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGRect customViewFrame = CGRectZeroWithSize(self.contentView.bounds.size);
    customView = [[[TLCustomDrawnTableViewCellCustomView alloc] initWithFrame:customViewFrame] autorelease];
    ((TLCustomDrawnTableViewCellCustomView *)customView).parentCell = self;
    [self.contentView addSubview:customView];
    keyPathsRequiringRedisplay = [redisplayRequiringKeyPathsOrNil retain];
    for(NSString *keyPath in keyPathsRequiringRedisplay) {
      [self addObserver:self forKeyPath:keyPath options:0 context:NULL];   
    }
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if((self == object) && [keyPathsRequiringRedisplay containsObject:keyPath]) {
    [customView setNeedsDisplay];
  }
}

- (void)didTransitionToState:(UITableViewCellStateMask)state {
  [super didTransitionToState:state];
  [customView setNeedsDisplay];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
  [super willTransitionToState:state];
  [customView setNeedsDisplay];
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[customView setNeedsDisplay];
}

- (void)drawContentsInRect:(CGRect)rect {
  // subclasses override this  
}

- (void)dealloc {
  for(NSString *keyPath in keyPathsRequiringRedisplay) {
    [self removeObserver:self forKeyPath:keyPath];
  }
  [keyPathsRequiringRedisplay release], keyPathsRequiringRedisplay = nil;
  [cellColor release], cellColor = nil;
  [selectedCellColor release], selectedCellColor = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark Overridden setters

- (void)setCellColor:(UIColor *)newCellColor {
  if(!self.backgroundView) {
    self.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
  }
  if(!newCellColor) {
    self.backgroundView = nil;
  }
  [newCellColor retain];
  [cellColor release];
  cellColor = newCellColor;
  self.backgroundView.backgroundColor = cellColor;
  [self setNeedsDisplay];
}


- (void)setSelectedCellColor:(UIColor *)newSelectedCellColor {
  if(!self.selectedBackgroundView) {
    self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];    
  }
  if(!newSelectedCellColor) {
    self.selectedBackgroundView = nil;
  }
  [newSelectedCellColor retain];
  [selectedCellColor release];
  selectedCellColor = newSelectedCellColor;
  self.selectedBackgroundView.backgroundColor = selectedCellColor;
  [self setNeedsDisplay];
}

@end
