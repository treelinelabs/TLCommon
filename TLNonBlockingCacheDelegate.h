//
//  TLNonBlockingCacheDelegate.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

@class TLNonBlockingCache;

@protocol TLNonBlockingCacheDelegate<NSObject>

@optional

- (NSData *)defaultDataForCache:(TLNonBlockingCache *)cache; // implement if you want to provide data if there's none cached
- (void)cacheDidReceiveFreshData:(TLNonBlockingCache *)cache;
- (void)cacheDidFailToReceiveFreshData:(TLNonBlockingCache *)cache; // something went wrong while fetching fresh data
- (BOOL)cache:(TLNonBlockingCache *)cache shouldStoreData:(NSData *)data; // an opportunity to validate the data before storing it

@end
