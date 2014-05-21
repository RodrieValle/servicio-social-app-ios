//
//  Proyecto.h
//  ServicioSocialApp
//
//  Created by jb on 5/20/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Proyecto : NSObject
@property (assign) int idProyecto;
@property (assign) int idSolicitante;
@property (assign) int idTipoProyecto;
@property (assign) int idEncargado;
@property (nonatomic,strong)NSString *nombre;

@end
