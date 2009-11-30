//
//  TLTwitterClient.h
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/4/09.
//

#import <Foundation/Foundation.h>

// Supports:
//
// * Tweetie
// * Twitterfon
// * Echofon
// * TwitterfonPro
// * EchofonPro
// * Twitterrific
// * Twittelator
// * Birdfeed
// * Twinkle

@interface TLTwitterClient : NSObject {
@private
  NSString *family;
  NSUInteger familyPriority;
  NSString *displayName;
  NSURL *canOpenURLTestURL;
  NSString *openWithTweetURLFormat;
  NSString *openWithURLURLFormat;
}

+ (NSSet *)allTwitterClients;
+ (NSSet *)availableTwitterClients;

- (void)openWithTweet:(NSString *)aTweet;
- (void)openWithURL:(NSURL *)aURLToTweet; // invokes special url-handling in client (like url shortening), if available

@property(nonatomic, retain, readonly) NSString *displayName;

@end
