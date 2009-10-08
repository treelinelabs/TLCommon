//
//  TLTableViewCell.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/7/09.
//

#import "TLTableViewCell.h"


#pragma mark -

@interface TLTableViewCell ()

@end


#pragma mark -

@implementation TLTableViewCell

@synthesize cellColor;
@synthesize selectedCellColor;


+ (TLTableViewCell *)tableViewCellWithStyle:(UITableViewCellStyle)style
            dequeuedIfPossibleFromTableView:(UITableView *)tableView {
  return [self tableViewCellWithStyle:style
      dequeuedIfPossibleFromTableView:tableView
                      reuseIdentifier:[self defaultReuseIdentifier]];
}

+ (TLTableViewCell *)tableViewCellWithStyle:(UITableViewCellStyle)style
            dequeuedIfPossibleFromTableView:(UITableView *)tableView
                            reuseIdentifier:(NSString *)reuseIdentifier {
  TLTableViewCell *cell = (TLTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(!cell) {
    cell = [[[TLTableViewCell alloc] initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
  }
  return cell;
}

+ (NSString *)defaultReuseIdentifier {
  return NSStringFromClass(self);
}
          
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  UIColor *color = selected ? self.selectedCellColor : self.cellColor;
  if(color) {
    self.textLabel.backgroundColor = color;
    self.detailTextLabel.backgroundColor = color;
    self.contentView.backgroundColor = color;      
  }
}

- (void)dealloc {
  [cellColor release], cellColor = nil;
  [selectedCellColor release], selectedCellColor = nil;
  [super dealloc];
}


#pragma mark -
#pragma mark Overridden accessors

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
