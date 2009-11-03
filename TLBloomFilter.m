//
//  TLBloomFilter.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/2/09.
//

#import "TLBloomFilter.h"
#import "NSData_TLCommon.h"
#import "TLMacros.h"
#import <math.h>

#pragma mark -

@interface TLBloomFilter ()

@property(nonatomic, assign, readwrite) NSUInteger length;
@property(nonatomic, assign, readwrite) NSUInteger hashes;
@property(nonatomic, retain, readwrite) NSMutableData *data;

@end


#pragma mark -

@implementation TLBloomFilter

@synthesize length;
@synthesize hashes;
@synthesize data;

// http://en.wikipedia.org/wiki/Bloom_filter
+ (NSUInteger)numberOfHashesToMinimizeFalsePositivesForLength:(NSUInteger)numberOfBytes capacity:(NSUInteger)numberOfEntries {
  const double ln2 = 0.693147181f; //log(2.0f);
  float numberOfBits = numberOfBytes * CHAR_BIT;
  NSUInteger numberOfHashes = round(ln2 * numberOfBits / (float)numberOfEntries);
  return numberOfHashes;
}

// http://en.wikipedia.org/wiki/Bloom_filter
+ (NSUInteger)lengthToAchieveFalsePositiveRate:(float)falsePositiveRate forCapacity:(NSUInteger)numberOfEntries {
  const double minusOneOverLn2Squared = -2.08136898f; //-1.0f / ( log(2.0f) * log(2.0f) );
  double numberOfBits = minusOneOverLn2Squared * numberOfEntries * log(falsePositiveRate);
  NSUInteger length = ceil(numberOfBits / (float)CHAR_BIT);
  return length;
}

- (id)initWithCapacity:(NSUInteger)numberOfEntries falsePositiveRate:(float)falsePositiveRate {
  NSAssert(numberOfEntries > 0, @"TLBloomFilter initWithCapacity:falsePositiveRate: called with numberOfEntries == 0");
  if(self = [super init]) {
    self.length = [[self class] lengthToAchieveFalsePositiveRate:falsePositiveRate forCapacity:numberOfEntries];
    self.hashes = [[self class] numberOfHashesToMinimizeFalsePositivesForLength:self.length capacity:numberOfEntries];
    self.data = [NSMutableData dataWithLength:self.length];
  }
  return self;
}

- (id)initWithLength:(NSUInteger)numberOfBytes hashes:(NSUInteger)numberOfHashFunctions {
  NSAssert(numberOfBytes > 0, @"TLBloomFilter initWithLength:hashes: called with numberOfBytes == 0");
  if(self = [super init]) {
    self.length = numberOfBytes;
    self.hashes = numberOfHashFunctions;
    self.data = [NSMutableData dataWithLength:self.length];
  }
  return self;
}

- (id)initWithData:(NSMutableData *)savedBloomFilterData hashes:(NSUInteger)numberOfHashFunctions {
  NSAssert([savedBloomFilterData length] > 0, @"TLBloomFilter initWithData:hashes: called with savedBloomFilterData with length 0");
  if(self = [super init]) {
    self.length = [savedBloomFilterData length];
    self.hashes = numberOfHashFunctions;
    self.data = savedBloomFilterData;
  }
  return self;  
}

// This actually does the bit-wise Bloom filter calculations.
// If insertData is YES, then it inserts the provided data
// and returns YES (since it is now present in the filter).
// If insertData is NO, it returns whether the provided data
// was already in the Bloom filter.
- (BOOL)containsData:(NSData *)dataRepresentingAnObject performInsert:(BOOL)insertData {
  BOOL containsTheData = YES;
  unsigned char *bytes = (unsigned char *)[self.data bytes];
  unsigned int firstHash = [dataRepresentingAnObject murmurHashNeutral2WithSeed:0x1234ABCD]; // seeds picked at random
  unsigned int secondHash = [dataRepresentingAnObject murmurHashNeutral2WithSeed:0x0A5A3F707];
  for(NSUInteger hashCount = 0; hashCount < self.hashes; hashCount++) {
    unsigned int hash = firstHash + hashCount * secondHash; // note that we don't care about overflow, as long as it happens consistently
    unsigned int bitOffset = hash % (self.length * CHAR_BIT);
    unsigned int bytesOffset = bitOffset / CHAR_BIT;
    unsigned short int intraByteOffset = bitOffset % CHAR_BIT;
    unsigned short int byteMask = 1 << intraByteOffset;
    if(insertData) {
      bytes[bytesOffset] |= byteMask;      
    } else {
      if(!(bytes[bytesOffset] & byteMask)) {
        containsTheData = NO;
        break;
      }
    }
  }
  return containsTheData;
}

- (void)addData:(NSData *)dataRepresentingAnObject {
  [self containsData:dataRepresentingAnObject performInsert:YES];
}                            

- (BOOL)containsData:(NSData *)dataRepresentingAnObject {
  return [self containsData:dataRepresentingAnObject performInsert:NO];
}

- (void)dealloc {
  [data release];
  data = nil;
  
  [super dealloc];
}

@end
