//
//  TLNonBlockingCache.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import <Foundation/Foundation.h>
#import "TLNonBlockingCache.h"

@protocol TLNonBlockingCacheDelegate;

/*
 Usage:
 init
 set delegate
 ask for self.data
 it'll either return data, or nil, or the contents returned by defaultDataForCache:
 if useStaleDataInsteadOfReturningNil is true, it'll return cached data even if stale, otherwise, if it is stale, it'll return nil/defaultDataForCache:
 if the data was expired or missing, it'll load the data in a background thread and call cacheDidReceiveFreshData: or cacheDidFailToReceiveFreshData:
*/

@interface TLNonBlockingCache : NSObject {
@private
  NSString *domain;
  NSString *name;
  NSURL *dataSource;
  NSData *data;
  NSError *error;
  NSTimeInterval ttl;
  BOOL useStaleData;
  id<TLNonBlockingCacheDelegate> delegate;
}

- (id)initWithDomain:(NSString *)aDomain // rough category of item, will be used as directory name
                name:(NSString *)aName   // specific item, will be used as filename
          dataSource:(NSURL *)aDataSource
                 ttl:(NSTimeInterval)expiry
        useStaleData:(BOOL)useStaleDataInsteadOfReturningNil
            delegate:(id<TLNonBlockingCacheDelegate>)aDelegate;

+ (void)deleteExpiredFilesInDomain:(NSString *)aDomain usingTtl:(NSTimeInterval)expiry; // returns immediately, deletes on background thread

@property(nonatomic, retain, readonly) NSString *domain;
@property(nonatomic, retain, readonly) NSString *name;
@property(nonatomic, retain, readonly) NSData *data;
@property(nonatomic, retain, readonly) NSError *error;
@property(nonatomic, assign, readwrite) id<TLNonBlockingCacheDelegate> delegate;

@end
