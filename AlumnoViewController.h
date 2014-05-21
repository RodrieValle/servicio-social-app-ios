//
//  AlumnoViewController.h
//  ServicioSocialApp
//
//  Created by PDM-115 on 20/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Alumno.h"

@interface AlumnoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtCarnet;
@property (weak, nonatomic) IBOutlet UITextField *txtNombre;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefono;
@property (weak, nonatomic) IBOutlet UITextField *txtDui;
@property (weak, nonatomic) IBOutlet UITextField *txtNit;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITableView *tblLista;
- (IBAction)insertarAlumno:(id)sender;
- (IBAction)consultarAlumno:(id)sender;
- (IBAction)actualizarAlumno:(id)sender;
- (IBAction)eliminarAlumno:(id)sender;
-(BOOL)textFieldShouldReturn: (UITextField *) textField;

@end
