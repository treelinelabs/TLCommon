//
//  EditInPlaceTableViewCell.m
//  fourchat
//
//  Created by Joshua Bleecher Snyder on 10/16/09.
//

#import "TLEditInPlaceTableViewCell.h"
#import "UITableViewCell_TLCommon.h"
#import "CGGeometry_TLCommon.h"

#pragma mark -

@interface TLEditInPlaceTableViewCell ()

@property(nonatomic, retain, readwrite) UITextField *textField;

@end


#pragma mark -

@implementation TLEditInPlaceTableViewCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    if(!self.textField) {
      self.detailTextLabel.text = @"\n";
      self.detailTextLabel.hidden = YES;
      self.textField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
      self.textField.font = [UITableViewCell defaultDetailTextLabelFontForCellStyle:style];
      self.textField.textColor = [UITableViewCell defaultDetailTextLabelColorForCellStyle:style];
      [self.contentView addSubview:self.textField];
    }
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  [self layoutSubviews];
  self.textField.frame = self.detailTextLabel.frame;
}

- (void)dealloc {
  [textField release];
  textField = nil;
  
  [super dealloc];
}

@end
