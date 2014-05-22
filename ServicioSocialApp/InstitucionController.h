//
//  InstitucionController.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 20/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Institucion.h"

#import "sqlite3.h"

#import "AppDelegate.h"

@interface InstitucionController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *edtIdInstitucion;
@property (weak, nonatomic) IBOutlet UITextField *edtNombreInstitucion;
@property (weak, nonatomic) IBOutlet UITextField *edtNitInstitucion;
- (IBAction)insertarInstitucion:(id)sender;
- (IBAction)consultarInstitucion:(id)sender;
- (IBAction)actualizarInstitucion:(id)sender;
- (IBAction)eliminarInstitucion:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *institucionTableView;

@end
