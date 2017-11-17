//
//  BmovilTools.m
//  keychainSwift
//
//  Created by Hector H. De Diego Brito on 2017/02/14.
//  Copyright © 2017 BBVA Bancomer. All rights reserved.
//

#import "BmovilTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BmovilTools

/*
 * Computes the application IUM for the given user and application activation time
 */
+ (NSString*) computeIUMWithUser: (NSString*) aUser andActivationTime: (double) anActivationTime {
  NSString* result = nil;
  
  if (aUser != nil) {
    NSMutableData* iumData = [NSMutableData dataWithBytes: [aUser UTF8String] length: [aUser lengthOfBytesUsingEncoding: NSUTF8StringEncoding]];
    long long activationTime = (long long)anActivationTime;
    [iumData appendBytes: (void*)(&activationTime) length: sizeof(activationTime)];
    NSString* deviceID = @"222222";
    [iumData appendBytes: [deviceID UTF8String] length: [deviceID lengthOfBytesUsingEncoding: NSUTF8StringEncoding]];
    result = [BmovilTools getMD5StringFromData: iumData];
  }
  
  return result;
}

/*
 * Calculates the given data MD5 digest and returns it as an hexadecimal string capitalized
 */
+ (NSString*) getMD5StringFromData: (NSData*) aData {
  NSMutableString* result = [NSMutableString stringWithCapacity: 32];
  
  NSInteger dataLength = [aData length];
  unsigned char data[dataLength];
  [aData getBytes: data length: dataLength];
  unsigned char digest[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5(data, dataLength, digest);
  
  for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
    [result appendFormat: @"%02X", digest[count]];
  }
  
  return result;
}

@end
