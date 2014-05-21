//
//  Proyecto.h
//  ServicioSocialApp
//
//  Created by jb on 5/21/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Proyecto : NSObject
@property (assign) int idProyecto;
@property (nonatomic,strong)NSString *nombreProyecto;
@property (assign) int idTipoProyecto;
@property (assign) int idEncargado;
@property (assign) int idSolicitante;
@end
