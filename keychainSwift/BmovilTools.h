//
//  BmovilTools.h
//  keychainSwift
//
//  Created by Hector H. De Diego Brito on 2017/02/14.
//  Copyright © 2017 BBVA Bancomer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BmovilTools : NSObject

+ (NSString*) computeIUMWithUser: (NSString*) aUser andActivationTime: (double) anActivationTime;

@end
