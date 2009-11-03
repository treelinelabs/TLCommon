//
//  TestTLBloomFilter.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/2/09.
//

// Some of these unit tests inspired by Cassandras'
// See http://spyced.blogspot.com/2009/01/all-you-ever-wanted-to-know-about.html
// and http://github.com/jbellis/cassandra-dev/tree/e284df7536ef32869b87d903a5f92f6a96c84801/test/com/facebook/infrastructure/utils#


#import "TestTLBloomFilter.h"
#import "TLBloomFilter.h"
#import "NSData_TLCommon.h"

#pragma mark -

@interface TestTLBloomFilter ()

@property(nonatomic, retain, readwrite) NSSet *testDataSet;

@end

#pragma mark -

@implementation TestTLBloomFilter

@synthesize testDataSet;

- (void)setUp {
  self.testDataSet = [NSSet setWithObjects:
                       [NSData data],
                       [@"a" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"ab" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"1234" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"hi" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"testing" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"more tests" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"kllkads" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"43" dataUsingEncoding:NSASCIIStringEncoding],
                       [@"aa" dataUsingEncoding:NSASCIIStringEncoding],
                       nil];
}

- (void)tearDown {
  self.testDataSet = nil;
}


- (void)testEmptyBloomFilter {
  TLBloomFilter *bloomFilter = [[[TLBloomFilter alloc] initWithLength:10 hashes:5] autorelease];
  for(NSData *data in self.testDataSet) {
    STAssertFalse([bloomFilter containsData:data], @"Found data %@ in empty Bloom filter", [data UTF8String]);
  }
}

- (void)testAddThenCheck {
  TLBloomFilter *bloomFilter = [[[TLBloomFilter alloc] initWithLength:100 hashes:5] autorelease];
  for(NSData *data in self.testDataSet) {
    [bloomFilter addData:data];
  }
  for(NSData *data in self.testDataSet) {
    STAssertTrue([bloomFilter containsData:data], @"Didn't find data %@ in Bloom filter but it was added", [data UTF8String]);
  }
}

- (void)testSavingAndReinitializing {
  TLBloomFilter *bloomFilter = [[[TLBloomFilter alloc] initWithLength:100 hashes:5] autorelease];
  for(NSData *data in self.testDataSet) {
    [bloomFilter addData:data];
  }
  TLBloomFilter *restoredBloomFilter = [[[TLBloomFilter alloc] initWithData:bloomFilter.data hashes:5] autorelease];
  for(NSData *data in self.testDataSet) {
    STAssertTrue([restoredBloomFilter containsData:data], @"Didn't find data %@ in restored Bloom filter but it was added to original", [data UTF8String]);
  }  
}

- (void)testOne {
  TLBloomFilter *bloomFilter = [[[TLBloomFilter alloc] initWithLength:100 hashes:5] autorelease];
  [bloomFilter addData:[@"a" dataUsingEncoding:NSASCIIStringEncoding]];
  STAssertFalse([bloomFilter containsData:[@"b" dataUsingEncoding:NSASCIIStringEncoding]], @"Put in 'a', claims 'b' is present");
}

- (void)testNumberOfHashCalculations {
  // Correct values from http://hur.st/bloomfilter?n=100&p=0.1
  NSUInteger numberOfHashes1 = [TLBloomFilter numberOfHashesToMinimizeFalsePositivesForLength:60 capacity:100];
  STAssertEquals(numberOfHashes1, (NSUInteger)3, @"Wrong number of hashes: %i", numberOfHashes1);
  
  NSUInteger numberOfHashes2 = [TLBloomFilter numberOfHashesToMinimizeFalsePositivesForLength:361 capacity:1000];
  STAssertEquals(numberOfHashes2, (NSUInteger)2, @"Wrong number of hashes: %i", numberOfHashes2);
}

- (void)testLengthForFalsePositiveRate {
  // Correct values from http://hur.st/bloomfilter?n=100&p=0.1
  NSUInteger length1 = [TLBloomFilter lengthToAchieveFalsePositiveRate:0.1f forCapacity:100];
  STAssertEquals(length1, (NSUInteger)60, @"Wrong length: %i", length1);
  
  NSUInteger length2 = [TLBloomFilter lengthToAchieveFalsePositiveRate:0.25f forCapacity:1000];
  STAssertEquals(length2, (NSUInteger)361, @"Wrong length: %i", length2);

  NSUInteger verySmallLength = [TLBloomFilter lengthToAchieveFalsePositiveRate:0.49f forCapacity:1];
  STAssertEquals(verySmallLength, (NSUInteger)1, @"Wrong length: %i", verySmallLength);
}


#if TL_RUN_SLOW_TESTS

- (void)testFalsePositiveRate {
  NSString *allWords = [NSString stringWithContentsOfFile:@"/usr/share/dict/words"
                                                 encoding:NSASCIIStringEncoding
                                                    error:NULL];
  NSArray *wordsExploded = [allWords componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
  NSArray *words = [wordsExploded filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.length > 0"]];
  words = [words subarrayWithRange:NSMakeRange(0, 60000)];
  NSUInteger numberOfWords = [words count];
  NSUInteger numberOfEnteredWords = numberOfWords / 2;
  
  for(float targetFalsePositiveRate = 0.05f; targetFalsePositiveRate < 0.4f; targetFalsePositiveRate += 0.05f) {
    TLBloomFilter *bloomFilter = [[[TLBloomFilter alloc] initWithCapacity:numberOfEnteredWords falsePositiveRate:targetFalsePositiveRate] autorelease];
    
    // add even words; test odd words
    for(NSUInteger i = 0; i < numberOfEnteredWords; i++) {
      NSString *evenWord = [words objectAtIndex:i * 2];
      [bloomFilter addData:[evenWord dataUsingEncoding:NSASCIIStringEncoding]];
    }
    
    NSUInteger falsePositives = 0;
    for(NSUInteger i = 0; i < numberOfEnteredWords; i++) {
      NSString *oddWord = [words objectAtIndex:i * 2 + 1];
      if([bloomFilter containsData:[oddWord dataUsingEncoding:NSASCIIStringEncoding]]) {
        falsePositives++;
      }
    }
    
    float actualFalsePositiveRate = (float)falsePositives / (float)numberOfEnteredWords;
    NSLog(@"afp %f target %f", actualFalsePositiveRate, targetFalsePositiveRate);
    STAssertEqualsWithAccuracy(actualFalsePositiveRate, targetFalsePositiveRate, 0.01f, @"Predicted false positive rate not achieved: %f vs %f", actualFalsePositiveRate, targetFalsePositiveRate);    
  } 
}

#endif


@end
