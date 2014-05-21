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

-(void) crearOabrirDB{
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString= [docPath stringByAppendingPathComponent:@"carnet.db"];
    char *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        //crear la base de datos
        if (sqlite3_open(dbPath, &alumnoDB)==SQLITE_OK) {
            NSString *foreign=@"PRAGMA foreign_keys = ON";
            const char *foreign1=[foreign UTF8String];
            if (sqlite3_exec(alumnoDB, foreign1, NULL, NULL, &error) != SQLITE_OK)
            {
                NSLog(@"failed to set the foreign_key pragma");
                return;
            }
            const char *sql_stmt="CREATE TABLE alumno (numalumno INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,carnet VARCHAR(7) NOT NULL UNIQUE, nombre VARCHAR(30) NOT NULL,apellido VARCHAR(30) NOT NULL ,sexo VARCHAR(1) NOT NULL,matganadas INTEGER ); ";
            sqlite3_exec(alumnoDB, sql_stmt, NULL, NULL, &error);
            sql_stmt="CREATE TABLE materia (nummateria INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,codmateria VARCHAR(6) NOT NULL UNIQUE,nommateria VARCHAR(30) NOT NULL, unidadesval VARCHAR(1) NOT NULL);";
            sqlite3_exec(alumnoDB, sql_stmt, NULL, NULL, &error);
            sql_stmt="CREATE TABLE nota (numnota INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,codmateria VARCHAR(6) NOT NULL,carnet VARCHAR(7) NOT NULL, ciclo VARCHAR(5) NOT NULL,notafinal float INTEGER,foreign key (carnet) references ALUMNO (CARNET) on delete restrict on update restrict,foreign key (codmateria) references MATERIA (CODMATERIA) on delete restrict on update restrict ); ";
            sqlite3_exec(alumnoDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(alumnoDB);
            
            
        }
    }
    
}

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
