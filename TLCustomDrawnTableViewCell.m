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
  [super dealloc];
}

@end
