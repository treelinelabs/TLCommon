//
//  CGGeometry_TLCommon.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 8/31/09.
//

#import <Foundation/Foundation.h>

static inline CGRect CGRectZeroWithSize(CGSize size) {
  return CGRectMake(0.0f, 0.0f, size.width, size.height);
}

static inline CGRect CGRectZeroWithWidthAndHeight(CGFloat width, CGFloat height) {
  return CGRectMake(0.0f, 0.0f, width, height);
}

static inline CGRect CGRectWithOriginAndSize(CGPoint origin, CGSize size) {
  return CGRectMake(origin.x, origin.y, size.width, size.height);
}

static inline CGRect CGRectWithXYAndSize(CGFloat xOrigin, CGFloat yOrigin, CGSize size) {
  return CGRectMake(xOrigin, yOrigin, size.width, size.height);
}

static inline CGRect CGRectWithCenterAndSize(CGPoint center, CGSize size) {
  return CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
}

static inline CGSize CGSizeMakeSquare(CGFloat widthAndHeight) {
  return CGSizeMake(widthAndHeight, widthAndHeight);
}
