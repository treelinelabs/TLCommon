//
//  TLTwitterClient.m
//  TLCommon
//
//  Created by Joshua Bleecher Snyder on 11/4/09.
//

#import "TLTwitterClient.h"
#import "NSString_TLCommon.h"

#define kTweetieFamily @"tweetie"
#define kTwitterfonFamily @"twitterfon"
#define kTwitterfonProFamily @"twitterfonpro"
#define kTwitterrificFamily @"twitterrific"
#define kTwittelatorFamily @"twittelator"
#define kBirdfeedFamily @"birdfeed"
#define kTwinkleFamily @"twinkle"

#pragma mark -

@interface TLTwitterClient ()

+ (TLTwitterClient *)twitterClientWithFamily:(NSString *)family
                              familyPriority:(NSUInteger)priority
                                     displayName:(NSString *)name
                                canOpenURLTestURL:(NSURL *)testURL
                           openWithTweetURLFormat:(NSString *)tweetFormat
                            openWithURLURLFormat:(NSString *)urlFormat;

- (void)openURLWithFormat:(NSString *)format string:(NSString *)aString;

@property(nonatomic, retain, readwrite) NSString *family;
@property(nonatomic, assign, readwrite) NSUInteger familyPriority;
@property(nonatomic, retain, readwrite) NSString *displayName;
@property(nonatomic, retain, readwrite) NSURL *canOpenURLTestURL;
@property(nonatomic, retain, readwrite) NSString *openWithTweetURLFormat;
@property(nonatomic, retain, readwrite) NSString *openWithURLURLFormat;

@end


#pragma mark -

@implementation TLTwitterClient

@synthesize family;
@synthesize familyPriority;
@synthesize displayName;
@synthesize canOpenURLTestURL;
@synthesize openWithTweetURLFormat;
@synthesize openWithURLURLFormat;

+ (TLTwitterClient *)twitterClientWithFamily:(NSString *)family
                              familyPriority:(NSUInteger)priority
                                 displayName:(NSString *)name
                           canOpenURLTestURL:(NSURL *)testURL
                      openWithTweetURLFormat:(NSString *)tweetFormat
                        openWithURLURLFormat:(NSString *)urlFormat {
  TLTwitterClient *client = [[[self alloc] init] autorelease];
  client.family = family;
  client.familyPriority = priority;
  client.displayName = name;
  client.canOpenURLTestURL = testURL;
  client.openWithTweetURLFormat = tweetFormat;
  client.openWithURLURLFormat = urlFormat;
  return client;
}

+ (NSSet *)allTwitterClients {
  NSSet *allTwitterClients = [NSSet setWithObjects:
                              // tweetie
                              [self twitterClientWithFamily:kTweetieFamily
                                             familyPriority:1
                                                displayName:@"Tweetie"
                                          canOpenURLTestURL:[NSURL URLWithString:@"tweetie:///post?message=test"]
                                     openWithTweetURLFormat:@"tweetie:///post?message=%@"
                                       openWithURLURLFormat:nil],
                              // twitterfon
                              [self twitterClientWithFamily:kTwitterfonFamily
                                             familyPriority:1
                                                displayName:@"Twitterfon"
                                          canOpenURLTestURL:[NSURL URLWithString:@"twitterfon:///message?test"]
                                     openWithTweetURLFormat:@"twitterfon:///message?%@"
                                       openWithURLURLFormat:@"twitterfon:///post?%@"],
                              // twitterfon pro
                              [self twitterClientWithFamily:kTwitterfonProFamily
                                             familyPriority:1
                                                displayName:@"Twitterfon Pro"
                                          canOpenURLTestURL:[NSURL URLWithString:@"twitterfonpro:///message?test"]
                                     openWithTweetURLFormat:@"twitterfonpro:///message?%@"
                                       openWithURLURLFormat:@"twitterfonpro:///post?%@"],
                              // echofon
                              [self twitterClientWithFamily:kTwitterfonFamily
                                             familyPriority:2
                                                displayName:@"Echofon"
                                          canOpenURLTestURL:[NSURL URLWithString:@"echofon:///message?test"]
                                     openWithTweetURLFormat:@"echofon:///message?%@"
                                       openWithURLURLFormat:@"echofon:///post?%@"],
                              // echofon pro
                              [self twitterClientWithFamily:kTwitterfonProFamily
                                             familyPriority:2
                                                displayName:@"Echofon Pro"
                                          canOpenURLTestURL:[NSURL URLWithString:@"echofonpro:///message?test"]
                                     openWithTweetURLFormat:@"echofonpro:///message?%@"
                                       openWithURLURLFormat:@"echofonpro:///post?%@"],
                              // twitterrific
                              [self twitterClientWithFamily:kTwitterrificFamily
                                             familyPriority:1
                                                displayName:@"Twitterrific"
                                          canOpenURLTestURL:[NSURL URLWithString:@"twitterrific:///post?message=test"]
                                     openWithTweetURLFormat:@"twitterrific:///post?message=%@"
                                       openWithURLURLFormat:nil],
                              // twitterrific
                              [self twitterClientWithFamily:kTwittelatorFamily
                                             familyPriority:1
                                                displayName:@"Twittelator"
                                          canOpenURLTestURL:[NSURL URLWithString:@"twit:///post?message=test"]
                                     openWithTweetURLFormat:@"twit:///post?message=%@"
                                       openWithURLURLFormat:nil],
                              // birdfeed
                              [self twitterClientWithFamily:kBirdfeedFamily
                                             familyPriority:1
                                                displayName:@"Birdfeed"
                                          canOpenURLTestURL:[NSURL URLWithString:@"x-birdfeed://post?text=test"]
                                     openWithTweetURLFormat:@"x-birdfeed://post?text=%@"
                                       openWithURLURLFormat:@"x-birdfeed://post?url=%@"],
                              // twinkle
                              [self twitterClientWithFamily:kTwinkleFamily
                                             familyPriority:1
                                                displayName:@"Twinkle"
                                          canOpenURLTestURL:[NSURL URLWithString:@"twinkle://message=test"]
                                     openWithTweetURLFormat:@"twinkle://message=%@"
                                       openWithURLURLFormat:@"twinkle://url=%@"],
                              nil];
  return allTwitterClients;
}

+ (NSSet *)availableTwitterClients {
  NSSet *allTwitterClients = [self allTwitterClients];
  NSMutableDictionary *preferredTwitterClientByFamily = [NSMutableDictionary dictionaryWithCapacity:[allTwitterClients count]];
  UIApplication *application = [UIApplication sharedApplication];
  // pick out the top priority client w/in each family that is launchable
  for(TLTwitterClient *client in allTwitterClients) {
    // check whether the client is launchable
    if(![application canOpenURL:client.canOpenURLTestURL]) {
      continue;
    }

    // the client is launchable -- add it iff it is better than the current competition for its family
    TLTwitterClient *currentBestClientInFamily = [preferredTwitterClientByFamily objectForKey:client.family];
    if(!currentBestClientInFamily || client.familyPriority > currentBestClientInFamily.familyPriority) {
      [preferredTwitterClientByFamily setObject:client forKey:client.family];
    }
  }
  
  NSArray *arrayOfClients = [preferredTwitterClientByFamily allValues];
  NSSet *availableTwitterClients = [NSSet setWithArray:arrayOfClients];

  return availableTwitterClients;
}

- (void)openURLWithFormat:(NSString *)format string:(NSString *)aString {
  NSString *encodedString = [aString stringByURLEncodingAllCharacters];
  NSString *URLToOpen = [NSString stringWithFormat:format, encodedString];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLToOpen]];
}

- (void)openWithTweet:(NSString *)aTweet {
  [self openURLWithFormat:self.openWithTweetURLFormat string:aTweet];
}

- (void)openWithURL:(NSURL *)aURLToTweet {
  NSString *format = self.openWithURLURLFormat;
  if(!format) {
    format = self.openWithTweetURLFormat;
  }
  NSString *stringForURL = [aURLToTweet absoluteString];
  [self openURLWithFormat:format string:stringForURL];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p: %@>",
          NSStringFromClass([self class]),
          self,
          self.displayName];
}

- (void)dealloc {
  [family release];
  family = nil;
  
  [displayName release];
  displayName = nil;
  
  [canOpenURLTestURL release];
  canOpenURLTestURL = nil;
  
  [openWithTweetURLFormat release];
  openWithTweetURLFormat = nil;

  [openWithURLURLFormat release];
  openWithURLURLFormat = nil;
  
  [super dealloc];
}

@end
