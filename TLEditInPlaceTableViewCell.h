//
//  EditInPlaceTableViewCell.h
//  fourchat
//
//  Created by Joshua Bleecher Snyder on 10/16/09.
//

#import <UIKit/UIKit.h>
#import "TLTableViewCell.h"

// only plays nicely with stylevalue2 cells...

@interface TLEditInPlaceTableViewCell : TLTableViewCell {
@private
  UITextField *textField;
}

@property(nonatomic, retain, readonly) UITextField *textField;

@end
