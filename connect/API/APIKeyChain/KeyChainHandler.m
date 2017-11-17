//
//  KeyChainHandler.m
//  Bancomer
//
//  Created by Mike on 08/06/15.
//  Copyright (c) 2015 GoNet. All rights reserved.
//

#import "KeyChainHandler.h"
#import "KeyChainTools.h"

@implementation KeyChainHandler

static KeyChainHandler * sharedInstance = nil;
static NSString * anAccessGroup = nil;

+ (KeyChainHandler*) getInstance {
  if( !sharedInstance ) {
    anAccessGroup = nil;
    sharedInstance = [[self alloc] init];
  }
  
  
  return sharedInstance;
}


+ (KeyChainHandler*) getInstanceWithAccessGroup: (NSString *) accessGroup {
  if( !sharedInstance ) {
    anAccessGroup = accessGroup;
    sharedInstance = [[self alloc] init];
  }
  
  return sharedInstance;
}

- (NSString *) anAccessGroup {
  
  if (_anAccessGroup) {
    return _anAccessGroup;
  }
  
  return nil;
}


+ (void) deleteInstance{
  sharedInstance = nil;
}

- (id)init {
  self = [super init];
  
  if (self) {
    [self inicializarKeyChain];
  }
  
  return self;
}

- (void)inicializarKeyChain {  
  keychainItemWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:KEYCHAIN_STORENAME accessGroup:anAccessGroup];
  NSLog(@"Initializing keychainItemWrapper instance with memory address `%@`, and accessGroup `%@` ", keychainItemWrapper, anAccessGroup);
}

- (NSString *)leerDeKeyChain:(NSString *)clave {
    NSMutableDictionary *diccionarioKeyChain;
    
    if ([clave isEqualToString:KEYCHAIN_OTP_KEY]) {
        diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:((__bridge id)kSecValueData)]];
    } else {
        diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:KEYCHAIN_DATA_KEY]];
    }
    
    return [diccionarioKeyChain objectForKey:clave];
}

- (void)guardarEnKeyChain:(NSString *)valor clave:(NSString *)clave {
    
    if ([clave isEqualToString:KEYCHAIN_OTP_KEY]) {
        [keychainItemWrapper setObject:[NSString stringWithFormat: @"%@=%@", KEYCHAIN_OTP_KEY, valor] forKey:((__bridge id)kSecValueData)];
    } else {
        NSMutableDictionary *diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:KEYCHAIN_DATA_KEY]];
        
        if ([diccionarioKeyChain count] == 0) {
            [keychainItemWrapper setObject:[NSString stringWithFormat: @"%@=%@", clave, valor] forKey:KEYCHAIN_DATA_KEY];
        } else {
            if ([diccionarioKeyChain objectForKey:clave]) {
                [self borrarDeKeyChain:clave];
            }
            
            [diccionarioKeyChain setObject:valor forKey:clave];
            [keychainItemWrapper setObject:[KeyChainTools diccionarioKeyChainToString:diccionarioKeyChain] forKey:KEYCHAIN_DATA_KEY];
        }
    }
}

- (void)borrarDeKeyChain:(NSString *)clave {
    if ([clave isEqualToString:KEYCHAIN_OTP_KEY]) {
        NSMutableDictionary *diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:((__bridge id)kSecValueData)]];
        
        if ([diccionarioKeyChain count] > 0) {
            if ([diccionarioKeyChain objectForKey:clave]) {
                [diccionarioKeyChain removeObjectForKey:clave];
                [keychainItemWrapper setObject:[KeyChainTools diccionarioKeyChainToString:diccionarioKeyChain] forKey:((__bridge id)kSecValueData)];
            }
        }
    } else {
        NSMutableDictionary *diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:KEYCHAIN_DATA_KEY]];
        
        if ([diccionarioKeyChain count] > 0) {
            if ([diccionarioKeyChain objectForKey:clave]) {
                [diccionarioKeyChain removeObjectForKey:clave];
                [keychainItemWrapper setObject:[KeyChainTools diccionarioKeyChainToString:diccionarioKeyChain] forKey:KEYCHAIN_DATA_KEY];
            }
        }
    }
}

- (void)borrarKeyChain {
    [keychainItemWrapper resetKeychainItem];
}

- (BOOL)isKeyChainValido {
    BOOL keyChainValido = NO;
    
    NSMutableDictionary *diccionarioKeyChain = [KeyChainTools parsearDiccionarioKeyChain:[keychainItemWrapper objectForKey:KEYCHAIN_DATA_KEY]];
    
    if ((diccionarioKeyChain != nil)
        && ([diccionarioKeyChain count] != 0)
        && ([diccionarioKeyChain objectForKey:KEYCHAIN_SEED_KEY] != nil)
        && ([[diccionarioKeyChain objectForKey: KEYCHAIN_SEED_KEY] doubleValue] != 0)
        && ([diccionarioKeyChain objectForKey:KEYCHAIN_TELEPHONE_KEY] != nil)
        && (![[diccionarioKeyChain objectForKey:KEYCHAIN_TELEPHONE_KEY] isEqualToString:@""])) {
        
        keyChainValido = YES;
    }
    
    return keyChainValido;
}


/****************************
 
 Estos metodos permiten guardar NSData en el keyChain.
 Se crearon para el uso de APICronto pero cualquier otra API puede utilizarlos si se requiere.
 
 ****************************/

-(void)guardarDataEnKeychain:(NSData *)data clave:(NSString *)key{
    
    NSData* dataToSave = [NSKeyedArchiver archivedDataWithRootObject:data];
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:key accessGroup:nil];
    [keychainItem setObject:dataToSave forKey:((__bridge id)kSecAttrAccount)];
    //NSLog(@"Guarde el vector %@ en KeyChain con los datos: %@", key, dataToSave);
    //NSLog(@"Vector %@ actualizado", key);
    
}

-(NSData*)leerDataDeKeychain:(NSString *)key{
    NSData *dataToRead;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:key accessGroup:nil];
    dataToRead = [keychainItem objectForKey:((__bridge id)kSecAttrAccount)];
    NSData *valor = [NSKeyedUnarchiver unarchiveObjectWithData:dataToRead];
    
    //NSLog(@"El valor del vector %@ es: %@", key, valor);
    //NSLog(@"Vector %@ leído", key);
    return valor;
    
    
}

/****
 
 **/
-(NSString *)getKeychainGroup {
  return [keychainItemWrapper getKeychainGroup];
}


@end
