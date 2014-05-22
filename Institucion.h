//
//  Institucion.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 22/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Institucion : NSObject
@property (assign) int idInstitucion;
@property (nonatomic, strong)NSString *nombre;
@property (nonatomic, strong)NSString *nit;

@end
