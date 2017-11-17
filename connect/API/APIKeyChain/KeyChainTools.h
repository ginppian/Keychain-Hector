//
//  KeyChainTools.h
//  APIKeyChain
//
//  Created by Mike on 15/06/15.
//  Copyright (c) 2015 CGI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainTools : NSObject

+ (NSMutableDictionary *)parsearDiccionarioKeyChain:(NSString *)datosKeyChain;
+ (NSString *)diccionarioKeyChainToString:(NSDictionary *)diccionarioKeyChain;

@end
