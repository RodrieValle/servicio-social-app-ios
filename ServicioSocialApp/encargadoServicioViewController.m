//
//  encargadoServicioViewController.m
//  ServicioSocialApp
//
//  Created by PDM-115 on 19/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "encargadoServicioViewController.h"

@interface encargadoServicioViewController ()
{
    NSMutableArray *arrayEncargado;
    sqlite3 *encargadoDB;
    NSString *dbPathString;
}

@end

@implementation encargadoServicioViewController

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
    arrayEncargado=[[NSMutableArray alloc]init];
    [[self encargadoTableView]setDelegate:self];
    [[self encargadoTableView]setDataSource:self];
    [self crearOabrirDB];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) crearOabrirDB{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docPath=[path objectAtIndex:0];
    dbPathString=[docPath stringByAppendingPathComponent:@"encargado.db"];
    char *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:dbPathString]){
        const char *dbPath=[dbPathString UTF8String];
        
        //CREA LA BASE DE DATOS ENCARGADO
        if (sqlite3_open(dbPath, &encargadoDB)==SQLITE_OK) {
            const char *sql_stmt="CREATE TABLE encargado (idencargado INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(100) NOT NULL, email VARCHAR(50) NOT NULL,telefono VARCHAR(8) NOT NULL, facultad VARCHAR(100) NOT NULL, escuela VARCHAR(100) NOT NULL );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(encargadoDB);
        }
    
    }
    
}

- (IBAction)btnInsertarEncargado:(id)sender {
    
}

- (IBAction)btnConsultarEncargado:(id)sender {
    
}

- (IBAction)btnActualizarEncargado:(id)sender {
    
}

- (IBAction)btnEliminarEncargado:(id)sender {
    
}
@end
