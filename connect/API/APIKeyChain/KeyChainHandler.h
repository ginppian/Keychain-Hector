//
//  KeyChainHandler.h
//  Bancomer
//
//  Created by Mike on 08/06/15.
//  Copyright (c) 2015 GoNet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyChainItemWrapper.h"

#define KEYCHAIN_STORENAME                      @"BConnectKeyChain"
#define KEYCHAIN_DATA_KEY                       @"acct"
#define KEYCHAIN_SEED_KEY                       @"seed"
#define KEYCHAIN_ACTIVATION_TIME_KEY            @"activationTime"
#define KEYCHAIN_TELEPHONE_KEY                  @"numCel"
#define KEYCHAIN_CENTER_KEY                     @"centro"
#define KEYCHAIN_CONTRATACION_BT_KEY            @"contratacionBT"
#define KEYCHAIN_ACTIVA_TOKEN_KEY               @"activaToken"
#define KEYCHAIN_OTP_KEY                        @"otp"
//Apps Verticales
#define KEYCHAIN_URLSCHEME_KEY                  @"URLScheme"
#define KEYCHAIN_STRING_ST_KEY                  @"StringST"
#define TIPO_SOLICITUD                          @"tipoSolicitud"
#define TIPO_TOKEN                              @"tipoToken"

@interface KeyChainHandler : NSObject  {
    @private KeychainItemWrapper *keychainItemWrapper;
}

@property (nonatomic, strong) NSString * anAccessGroup;

//Apps verticales
+ (KeyChainHandler*) getInstance;
+ (KeyChainHandler*) getInstanceWithAccessGroup: (NSString *) accessGroup;
+ (void) deleteInstance;

- (NSString *) anAccessGroup;
- (void)inicializarKeyChain;
- (NSString *)leerDeKeyChain:(NSString *)clave;
- (void)guardarEnKeyChain:(NSString *)valor clave:(NSString *)clave;
- (void)borrarDeKeyChain:(NSString *)clave;
- (void)borrarKeyChain;
//Metodo keychain para cronto
-(void)guardarDataEnKeychain:(NSData *)data clave:(NSString *)key;
-(NSData*)leerDataDeKeychain:(NSString*)key;
-(NSString *)getKeychainGroup;

@end
