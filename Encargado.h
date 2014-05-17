//
//  Encargado.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 16/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encargado : NSObject
@property (assign) int idEncargado;
@property (nonatomic, strong)NSString *nombre;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *telefono;
@property (nonatomic, strong)NSString *facultad;
@property (nonatomic, strong)NSString *escuela;
@end
