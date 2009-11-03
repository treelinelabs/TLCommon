//
//  NSData_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import "NSData_TLCommon.h"

@implementation NSData (TLCommon)

- (NSString *)UTF8String {
  return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}

// Adapted from MurmurHashNeutral2 by Austin Appleby
// details at http://murmurhash.googlepages.com/
// "Same as MurmurHash2, but endian- and alignment-neutral.
// Half the speed though, alas."
- (unsigned int)murmurHashNeutral2WithSeed:(unsigned int)seed {
  int len = [self length];
  
	const unsigned int m = 0x5bd1e995;
	const int r = 24;
  
	unsigned int h = seed ^ len;
  
	const unsigned char * data = (const unsigned char *)[self bytes];
  
	while(len >= 4)
	{
		unsigned int k;
    
		k  = data[0];
		k |= data[1] << 8;
		k |= data[2] << 16;
		k |= data[3] << 24;
    
		k *= m; 
		k ^= k >> r; 
		k *= m;
    
		h *= m;
		h ^= k;
    
		data += 4;
		len -= 4;
	}
	
	switch(len)
	{
    case 3: h ^= data[2] << 16;
    case 2: h ^= data[1] << 8;
    case 1: h ^= data[0];
      h *= m;
	};
  
	h ^= h >> 13;
	h *= m;
	h ^= h >> 15;
  
	return h;
}

@end
