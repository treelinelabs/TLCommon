//
//  TLDrawnTextBlock.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/26/09.
//

#import "TLDrawnTextBlock.h"
#import "TLDrawnTextFragment.h"
#import "TLDrawnTextStyle.h"
#import "NSString_TLCommon.h"
#import "CGGeometry_TLCommon.h"

#pragma mark -

@interface TLDrawnTextBlock ()

- (CGFloat)maxFontHeightInLine:(NSArray *)line;

@property(nonatomic, retain, readwrite) NSMutableArray *lines;
@property(nonatomic, retain, readwrite) NSMutableDictionary *originalFragmentForNewFragment;
@property(nonatomic, retain, readwrite) NSMutableDictionary *newFragmentsForOriginalFragment;

@end


#pragma mark -

@implementation TLDrawnTextBlock

@synthesize lines;
@synthesize originalFragmentForNewFragment;
@synthesize newFragmentsForOriginalFragment;

- (id)init {
  if(self = [super init]) {
    self.lines = [NSMutableArray array];
    self.originalFragmentForNewFragment = [NSMutableDictionary dictionary];
    self.newFragmentsForOriginalFragment = [NSMutableDictionary dictionary];
  }
  return self;
}


+ (TLDrawnTextBlock *)blockWithFragments:(NSArray *)textFragments width:(CGFloat)lineWidth {
  TLDrawnTextBlock *block = [[[TLDrawnTextBlock alloc] init] autorelease];

  NSMutableArray *currentLine = [NSMutableArray array];
  CGFloat currentLineWidth = lineWidth;  
  for(TLDrawnTextFragment *fragment in textFragments) {
    NSArray *subfragments = [fragment subfragmentsRenderableOnLinesOfWidth:lineWidth firstLineWidth:currentLineWidth];
    for(TLDrawnTextFragment *subfragment in subfragments) {
      if(![subfragment isKindOfClass:[NSNull class]]) {
        [currentLine addObject:currentLine];
//        [block.originalFragmentForNewFragment setObject:fragment forKey:subfragment];
      }
      [block.lines addObject:currentLine];
      currentLine = [NSMutableArray array];
    }
//    [block.newFragmentsForOriginalFragment setObject:subfragments forKey:fragment];
    currentLineWidth = lineWidth - [[subfragments lastObject] width];
  }

  // triming trailing whitespace on all lines
  NSLog(@"lines %@", block.lines);
  for(NSArray *line in block.lines) {
    NSLog(@"line %@", line);
    TLDrawnTextFragment *lastFragment = [line lastObject];
    lastFragment.text = [lastFragment.text stringByTrimmingSuffixCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  
  return block;
}

- (CGFloat)maxFontHeightInLine:(NSArray *)line {
  CGFloat maxFontHeight = 0.0f;
  for(TLDrawnTextFragment *fragment in line) {
    maxFontHeight = MAX(maxFontHeight, [fragment.style.font leading]);
  }
  return maxFontHeight;
}

- (CGFloat)height {
  CGFloat height = 0.0f;
  for(NSArray *line in self.lines) {
    height += [self maxFontHeightInLine:line];
  }
  return height;
}

- (void)renderAtPoint:(CGPoint)point textAlignment:(UITextAlignment)textAlignment {
  CGFloat runningYOffset = 0.0f;
  for(NSArray *line in self.lines) {
    CGFloat maxFontHeight = [self maxFontHeightInLine:line];
    CGFloat runningXOffset = 0.0f;
    for(TLDrawnTextFragment *fragment in line) {
      CGFloat fragmentWidth = [fragment width];
      fragment.renderRect = CGRectMake(point.x + runningXOffset,
                                       point.y + runningYOffset + OffsetToCenterFloatInFloat([fragment.style.font leading], maxFontHeight),
                                       fragmentWidth,
                                       maxFontHeight);
      [fragment render];
      runningXOffset += fragmentWidth;
    }
    runningYOffset += maxFontHeight;
  }
}

- (TLDrawnTextFragment *)fragmentAtPoint:(CGPoint)pointWithinTextBlock {
  return nil;  
}

- (NSArray *)siblingFragmentsForFragment:(TLDrawnTextFragment *)fragment {
  return nil;
}

- (TLDrawnTextFragment *)originalFragmentForFragment:(TLDrawnTextFragment *)fragment {
  return nil;
}


- (void)dealloc {
  [lines release];
  lines = nil;
  
  [originalFragmentForNewFragment release];
  originalFragmentForNewFragment = nil;
  
  [newFragmentsForOriginalFragment release];
  newFragmentsForOriginalFragment = nil;
  
  [super dealloc];
}

@end
