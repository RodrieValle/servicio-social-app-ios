//
//  ProyectoViewController.m
//  ServicioSocialApp
//
//  Created by jb on 5/21/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "ProyectoViewController.h"

@interface ProyectoViewController (){
    NSMutableArray *arrayProyecto;
    sqlite3 *encargadoDB;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayProyecto = [[NSMutableArray alloc]init];
    [[self ProyectoTablaView]setDelegate:self];
    [[self ProyectoTablaView]setDataSource:self];
    [self crearOabrirDB];
    
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
            
           /* sql_stmt="create table PROYECTO ( IDPROYECTO INTEGER not null primary key autoincrement, IDSOLICITANTE INTEGER not null, IDTIPOPROYECTO INTEGER not null, IDENCARGADO INTEGER not null, NOMBRE VARCHAR(100) not null, constraint FK_PROYECTO_ADMINISTR_ENCARGAD foreign key (IDENCARGADO) references ENCARGADOSERVICIOSOCIAL (IDENCARGADO), constraint FK_PROYECTO_SUPERVISA_SOLICITA foreign key (IDSOLICITANTE) references SOLICITANTE (IDSOLICITANTE), constraint FK_PROYECTO_TIENE_UN_TIPOPROY foreign key (IDTIPOPROYECTO) references TIPOPROYECTO (IDTIPOPROYECTO) );";*/
            sql_stmt="create table PROYECTO( IDPROYECTO INTEGER not null primary key autoincrement, NOMBRE VARCHAR(100) not null, IDTIPOPROYECTO INTEGER not null, iDENCARGADO INTEGER not null, IDSOLICITANTE INTEGER not null constraint FK_PROYECTO_ADMINISTR_ENCARGAD foreign key (IDENCARGADO) references ENCARGADOSERVICIOSOCIAL (IDENCARGADO), constraint FK_PROYECTO_SUPERVISA_SOLICITA foreign key (IDSOLICITANTE) references SOLICITANTE (IDSOLICITANTE), constraint FK_PROYECTO_TIENE_UN_TIPOPROY foreign key (IDTIPOPROYECTO) references TIPOPROYECTO (IDTIPOPROYECTO) );";
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayProyecto count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Proyecto *aProyecto = [arrayProyecto objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%i",aProyecto.idProyecto];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %i %i %i", aProyecto.nombreProyecto, aProyecto.idTipoProyecto,
                               aProyecto.idEncargado,aProyecto.idSolicitante];
    return cell;
}

- (IBAction)insertar:(id)sender {
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO PROYECTO(NOMBRE,IDTIPOPROYECTO,IDENCARGADO,IDSOLICITANTE) values ('%s','%d','%d','%d')", [self.nombreProyectoField.text UTF8String],[self.idTipoProyecto.text intValue],[self.idEncargado.text intValue],[self.idSolicitante.text intValue]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"PRoyecto Insertado");
            Proyecto *proyecto=[[Proyecto alloc]init];
            [proyecto setNombreProyecto:self.nombreProyectoField.text];
            [proyecto setIdTipoProyecto:[self.idTipoProyecto.text intValue] ];
            [proyecto setIdEncargado:[self.idEncargado.text intValue]];
            [proyecto setIdSolicitante:[self.idSolicitante.text intValue]];
            [arrayProyecto addObject:proyecto];
        }else{
            NSLog(@"Tipo de Proyecto no Insertado");
        }
        sqlite3_close(encargadoDB);
        
        
    }
    
}

- (IBAction)consultar:(id)sender {
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        [arrayProyecto removeAllObjects];
        NSString *querySql=[NSString stringWithFormat:@"SELECT * FROM PROYECTO"];
        const char *querysql=[querySql UTF8String];
        
        if (sqlite3_prepare(encargadoDB, querysql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *idproyecto1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                
                NSString *nombre1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *idtipoProyecto1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                NSString *idEncargado1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                
                NSString *idSolicitante1=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                
                Proyecto *proyecto =[[Proyecto alloc]init];
                [proyecto setIdProyecto:[idproyecto1 intValue]];
                [proyecto setNombreProyecto:nombre1];
                [proyecto setIdTipoProyecto:[idtipoProyecto1 intValue]];
                [proyecto setIdEncargado:[idEncargado1 intValue]];
                [proyecto setIdSolicitante:[idSolicitante1 intValue]];
                [arrayProyecto addObject:proyecto];
            }
        }
        else {
            NSLog(@"Lista Vacia");
        }
        sqlite3_close(encargadoDB);
    }
    [[self ProyectoTablaView]reloadData];
}

- (IBAction)actualizar:(id)sender {
    static sqlite3_stmt *statement=nil;
    if (sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK) {
        char *update_Stmt="UPDATE PROYECTO SET NOMBRE=?, IDTIPOPROYECTO=?,IDENCARGADO=?, IDSOLICITANTE=? WHERE IDPROYECTO=? ";
        if (sqlite3_prepare_v2(encargadoDB, update_Stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(statement,1,[self.nombreProyectoField.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement,2,[self.idProyectoField.text intValue]);
            sqlite3_bind_int(statement,3,[self.idProyectoField.text intValue]);
            sqlite3_bind_int(statement,4,[self.idSolicitante.text intValue]);
            sqlite3_bind_int(statement,5,[self.idProyectoField.text intValue]);
            
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            Proyecto *proyecto = [[Proyecto alloc]init];
            [proyecto setNombreProyecto:self.nombreProyectoField.text];
            [proyecto setIdTipoProyecto:[self.idTipoProyecto.text intValue]];
            [proyecto setIdEncargado:[self.idEncargado.text intValue]];
            [proyecto setIdSolicitante:[self.idSolicitante.text intValue]];
            [arrayProyecto addObject:proyecto];
            NSLog(@"Proyecto modificado");
        }
        else
        {
            NSLog(@"Proyecto no modificado");
            
        }
        sqlite3_close(encargadoDB);
    }

}

- (IBAction)eliminar:(id)sender {
    [[self ProyectoTablaView]setEditing:!self.ProyectoTablaView.editing animated:YES];
}

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    if(sqlite3_open([dbPathString UTF8String], &encargadoDB)==SQLITE_OK){
        if(sqlite3_exec(encargadoDB,[deleteQuery UTF8String],NULL,NULL,&error)==SQLITE_OK){
            NSLog(@"Proyecto Eliminado");
        }
        else{
            NSLog(@"Alumno no eliminado");
        }
        sqlite3_close(encargadoDB);
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        Proyecto *proyecto = [arrayProyecto objectAtIndex:indexPath.row];
        /*[[self deleteData: [NSString stringWithFormat:@"DELETE FROM PROYECTO WHERE IDPROYECTO IS '%s",[[NSString stringWithFormat:@"%d", proyecto.idProyecto] UTF8String]]]];*/
        
         [arrayProyecto removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self idProyectoField]resignFirstResponder];
    [[self nombreProyectoField]resignFirstResponder];
    [[self idTipoProyecto]resignFirstResponder];
    [[self idEncargado]resignFirstResponder];
    [[self idSolicitante]resignFirstResponder];
}
@end
