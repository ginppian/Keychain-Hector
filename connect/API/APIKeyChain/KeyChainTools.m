//
//  KeyChainTools.m
//  APIKeyChain
//
//  Created by Mike on 15/06/15.
//  Copyright (c) 2015 CGI. All rights reserved.
//

#import "KeyChainTools.h"

@implementation KeyChainTools

+ (NSMutableDictionary *)parsearDiccionarioKeyChain:(NSString *)datosKeyChain {
    
    NSMutableDictionary *params;
    if ((datosKeyChain != nil) && (![datosKeyChain isEqualToString:@""])) {
        params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [datosKeyChain componentsSeparatedByString:@"&"]) {
            if ((param !=nil) && (![param isEqualToString:@""])) {
                NSRange range = [param rangeOfString:@"="];
                NSString *el0 = [param substringToIndex:range.location];
                NSString *el1 = [param substringFromIndex:range.location+1];
                [params setObject:el1 forKey:el0];
            }
        }
    } else {
        params = nil;
    }
    
    return params;
}

+ (NSString *)diccionarioKeyChainToString:(NSDictionary *)diccionarioKeyChain {
    NSString *stringKeyChain = @"";
    
    for (NSString *akey in [diccionarioKeyChain allKeys]) {
        NSString *param = [NSString stringWithFormat:@"%@=%@", akey, [diccionarioKeyChain objectForKey:akey]];
        stringKeyChain = [stringKeyChain stringByAppendingString:param];
        stringKeyChain = [stringKeyChain stringByAppendingString:@"&"];
    }
    
    if (![stringKeyChain isEqualToString:@""]) {
        stringKeyChain = [stringKeyChain substringToIndex:stringKeyChain.length-1];
    }
    
    return stringKeyChain;
}

@end
