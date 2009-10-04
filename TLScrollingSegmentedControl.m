//
//  TLScrollingSegmentedControl.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "TLScrollingSegmentedControl.h"
#import "TLScrollingSegmentedControlDelegate.h"
#import "CGGeometry_TLCommon.h"

#define kFogWidth 25.0f
#define kRecommendedHeight 30.0f
#define kDefaultFogColor [UIColor colorWithWhite:0.1f alpha:0.8f]
#define ClampToUnit(f) MAX(0.0f, MIN(1.0f, f))

#pragma mark -

@interface TLScrollingSegmentedControl ()

- (void)updateFog;
- (void)segmentedControlValueChanged:(UISegmentedControl *)control;
- (void)setFogColor:(UIColor *)newFogColor;

@property(nonatomic, retain, readwrite) UIScrollView *scrollView;
@property(nonatomic, retain, readwrite) UISegmentedControl *segmentedControl;
@property(nonatomic, retain, readwrite) NSArray *segmentTitles;
@property(nonatomic, retain, readwrite) CAGradientLayer *leftFog;
@property(nonatomic, retain, readwrite) CAGradientLayer *rightFog;

@end


#pragma mark -

@implementation TLScrollingSegmentedControl

@synthesize scrollView;
@synthesize segmentedControl;
@synthesize segmentTitles;
@synthesize delegate;
@synthesize leftFog;
@synthesize rightFog;

+ (CGFloat)recommendedHeight {
  return kRecommendedHeight;
}

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
  if(self = [super initWithFrame:frame]) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor blackColor];
    self.opaque = YES;
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectZeroWithSize(frame.size)] autorelease];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.canCancelContentTouches = YES;
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.delegate = self;
    
    [self addSubview:self.scrollView];
    
    self.segmentTitles = titles;
    
    self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:self.segmentTitles] autorelease];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.frame = CGRectZeroWithWidthAndHeight(self.segmentedControl.frame.size.width, frame.size.height);
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    self.scrollView.contentSize = self.segmentedControl.bounds.size;
    
    [self.scrollView addSubview:self.segmentedControl];
    
    self.leftFog = [CAGradientLayer layer];
    self.leftFog.bounds = CGRectZeroWithWidthAndHeight(kFogWidth,
                                                       self.bounds.size.height);
    self.leftFog.position = CGPointMake(kFogWidth / 2.0f,
                                        self.bounds.size.height / 2.0f); // position == center! 
    self.leftFog.startPoint = CGPointMake(0.0f, 0.5f); // left middle
    self.leftFog.endPoint = CGPointMake(1.0f, 0.5f); // right middle
    self.leftFog.locations = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0f],
                              [NSNumber numberWithFloat:1.0f],
                              nil];
    [self.layer addSublayer:self.leftFog];
    
    self.rightFog = [CAGradientLayer layer];
    self.rightFog.bounds = CGRectZeroWithWidthAndHeight(kFogWidth,
                                                        self.bounds.size.height);
    self.rightFog.position = CGPointMake(self.bounds.size.width - kFogWidth / 2.0f,
                                         self.bounds.size.height / 2.0f); // position == center! 
    self.rightFog.startPoint = CGPointMake(1.0f, 0.5f); // left middle
    self.rightFog.endPoint = CGPointMake(0.0f, 0.5f); // right middle
    self.rightFog.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    [self.layer addSublayer:self.rightFog];
    
    [self setFogColor:kDefaultFogColor];
    [self updateFog];
  }
  return self;
}

- (void)setFogColor:(UIColor *)newFogColor {
  self.leftFog.colors = [NSArray arrayWithObjects:
                         (id)newFogColor.CGColor,
                         (id)[UIColor clearColor].CGColor,
                         nil];  
  self.rightFog.colors = [NSArray arrayWithObjects:
                          (id)newFogColor.CGColor,
                          (id)[UIColor clearColor].CGColor,
                          nil];  
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)control {
  if([delegate respondsToSelector:@selector(scrollingSegmentedControl:didSelectTitle:)]) {
    NSString *selectedTitle = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    [[self retain] autorelease];
    [delegate scrollingSegmentedControl:self didSelectTitle:selectedTitle];
  }
}

- (void)setTintColor:(UIColor *)tintColor {
  self.segmentedControl.tintColor = tintColor;  
}

- (BOOL)setSelectedTitle:(NSString *)title animated:(BOOL)animated {
  NSInteger titleIndex = [self.segmentTitles indexOfObject:title];
  BOOL titleIndexFound = (titleIndex != NSNotFound);
  if(titleIndexFound) {
    self.segmentedControl.selectedSegmentIndex = titleIndex;
    
    UISegmentedControl *sizer = [[[UISegmentedControl alloc] initWithItems:[self.segmentTitles subarrayWithRange:NSMakeRange(0, titleIndex)]]
                                 autorelease];
    sizer.segmentedControlStyle = UISegmentedControlStyleBar;
    CGFloat desiredTitleOffset = sizer.bounds.size.width - self.scrollView.bounds.size.width / 2.0f;
    
    CGFloat maximumContentOffset = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    CGFloat scrollToOffset = MAX(0.0f, MIN(maximumContentOffset, desiredTitleOffset));
    
    [self.scrollView setContentOffset:CGPointMake(scrollToOffset, 0)
                             animated:animated];
  } 
  return titleIndexFound;
}

- (NSString *)selectedTitle {
  return [self.segmentTitles objectAtIndex:self.segmentedControl.selectedSegmentIndex];
}

- (void)dealloc {
  delegate = nil;
  
  [segmentedControl removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
  [segmentedControl release];
  segmentedControl = nil;
  
  scrollView.delegate = nil;
  [scrollView release];
  scrollView = nil;
  
  [segmentTitles release];
  segmentTitles = nil;
  
  [leftFog release];
  leftFog = nil;
  
  [rightFog release];
  rightFog = nil;
  
  [super dealloc];
}

- (void)updateFog {
  CGFloat leftEdgeDistance = self.scrollView.contentOffset.x;
  CGFloat rightEdgeDistance = self.scrollView.contentSize.width - self.scrollView.contentOffset.x - self.scrollView.bounds.size.width;
  CGFloat leftPercentFogDistance = ClampToUnit(1.0f - leftEdgeDistance / kFogWidth);
  CGFloat rightPercentFogDistance = ClampToUnit(1.0f - rightEdgeDistance / kFogWidth);
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  self.leftFog.position = CGPointMake(kFogWidth / 2.0f - leftPercentFogDistance * kFogWidth,
                                      self.bounds.size.height / 2.0f);
  self.rightFog.position = CGPointMake(self.bounds.size.width - kFogWidth / 2.0f + rightPercentFogDistance * kFogWidth,
                                       self.bounds.size.height / 2.0f);
  [CATransaction commit];   
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
  [self updateFog];
}

@end
