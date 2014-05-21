//
//  ProyectoViewController.h
//  ServicioSocialApp
//
//  Created by jb on 5/20/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Proyecto.h"

@interface ProyectoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *idproyectoField;
@property (weak, nonatomic) IBOutlet UITextField *nombreField;
@property (weak, nonatomic) IBOutlet UITextField *idtipoproyectofield;
@property (weak, nonatomic) IBOutlet UITextField *idencargado;
@property (weak, nonatomic) IBOutlet UITextField *idsolicitante;
@property (weak, nonatomic) IBOutlet UITableView *proyectoTableView;
- (IBAction)insertarProyectoButton:(id)sender;
- (IBAction)consultarProyectoButton:(id)sender;
- (IBAction)eliminarProyectoButton:(id)sender;
- (IBAction)actualizarProyectoButton:(id)sender;

@end
