//
//  ProyectoViewController.h
//  ServicioSocialApp
//
//  Created by jb on 5/21/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Proyecto.h"

@interface ProyectoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *idProyectoField;
@property (weak, nonatomic) IBOutlet UITextField *nombreProyectoField;
@property (weak, nonatomic) IBOutlet UITextField *idTipoProyecto;
@property (weak, nonatomic) IBOutlet UITextField *idEncargado;
@property (weak, nonatomic) IBOutlet UITextField *idSolicitante;
@property (weak, nonatomic) IBOutlet UITableView *ProyectoTablaView;
- (IBAction)insertar:(id)sender;
- (IBAction)consultar:(id)sender;
- (IBAction)actualizar:(id)sender;
- (IBAction)eliminar:(id)sender;

@end
