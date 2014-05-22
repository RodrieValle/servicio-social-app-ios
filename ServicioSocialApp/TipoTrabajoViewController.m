//
//  TipoTrabajoViewController.m
//  ServicioSocialApp
//
//  Created by PDM-115 on 22/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "TipoTrabajoViewController.h"

@interface TipoTrabajoViewController() {
    NSMutableArray *arrayTipoTrabajo;
    sqlite3 *encargadoDB;
    NSString *dbPathString;
    AppDelegate *appDelegate;
}
@end

@implementation TipoTrabajoViewController

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
    arrayTipoTrabajo =[[NSMutableArray alloc]init];
    [[self listaTipoTrabajo] setDelegate:self];
    [[self listaTipoTrabajo]setDataSource:self];
    //NSLog(@"En viewdidload antes de la base");
    //[self crearOabrirDB];
    [_txtNombre setDelegate:self];
    [_txtValor setDelegate:self];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
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
    return [arrayTipoTrabajo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    TipoTrabajo *tipoTrabajo=[arrayTipoTrabajo objectAtIndex:indexPath.row];
    cell.textLabel.text=tipoTrabajo.nombre;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",tipoTrabajo.nombre] ;
    return cell;
}


- (IBAction)insertarTipoTrabajo:(id)sender {
    char *error;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO tipotrabajo (NULL,'%s','%s')",[self.txtNombre.text UTF8String],[self.txtValor.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Tipo de trabajo insertado correctamente" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
            TipoTrabajo *tipoTrabajo = [[TipoTrabajo alloc]init];
            [tipoTrabajo setNombre: self.txtNombre.text];
            [tipoTrabajo setValor: self.txtValor.text];
            [arrayTipoTrabajo addObject:tipoTrabajo];
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"No se pudo insertar tipo de trabajo" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
}

- (IBAction)consultarTipoTrabajo:(id)sender {
    sqlite3_stmt *statement;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        [arrayTipoTrabajo removeAllObjects];
        NSString *querySql =[NSString stringWithFormat:@"SELECT * FROM tipoproyecto"];
        const char *querysql=[querySql UTF8String];
        
        if (sqlite3_prepare(encargadoDB, querysql,-1,&statement,NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *idtipoproyecto= [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *nombre=    [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *valor=    [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                TipoTrabajo *tipoTrabajo=[[TipoTrabajo alloc]init];
                [tipoTrabajo setIdTipoTrabajo: (int) idtipoproyecto];
                [tipoTrabajo setNombre:nombre];
                [tipoTrabajo setValor:valor];
                [arrayTipoTrabajo addObject:tipoTrabajo];
                
            }
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Lista vacìa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
    
    [[self listaTipoTrabajo]reloadData];
    

}

- (IBAction)actualizarTipoTrabajo:(id)sender {
    static sqlite3_stmt *statement=nil;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        char *update_Stmt="UPDATE tipoproyecto SET nombre=?, valor=? WHERE idtipoproyecto=? ";
        if (sqlite3_prepare_v2(encargadoDB, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
            sqlite3_bind_text(statement,1,[self.txtNombre.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,2,[self.txtValor.text UTF8String], -1, SQLITE_TRANSIENT);
            //sqlite3_bind_text(statement,3,[self.txtDui.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            TipoTrabajo *tipoTrabajo =[[TipoTrabajo alloc]init];
            [tipoTrabajo setNombre:self.txtNombre.text];
            [tipoTrabajo setValor:self.txtValor.text];
            [arrayTipoTrabajo addObject:tipoTrabajo];
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Alumno modificado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
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

- (IBAction)eliminarTipoTrabajo:(id)sender {
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
    
    [_txtNombre resignFirstResponder];
    [_txtValor resignFirstResponder];
    return YES;
    
}
@end
