//
//  CGContext_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/28/09.
//

#import "CGContext_TLCommon.h"

// from http://www.iphonedevsdk.com/forum/iphone-sdk-development/12339-rounded-corners-images.html
// and any other of numerous places floating around the internet

void CGContextAddRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
  float fw, fh;
  if(ovalWidth == 0 || ovalHeight == 0) {
    CGContextAddRect(context, rect);
    return;
  }
  CGContextSaveGState(context);
  CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM (context, ovalWidth, ovalHeight);
  fw = CGRectGetWidth (rect) / ovalWidth;
  fh = CGRectGetHeight (rect) / ovalHeight;
  CGContextMoveToPoint(context, fw, fh/2);
  CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
  CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
  CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
  CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
  CGContextClosePath(context);
  CGContextRestoreGState(context);
}
