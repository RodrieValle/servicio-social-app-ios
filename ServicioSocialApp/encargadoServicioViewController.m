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
    AppDelegate *appDelegate;
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
    //[self crearOabrirDB];
    [_edtNombreEncargado setDelegate:self];
    [_edtIdEncargado setDelegate:self];
    [_edtEmailEncargado setDelegate:self];
    [_edtTelefonoEncargado setDelegate:self];
    [_edtFacultadEncargado setDelegate:self];
    [_edtEscuelaEncargado setDelegate:self];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void) crearOabrirDB{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docPath=[path objectAtIndex:0];
    dbPathString=[docPath stringByAppendingPathComponent:@"servicioSocial.db"];
    char *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:dbPathString]){
        const char *dbPath=[dbPathString UTF8String];
        
        //CREA LA BASE DE DATOS ENCARGADO
        if (sqlite3_open(dbPath, &encargadoDB)==SQLITE_OK) {
            NSString *foreign=@"PRAGMA foreign_keys = ON";
            const char *foreign1=[foreign UTF8String];
            if (sqlite3_exec(encargadoDB, foreign1, NULL, NULL, &error) != SQLITE_OK)
            {
                NSLog(@"failed to set the foreign_key pragma");
                return;
            }
            //Tabla encargado
            const char *sql_stmt="CREATE TABLE encargado (idencargado INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(100) NOT NULL, email VARCHAR(50) NOT NULL,telefono VARCHAR(8) NOT NULL, facultad VARCHAR(100) NOT NULL, escuela VARCHAR(100) NOT NULL );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            //Tabla alumno
            sql_stmt="create table ALUMNO (CARNET VARCHAR(7) not null primary key, NOMBRE VARCHAR(100) not null, TELEFONO VARCHAR(8) not null, DUI VARCHAR(10) not null, NIT VARCHAR(17) not null, EMAIL VARCHAR(50));";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            sql_stmt="create table BITACORA ( ID INTEGER not null primary key autoincrement, IDTIPOTRABAJO INTEGER not null, CARNET VARCHAR(7) not null, IDPROYECTO INTEGER not null, FECHA DATE not null, DESCRIPCION VARCHAR(250) not null, constraint FK_BITACORA_COMPONE_PROYECTO foreign key (IDPROYECTO) references PROYECTO (IDPROYECTO),constraint FK_BITACORA_SE_CLASIF_TIPOTRAB foreign key (IDTIPOTRABAJO)references TIPOTRABAJO (IDTIPOTRABAJO),constraint FK_BITACORA_TIENE_ALUMNO foreign key (CARNET)references ALUMNO (CARNET));";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);

            sql_stmt="create table CARGO ( IDCARGO INTEGER not null primary key autoincrement,NOMBRE VARCHAR(100),DESCRIPCION VARCHAR(250) );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
///////
            sql_stmt="create table ENCARGADOSERVICIOSOCIAL ( IDENCARGADO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, EMAIL VARCHAR(50),TELEFONO VARCHAR(8) not null, FACULTAD VARCHAR(100),ESCUELA CHAR(100));";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
////
            sql_stmt="create table INSTITUCION ( IDINSTITUCION INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, NIT VARCHAR(17) not null);";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);

            sql_stmt="create table PROYECTO ( IDPROYECTO INTEGER not null primary key autoincrement, IDSOLICITANTE INTEGER not null, IDTIPOPROYECTO INTEGER not null, IDENCARGADO INTEGER not null, NOMBRE VARCHAR(100) not null, constraint FK_PROYECTO_ADMINISTR_ENCARGAD foreign key (IDENCARGADO) references ENCARGADOSERVICIOSOCIAL (IDENCARGADO), constraint FK_PROYECTO_SUPERVISA_SOLICITA foreign key (IDSOLICITANTE) references SOLICITANTE (IDSOLICITANTE), constraint FK_PROYECTO_TIENE_UN_TIPOPROY foreign key (IDTIPOPROYECTO) references TIPOPROYECTO (IDTIPOPROYECTO) );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);

            sql_stmt="create table SOLICITANTE ( IDSOLICITANTE INTEGER not null primary key autoincrement, IDINSTITUCION INTEGER not null, IDCARGO INTEGER not null, NOMBRE VARCHAR(100), TELEFONO VARCHAR(8), CORREO_ELECTRONICO   CHAR(100), constraint FK_SOLICITA_CARGO_SOL_CARGO foreign key (IDCARGO) references CARGO (IDCARGO), constraint FK_SOLICITA_PERTENECE_INSTITUC foreign key (IDINSTITUCION) references INSTITUCION (IDINSTITUCION));";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table TIPOPROYECTO ( IDTIPOPROYECTO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table TIPOTRABAJO ( IDTIPOTRABAJO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, VALOR FLOAT not null );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table ASIGNACIONPROYECTO ( CARNET VARCHAR(7) not null, IDPROYECTO INTEGER not null, FECHA DATE, PRIMARY KEY(carnet,idproyecto) CONSTRAINT fk_asignacionproyecto_proyecto FOREIGN KEY (idproyecto) REFERENCES proyecto(idproyecto) ON DELETE RESTRICT, CONSTRAINT fk_asignacionproyecto_alumno FOREIGN KEY (carnet) REFERENCES alumno(carnet) ON DELETE RESTRICT );";
            sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);

            
            sqlite3_close(encargadoDB);
        }
    
    }
    
}
*/


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
    cell.textLabel.text=[NSString stringWithFormat:@"%d %@", aEncargado.idEncargado, aEncargado.nombre];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@", aEncargado.facultad, aEncargado.escuela];
    return cell;
    
}



- (IBAction)btnInsertarEncargado:(id)sender {
    char *error;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO ENCARGADOSERVICIOSOCIAL (nombre, email, telefono, facultad, escuela) values ('%s','%s','%s','%s','%s')",[self.edtNombreEncargado.text UTF8String],[self.edtEmailEncargado.text UTF8String],[self.edtTelefonoEncargado.text UTF8String],[self.edtFacultadEncargado.text UTF8String],[self.edtEscuelaEncargado.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Encargado insertado correctamente" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
            Encargado *encargado =[[Encargado alloc]init];
            [encargado setNombre:self.edtNombreEncargado.text];
            [encargado setEmail:self.edtEmailEncargado.text];
            [encargado setTelefono:self.edtTelefonoEncargado.text];
            [encargado setFacultad:self.edtFacultadEncargado.text];
            [encargado setEscuela:self.edtEscuelaEncargado.text];
            [arrayEncargado addObject:encargado];
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"No se pudo insertar nuevo encargado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
}

- (IBAction)btnConsultarEncargado:(id)sender {
    
    sqlite3_stmt *statement;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        [arrayEncargado removeAllObjects];
        NSString *querySql=[NSString stringWithFormat:@"SELECT * FROM ENCARGADOSERVICIOSOCIAL"];
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
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Lista vacìa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
    [[self encargadoTableView]reloadData];
}



- (IBAction)btnActualizarEncargado:(id)sender {
    
    
    
    
    static sqlite3_stmt *statement=nil;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        char *update_Stmt="UPDATE ENCARGADOSERVICIOSOCIAL SET NOMBRE=?, EMAIL=?, TELEFONO=?, FACULTAD=?, ESCUELA=? WHERE IDENCARGADO=? ";
        if (sqlite3_prepare_v2(encargadoDB, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement,1,[self.edtNombreEncargado.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,2,[self.edtEmailEncargado.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,3,[self.edtTelefonoEncargado.text UTF8String], -1, SQLITE_TRANSIENT);
             sqlite3_bind_text(statement,4,[self.edtFacultadEncargado.text UTF8String], -1, SQLITE_TRANSIENT);
             sqlite3_bind_text(statement,5,[self.edtEscuelaEncargado.text UTF8String], -1, SQLITE_TRANSIENT);
    
             sqlite3_bind_int(statement, 6, [self.edtIdEncargado.text intValue]);
            
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            Encargado *encargado =[[Encargado alloc]init];
           
            [encargado setNombre:self.edtNombreEncargado.text];
            [encargado setEmail:self.edtEmailEncargado.text];
            [encargado setTelefono:self.edtTelefonoEncargado.text];
            [encargado setFacultad:self.edtFacultadEncargado.text];
            
            
            [encargado setIdEncargado:[self.edtIdEncargado.text intValue]];
             [encargado setEscuela:self.edtEscuelaEncargado.text];
            [arrayEncargado addObject:encargado];
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Exito" message:@"Encargado modificado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Encargado no modificado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
        }
        sqlite3_close(encargadoDB);
    }

    
    
}

- (IBAction)btnEliminarEncargado:(id)sender {
    [[self encargadoTableView]setEditing:!self.encargadoTableView.editing animated:YES];
    
}

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    
  
    sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB);
    NSLog(@"Error1: ,%s",sqlite3_errmsg(encargadoDB));
    
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        
        sqlite3_exec(encargadoDB, [deleteQuery UTF8String],NULL, NULL, &error);
        NSLog(@"Error2: ,%s",sqlite3_errmsg(encargadoDB));
        if (sqlite3_exec(encargadoDB, [deleteQuery UTF8String],NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Encargado eliminado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Encargado no eliminado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        Encargado *encargado =[arrayEncargado objectAtIndex:indexPath.row];
        
        [self deleteData:[NSString stringWithFormat:@"DELETE FROM ENCARGADOSERVICIOSOCIAL WHERE NOMBRE IS '%s' AND FACULTAD IS '%s' AND ESCUELA IS '%s'", [encargado.nombre UTF8String], [encargado.facultad UTF8String ], [encargado.escuela UTF8String]]];
        [arrayEncargado removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
    
    [_edtIdEncargado resignFirstResponder];
    [_edtNombreEncargado resignFirstResponder];
    [_edtEscuelaEncargado resignFirstResponder];
    [_edtEmailEncargado resignFirstResponder];
    [_edtTelefonoEncargado resignFirstResponder];
    [_edtFacultadEncargado resignFirstResponder];
    return YES;
    
}



@end
