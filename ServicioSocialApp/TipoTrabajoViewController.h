//
//  TipoTrabajoViewController.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 22/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "AppDelegate.h"
#import "TipoTrabajo.h"

@interface TipoTrabajoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtIdTipoProyecto;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtValor;
- (IBAction)insertarTipoTrabajo:(id)sender;
- (IBAction)consultarTipoTrabajo:(id)sender;
- (IBAction)actualizarTipoTrabajo:(id)sender;
- (IBAction)eliminarTipoTrabajo:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *listaTipoTrabajo;
-(BOOL)textFieldShouldReturn: (UITextField *) textField;
@end
