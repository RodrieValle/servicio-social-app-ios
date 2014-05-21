//
//  ProyectoViewController.m
//  ServicioSocialApp
//
//  Created by jb on 5/20/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "ProyectoViewController.h"

@interface ProyectoViewController ()
{
    NSMutableArray *arrayProyecto;
    sqlite3 *proyectoDB;
    NSString *dbPathString;
}

@end

@implementation ProyectoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) crearOabrirDB{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *docPath=[path objectAtIndex:0];
    dbPathString=[docPath stringByAppendingPathComponent:@"servicioSocial.db"];
    char *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    
    if(![fileManager fileExistsAtPath:dbPathString]){
        const char *dbPath=[dbPathString UTF8String];
        
        //CREA LA BASE DE DATOS ENCARGADO
        if (sqlite3_open(dbPath, &proyectoDB)==SQLITE_OK) {
            //Tabla encargado
            const char *sql_stmt="CREATE TABLE encargado (idencargado INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(100) NOT NULL, email VARCHAR(50) NOT NULL,telefono VARCHAR(8) NOT NULL, facultad VARCHAR(100) NOT NULL, escuela VARCHAR(100) NOT NULL );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            //Tabla alumno
            sql_stmt="create table ALUMNO (CARNET VARCHAR(7) not null primary key, NOMBRE VARCHAR(100) not null, TELEFONO VARCHAR(8) not null, DUI VARCHAR(10) not null, NIT VARCHAR(17) not null, EMAIL VARCHAR(50));";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            sql_stmt="create table BITACORA ( ID INTEGER not null primary key autoincrement, IDTIPOTRABAJO INTEGER not null, CARNET VARCHAR(7) not null, IDPROYECTO INTEGER not null, FECHA DATE not null, DESCRIPCION VARCHAR(250) not null, constraint FK_BITACORA_COMPONE_PROYECTO foreign key (IDPROYECTO) references PROYECTO (IDPROYECTO),constraint FK_BITACORA_SE_CLASIF_TIPOTRAB foreign key (IDTIPOTRABAJO)references TIPOTRABAJO (IDTIPOTRABAJO),constraint FK_BITACORA_TIENE_ALUMNO foreign key (CARNET)references ALUMNO (CARNET));";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table CARGO ( IDCARGO INTEGER not null primary key autoincrement,NOMBRE VARCHAR(100),DESCRIPCION VARCHAR(250) );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            /*sql_stmt="create table ENCARGADOSERVICIOSOCIAL ( IDENCARGADO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, EMAIL VARCHAR(50),TELEFONO VARCHAR(8) not null, FACULTAD VARCHAR(100),ESCUELA CHAR(100));";
             sqlite3_exec(encargadoDB, sql_stmt, NULL, NULL, &error);*/
            
            sql_stmt="create table INSTITUCION ( IDINSTITUCION INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, NIT VARCHAR(17) not null);";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table PROYECTO ( IDPROYECTO INTEGER not null primary key autoincrement, IDSOLICITANTE INTEGER not null, IDTIPOPROYECTO INTEGER not null, IDENCARGADO INTEGER not null, NOMBRE VARCHAR(100) not null, constraint FK_PROYECTO_ADMINISTR_ENCARGAD foreign key (IDENCARGADO) references ENCARGADOSERVICIOSOCIAL (IDENCARGADO), constraint FK_PROYECTO_SUPERVISA_SOLICITA foreign key (IDSOLICITANTE) references SOLICITANTE (IDSOLICITANTE), constraint FK_PROYECTO_TIENE_UN_TIPOPROY foreign key (IDTIPOPROYECTO) references TIPOPROYECTO (IDTIPOPROYECTO) );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table SOLICITANTE ( IDSOLICITANTE INTEGER not null primary key autoincrement, IDINSTITUCION INTEGER not null, IDCARGO INTEGER not null, NOMBRE VARCHAR(100), TELEFONO VARCHAR(8), CORREO_ELECTRONICO   CHAR(100), constraint FK_SOLICITA_CARGO_SOL_CARGO foreign key (IDCARGO) references CARGO (IDCARGO), constraint FK_SOLICITA_PERTENECE_INSTITUC foreign key (IDINSTITUCION) references INSTITUCION (IDINSTITUCION));";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table TIPOPROYECTO ( IDTIPOPROYECTO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table TIPOTRABAJO ( IDTIPOTRABAJO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, VALOR FLOAT not null );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            sql_stmt="create table ASIGNACIONPROYECTO ( CARNET VARCHAR(7) not null, IDPROYECTO INTEGER not null, FECHA DATE, PRIMARY KEY(carnet,idproyecto) CONSTRAINT fk_asignacionproyecto_proyecto FOREIGN KEY (idproyecto) REFERENCES proyecto(idproyecto) ON DELETE RESTRICT, CONSTRAINT fk_asignacionproyecto_alumno FOREIGN KEY (carnet) REFERENCES alumno(carnet) ON DELETE RESTRICT );";
            sqlite3_exec(proyectoDB, sql_stmt, NULL, NULL, &error);
            
            
            sqlite3_close(proyectoDB);
        }
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayProyecto = [[NSMutableArray alloc]init];
    [[self proyectoTableView]setDelegate:self];
    [[self proyectoTableView]setDelegate:self];
    [self crearOabrirDB];
    // Do any additional setup after loading the view.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayProyecto count];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    Proyecto *aProyecto=[arrayProyecto objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%i",aProyecto.idProyecto];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ ", aProyecto.nombre];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)insertarProyectoButton:(id)sender {
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &proyectoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO PROYECTO(IDSOLICITANTE, IDTIPROYECTO, IDENCARGADO, NOMBRE) values ('%i', '%i', '%i', '%s')", [self.idsolicitante.text intValue],[self.idtipoproyectofield.text intValue],[self.idencargado.text intValue],  [self.nombreField.text UTF8String]];
                                                                                                                                                                                       
        
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(proyectoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            Proyecto *proyecto=[[Proyecto alloc]init];
            [proyecto setNombre:self.nombreField.text ];
            [proyecto setIdTipoProyecto:(int)self.idtipoproyectofield.text ];
            [proyecto setIdSolicitante:(int)self.idsolicitante.text];
            [proyecto setIdEncargado:(int)self.idencargado.text ];
            [arrayProyecto addObject:proyecto];
            
        }else{
            NSLog(@"Proyecto no Insertado");
        }
        sqlite3_close(proyectoDB);
        
        
    }
}



- (IBAction)consultarProyectoButton:(id)sender {
}
- (IBAction)eliminarProyectoButton:(id)sender {
}

- (IBAction)actualizarProyectoButton:(id)sender {
}
@end
