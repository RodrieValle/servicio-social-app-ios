//
//  encargadoServicioViewController.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 19/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Encargado.h"

#import "sqlite3.h"

@interface encargadoServicioViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *edtIdEncargado;
@property (weak, nonatomic) IBOutlet UITextField *edtNombreEncargado;
@property (weak, nonatomic) IBOutlet UITextField *edtEmailEncargado;
@property (weak, nonatomic) IBOutlet UITextField *edtTelefonoEncargado;
@property (weak, nonatomic) IBOutlet UITextField *edtFacultadEncargado;
@property (weak, nonatomic) IBOutlet UITextField *edtEscuelaEncargado;
@property (weak, nonatomic) IBOutlet UITableView *encargadoTableView;
- (IBAction)btnInsertarEncargado:(id)sender;
- (IBAction)btnConsultarEncargado:(id)sender;
- (IBAction)btnActualizarEncargado:(id)sender;
- (IBAction)btnEliminarEncargado:(id)sender;

@end
