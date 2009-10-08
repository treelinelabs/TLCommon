//
//  TLTableViewCell.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 10/7/09.
//

#import <UIKit/UIKit.h>


@interface TLTableViewCell : UITableViewCell {
@private
  UIColor *cellColor;
  UIColor *selectedCellColor;
}

+ (TLTableViewCell *)tableViewCellWithStyle:(UITableViewCellStyle)style
            dequeuedIfPossibleFromTableView:(UITableView *)tableView;
+ (TLTableViewCell *)tableViewCellWithStyle:(UITableViewCellStyle)style
            dequeuedIfPossibleFromTableView:(UITableView *)tableView
                            reuseIdentifier:(NSString *)reuseIdentifier;
+ (NSString *)defaultReuseIdentifier;

@property(nonatomic, retain, readwrite) UIColor *cellColor;
@property(nonatomic, retain, readwrite) UIColor *selectedCellColor;

@end
