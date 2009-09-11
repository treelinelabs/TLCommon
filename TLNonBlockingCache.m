//
//  TLNonBlockingCache.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/8/09.
//

#import "TLNonBlockingCache.h"
#import "TLNonBlockingCacheDelegate.h"
#import "NSFileManager_TLCommon.h"
#import "UIApplication_TLCommon.h"

#define kCacheFolder @"TLNonBlockingCache"

#define kResultDictionaryKeyError @"error"
#define kResultDictionaryKeyData @"dataPath"

#define kDeleteDetailsKeyDomain @"domain"
#define kDeleteDetailsKeyTTL @"ttl"

#pragma mark -

@interface TLNonBlockingCache ()

- (NSString *)dataPath;
+ (NSString *)pathForDomain:(NSString *)aDomain;
+ (NSString *)pathForDomain:(NSString *)aDomain name:(NSString *)aName;
+ (BOOL)fileAtPath:(NSString *)path isExpired:(NSTimeInterval)ttl;
- (void)fetchNewData;
- (void)fetchNewDataBlocking:(NSURL *)dataURL;
- (void)fetchDidCompleteWithResult:(NSDictionary *)result;
+ (void)deleteExpiredFilesBlockingWithDetails:(NSDictionary *)deleteDetails;

@property(nonatomic, assign, readwrite) BOOL cancelled;
@property(nonatomic, retain, readwrite) NSString *domain;
@property(nonatomic, retain, readwrite) NSString *name;
@property(nonatomic, retain, readwrite) NSURL *dataSource;
@property(nonatomic, retain, readwrite) NSData *data;
@property(nonatomic, retain, readwrite) NSError *error;
@property(nonatomic, assign, readwrite) NSTimeInterval ttl;
@property(nonatomic, assign, readwrite) BOOL useStaleData;
@property(nonatomic, assign, readwrite) BOOL loading;

@end


#pragma mark -

@implementation TLNonBlockingCache

@synthesize domain;
@synthesize name;
@synthesize dataSource;
@synthesize data;
@synthesize error;
@synthesize ttl;
@synthesize useStaleData;
@synthesize delegate;
@synthesize cancelled;
@synthesize loading;

+ (void)deleteExpiredFilesInDomain:(NSString *)aDomain usingTtl:(NSTimeInterval)expiry {
  if(!aDomain) {
    return;
  }
  NSNumber *ttl = [NSNumber numberWithDouble:expiry];
  NSDictionary *details = [NSDictionary dictionaryWithObjectsAndKeys:
                           aDomain, kDeleteDetailsKeyDomain,
                           ttl, kDeleteDetailsKeyTTL,
                           nil];
  [self performSelectorInBackground:@selector(deleteExpiredFilesBlockingWithDetails:) withObject:details];
}

+ (void)deleteCachedDataForDomain:(NSString *)aDomain name:(NSString *)aName {
  NSError *error = nil;
  NSString *path = [self pathForDomain:aDomain name:aName];
  [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
  if(error) {
    NSLog(@"Filed to clean up expired file %@, could not delete, error %@: %@",
          path,
          error,
          error.userInfo);
  }
}

+ (void)storeData:(NSData *)data forDomain:(NSString *)aDomain name:(NSString *)aName {
  NSString *path = [self pathForDomain:aDomain name:aName];
  [data writeToFile:path atomically:YES];
}

+ (void)deleteExpiredFilesBlockingWithDetails:(NSDictionary *)deleteDetails {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString *domain = [deleteDetails objectForKey:kDeleteDetailsKeyDomain];
  NSTimeInterval ttl = [[deleteDetails objectForKey:kDeleteDetailsKeyTTL] doubleValue];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *domainPath = [self pathForDomain:domain];
  NSError *error = nil;
  NSArray *namesInDomain = [fileManager contentsOfDirectoryAtPath:domainPath error:&error];
  if(error) {
    // Something went wrong, just log and bail
    NSLog(@"Failed to clean up expired files in %@, could not read directory contents, error %@: %@",
          domainPath,
          error,
          error.userInfo);
  } else {
    // Step through each file, deleting if expired
    for(NSString *name in namesInDomain) {
      NSString *completePath = [domainPath stringByAppendingPathComponent:name];
      if([self fileAtPath:completePath isExpired:ttl]) {
        // Delete!
        [fileManager removeItemAtPath:completePath error:&error];
        if(error) {
          NSLog(@"Filed to clean up expired file %@, could not delete, error %@: %@",
                completePath,
                error,
                error.userInfo);
        }
      }
    }
  }
  [pool release];
}

- (id)initWithDomain:(NSString *)aDomain
                name:(NSString *)aName
          dataSource:(NSURL *)aDataSource
                 ttl:(NSTimeInterval)expiry
        useStaleData:(BOOL)useStaleDataInsteadOfReturningNil
            delegate:(id<TLNonBlockingCacheDelegate>)aDelegate {
  
  if(self = [super init]) {
    self.domain = aDomain;
    self.name = aName;
    self.dataSource = aDataSource;
    self.ttl = expiry;
    self.useStaleData = useStaleDataInsteadOfReturningNil;
    self.delegate = aDelegate;
    NSString *dataPath = [self dataPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:dataPath]) {
      // There's data, is it stale?
      if(![[self class] fileAtPath:dataPath isExpired:self.ttl]) {
        // Not stale, we're done
        self.data = [NSData dataWithContentsOfFile:dataPath];
      } else {
        // Stale; either return nil or the stale data, per preferences,
        // and then start a fetch
        if(self.useStaleData) {
          self.data = [NSData dataWithContentsOfFile:dataPath];
        }
        [self fetchNewData];
      }
    } else {
      // No data at all, start a fetch
      [self fetchNewData];
    }
    
    if(!self.data) {
      // If we have no data, give them their default data back
      if([self.delegate respondsToSelector:@selector(defaultDataForCache:)]) {
        [[self retain] autorelease];
        self.data = [delegate defaultDataForCache:self];
      }
    }
  }
  return self;
}

+ (BOOL)fileAtPath:(NSString *)path isExpired:(NSTimeInterval)expiryTtl {
  NSDate *modificationDate = [[[NSFileManager defaultManager] fileAttributesAtPath:path
                                                                      traverseLink:NO]
                              fileModificationDate];
  return ([modificationDate timeIntervalSinceNow] < -expiryTtl);
}

+ (NSString *)pathForDomain:(NSString *)aDomain {
  NSString *domainPath = [NSFileManager applicationDocumentsDirectory];
  domainPath = [domainPath stringByAppendingPathComponent:kCacheFolder];
  domainPath = [domainPath stringByAppendingPathComponent:aDomain];
  return domainPath;
}

+ (NSString *)pathForDomain:(NSString *)aDomain name:(NSString *)aName {
  NSString *domainPath = [self pathForDomain:aDomain];
  return [domainPath stringByAppendingPathComponent:aName];
}

- (NSString *)dataPath {
  return [[self class] pathForDomain:self.domain name:self.name];
}

- (void)fetchNewData {
  [self retain]; // stay alive until we're done!
  self.loading = YES;
  [[UIApplication sharedApplication] didStartNetworkRequest];
  [self performSelectorInBackground:@selector(fetchNewDataBlocking:) withObject:self.dataSource];
}

- (void)fetchNewDataBlocking:(NSURL *)dataURL {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
  NSURLResponse *response = nil;
  NSError *requestError = nil;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
  
  if([response isKindOfClass:[NSHTTPURLResponse class]]) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if([httpResponse statusCode] / 100 != 2) {
      // not a 2xx response, fail by zeroing out the data, since it is just junk error text
      responseData = nil;
    }
  }
  
  id returnError = nil;
  if(requestError) {
    returnError = requestError;
  } else {
    returnError = [NSNull null];
  }
  
  id returnData = nil;
  if(responseData) {
    returnData = responseData;
  } else {
    returnData = [NSNull null];
  }
  
  NSDictionary *returnValue = [NSDictionary dictionaryWithObjectsAndKeys:
                               returnError, kResultDictionaryKeyError,
                               returnData, kResultDictionaryKeyData,
                               nil];
  
  [self performSelectorOnMainThread:@selector(fetchDidCompleteWithResult:) withObject:returnValue waitUntilDone:NO];
  [pool release];
}

- (void)cancel {
  self.cancelled = YES;
}

- (void)fetchDidCompleteWithResult:(NSDictionary *)result {
  [[UIApplication sharedApplication] didStopNetworkRequest];
  self.loading = NO;
  if(self.cancelled) {
    return;
  }
  
  id errorField = [result objectForKey:kResultDictionaryKeyError];
  self.error = (errorField == [NSNull null]) ? nil : (NSError *)errorField;
  
  id dataField = [result objectForKey:kResultDictionaryKeyData];
  self.data = (dataField == [NSNull null]) ? nil : dataField;
  
  if(self.error || !self.data) {
    // Report error
    if([self.delegate respondsToSelector:@selector(cacheDidFailToReceiveFreshData:)]) {
      [self.delegate cacheDidFailToReceiveFreshData:self];
    }
  } else {
    // Save new data and report success
    // Make sure the directory exists
    [[NSFileManager defaultManager] createDirectoryAtPath:[[self class] pathForDomain:self.domain]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    // Write the data
    [self.data writeToFile:[self dataPath] atomically:YES];
    if([self.delegate respondsToSelector:@selector(cacheDidReceiveFreshData:)]) {
      [self.delegate cacheDidReceiveFreshData:self];
    }
  }
  [self release]; // matches retain in fetchNewData
}

- (void)dealloc {
  [domain release];
  domain = nil;
  
  [name release];
  name = nil;
  
  [dataSource release];
  dataSource = nil;
  
  [data release];
  data = nil;
  
  delegate = nil;
  
  [super dealloc];
}

@end
