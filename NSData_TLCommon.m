//
//  NSData_TLCommon.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 9/10/09.
//

#import "NSData_TLCommon.h"
#import <CommonCrypto/CommonDigest.h>

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

#pragma mark -
#pragma mark MD5

- (NSString *)md5 {
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5([self bytes], [self length], result);
  
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

- (NSData *)md5Data {
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5([self bytes], [self length], result);
  return [NSData dataWithBytes:&result length:CC_MD5_DIGEST_LENGTH];
}

#pragma mark -
#pragma mark Base 64 encoding

// Created by khammond on Mon Oct 29 2001.
// Formatted by Timothy Hatcher on Sun Jul 4 2004.
// Copyright (c) 2001 Kyle Hammond. All rights reserved.
// Original development by Dave Winer.

// Pulled from Colloquy's BSD-licensed Chat Core library

static char encodingTable[64] = {
  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
  'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
  'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
  'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

- (NSString *)base64Encoding {
	return [self base64EncodingWithLineLength:0];
}

- (NSString *)base64EncodingWithLineLength:(NSUInteger) lineLength {
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
  
	while( YES ) {
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
    
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
    
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
    
		switch( ctremaining ) {
      case 1:
        ctcopy = 2;
        break;
      case 2:
        ctcopy = 3;
        break;
		}
    
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
    
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
    
		ixtext += 3;
		charsonline += 4;
    
		if( lineLength > 0 ) {
			if( charsonline >= lineLength ) {
				charsonline = 0;
				[result appendString:@"\n"];
			}
		}
	}
  
	return [NSString stringWithString:result];
}


@end
