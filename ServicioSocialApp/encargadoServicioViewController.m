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



-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayEncargado count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    Encargado *aEncargado=[arrayEncargado objectAtIndex:indexPath.row];
    cell.textLabel.text=aEncargado.nombre;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@", aEncargado.facultad, aEncargado.escuela];
    return cell;
    
}



- (IBAction)btnInsertarEncargado:(id)sender {
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO ENCARGADO(NOMBRE, EMAIL, TELEFONO, FACULTAD, ESCUELA) values ('%s', '%s', '%s', '%s', '%s')", [self.edtNombreEncargado.text UTF8String], [self.edtEmailEncargado.text UTF8String],[self.edtTelefonoEncargado.text UTF8String], [self.edtFacultadEncargado.text UTF8String], [self.edtEscuelaEncargado.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
    
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            Encargado *encargado=[[Encargado alloc]init];
            [encargado setNombre:self.edtNombreEncargado.text ];
            [encargado setEmail:self.edtEmailEncargado.text ];
            [encargado setTelefono:self.edtTelefonoEncargado.text ];
            [encargado setFacultad:self.edtFacultadEncargado.text ];
            [encargado setEscuela:self.edtEscuelaEncargado.text ];
            [arrayEncargado addObject:encargado];
            
        }else{
        NSLog(@"Encargado no Insertado");
        }
        sqlite3_close(encargadoDB);
    
    
    }
    
}

- (IBAction)btnConsultarEncargado:(id)sender {
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        [arrayEncargado removeAllObjects];
        NSString *querySql=[NSString stringWithFormat:@"SELECT * FROM ENCARGADO"];
        const char *querysql=[querySql UTF8String];
        
        if (sqlite3_prepare(encargadoDB, querysql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *idencargado1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];

                
                NSString *nombre1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *email1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *telefono1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *facultad1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                
                
                NSString *escuela1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                Encargado *encargado=[[Encargado alloc]init];
                
                [encargado setIdEncargado:[idencargado1 intValue]];
                [encargado setNombre:nombre1];
                [encargado setEscuela:email1];
                [encargado setTelefono:telefono1];
                [encargado setFacultad:facultad1];
                [encargado setEscuela:escuela1];
                [arrayEncargado addObject:encargado];
            }
        }
        else {
            NSLog(@"Lista Vacia");
        }
        sqlite3_close(encargadoDB);
    }
    [[self encargadoTableView]reloadData];
}



- (IBAction)btnActualizarEncargado:(id)sender {
    
}

- (IBAction)btnEliminarEncargado:(id)sender {
    
}
@end
