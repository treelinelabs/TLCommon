//
//  TLBloomFilter.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/2/09.
//

#import <Foundation/Foundation.h>

@interface TLBloomFilter : NSObject {
@private
  NSUInteger length;
  NSUInteger hashes;
  NSMutableData *data;  
}

// bloom filter-related calculations
+ (NSUInteger)numberOfHashesToMinimizeFalsePositivesForLength:(NSUInteger)numberOfBytes capacity:(NSUInteger)numberOfEntries;
+ (NSUInteger)lengthToAchieveFalsePositiveRate:(float)falsePositiveRate forCapacity:(NSUInteger)numberOfEntries;

// initialization
- (id)initWithCapacity:(NSUInteger)numberOfEntries falsePositiveRate:(float)falsePositiveRate; // numberOfEntries MUST be > 0, throws an exception otherwise
- (id)initWithLength:(NSUInteger)numberOfBytes hashes:(NSUInteger)numberOfHashFunctions; // only use if you know what you're doing; length MUST be > 0

// population and querying
- (void)addData:(NSData *)dataRepresentingAnObject;
- (BOOL)containsData:(NSData *)dataRepresentingAnObject;

// for saving and restoring, the ghetto way; todo: properly serialize, etc.
- (id)initWithData:(NSMutableData *)savedBloomFilterData hashes:(NSUInteger)numberOfHashFunctions; // data length MUST be > 0

@property(nonatomic, assign, readonly) NSUInteger length;
@property(nonatomic, assign, readonly) NSUInteger hashes;
@property(nonatomic, retain, readonly) NSMutableData *data;

@end
