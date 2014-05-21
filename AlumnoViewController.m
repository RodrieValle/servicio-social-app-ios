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
    sqlite3 *encargadoDB;
    NSString *dbPathString;
}
@end

@implementation AlumnoViewController

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
            
            /*sql_stmt="create table ENCARGADOSERVICIOSOCIAL ( IDENCARGADO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, EMAIL VARCHAR(50),TELEFONO VARCHAR(8) not null, FACULTAD VARCHAR(100),ESCUELA CHAR(100));";
             sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);*/
            
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
    arraydeAlumnos =[[NSMutableArray alloc]init];
    //[[self tblLista] setDelegate:self];
    //[[self tblLista]setDataSource:self];
    [self crearOabrirDB];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arraydeAlumnos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Alumno *aAlumno=[arraydeAlumnos objectAtIndex:indexPath.row];
    cell.textLabel.text=aAlumno.carnet;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",aAlumno.nombre] ;
    return cell;
}

- (IBAction)insertarAlumno:(id)sender {
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO ALUMNO (carnet, nombre, telefono, dui, nit, email) values ('%s','%s','%s','%s','%s', '%s')",[self.txtCarnet.text UTF8String],[self.txtNombre.text UTF8String],[self.txtTelefono.text UTF8String],[self.txtDui.text UTF8String],[self.txtNit.text UTF8String],[self.txtEmail.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Alumno Insertado correctamente");
            
            Alumno *alumno =[[Alumno alloc]init];
            [alumno setCarnet:self.txtCarnet.text];
            [alumno setCarnet:self.txtNombre.text];
            [alumno setCarnet:self.txtTelefono.text];
            [alumno setCarnet:self.txtDui.text];
            [alumno setCarnet:self.txtNit.text];
            [alumno setCarnet:self.txtEmail.text];
            [arraydeAlumnos addObject:alumno];
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"No se pudo insertar alumno" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
}

- (IBAction)consultarAlumno:(id)sender {
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        [arraydeAlumnos removeAllObjects];
        NSString *querySql =[NSString stringWithFormat:@"SELECT * FROM ALUMNO"];
        const char *querysql=[querySql UTF8String];
        
        if (sqlite3_prepare(encargadoDB, querysql,-1,&statement,NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *carnet= [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *nombre=    [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *telefono=    [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *dui=  [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                NSString *nit=      [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,4)];
                NSString *email=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                
                Alumno *alumno=[[Alumno alloc]init];
                [alumno setCarnet:carnet];
                [alumno setNombre:nombre];
                [alumno setTelefono:telefono];
                [alumno setDui:dui];
                [alumno setNit:nit];
                [alumno setEmail:email];
                [arraydeAlumnos addObject:alumno];
                
            }
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Lista vacìa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
    
    [[self tblLista]reloadData];

}

- (IBAction)actualizarAlumno:(id)sender {
    static sqlite3_stmt *statement=nil;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        char *update_Stmt="UPDATE ALUMNO SET nombre=?, telefono=?, dui=?, nit=?, email=? WHERE carnet=? ";
        if (sqlite3_prepare_v2(encargadoDB, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement,1,[self.txtNombre.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,2,[self.txtTelefono.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,3,[self.txtDui.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,4,[self.txtNit.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,5,[self.txtEmail.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,6,[self.txtCarnet.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            Alumno *alumno =[[Alumno alloc]init];
            [alumno setCarnet:self.txtCarnet.text];
            [alumno setNombre:self.txtNombre.text];
            [alumno setTelefono:self.txtTelefono.text];
            [alumno setDui:self.txtDui.text];
            [alumno setNit:self.txtNit.text];
            [alumno setEmail:self.txtEmail.text];
            
            [arraydeAlumnos addObject:alumno];
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Alumno modificado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Alumno no modificado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
        }
        sqlite3_close(encargadoDB);
    }

}

- (IBAction)eliminarAlumno:(id)sender {
    [[self tblLista]setEditing:!self.tblLista.editing animated:YES];
}
@end
