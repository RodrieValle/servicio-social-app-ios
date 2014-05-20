//
//  AlumnoViewController.m
//  ServicioSocialApp
//
//  Created by PDM-115 on 20/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "AlumnoViewController.h"

@interface AlumnoViewController ()
{
    NSMutableArray *arraydeAlumnos;
    sqlite3 *alumnoDB;
    NSString *dbPathString;
}
@end

@implementation AlumnoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertarAlumno:(id)sender {
}

- (IBAction)consultarAlumno:(id)sender {
}

- (IBAction)actualizarAlumno:(id)sender {
}

- (IBAction)eliminarAlumno:(id)sender {
}
@end
