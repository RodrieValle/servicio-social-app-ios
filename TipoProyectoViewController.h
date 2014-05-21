//
//  TipoProyectoViewController.h
//  ServicioSocialApp
//
//  Created by jb on 5/21/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "TipoProyecto.h"


@interface TipoProyectoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nombreField;
@property (weak, nonatomic) IBOutlet UITableView *TipoProyectoTableView;
- (IBAction)insertarBoton:(id)sender;
- (IBAction)consultarBoton:(id)sender;
- (IBAction)actualizarBoton:(id)sender;
- (IBAction)eliminarBoton:(id)sender;


@end
