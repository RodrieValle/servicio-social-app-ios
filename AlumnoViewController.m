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
    AppDelegate *appDelegate;
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
    arraydeAlumnos =[[NSMutableArray alloc]init];
    [[self tblLista] setDelegate:self];
    [[self tblLista]setDataSource:self];
    //NSLog(@"En viewdidload antes de la base");
    //[self crearOabrirDB];
    [_txtCarnet setDelegate:self];
    [_txtNombre setDelegate:self];
    [_txtTelefono setDelegate:self];
    [_txtDui setDelegate:self];
    [_txtNit setDelegate:self];
    [_txtEmail setDelegate:self];
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
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO ALUMNO (carnet, nombre, telefono, dui, nit, email) values ('%s','%s','%s','%s','%s', '%s')",[self.txtCarnet.text UTF8String],[self.txtNombre.text UTF8String],[self.txtTelefono.text UTF8String],[self.txtDui.text UTF8String],[self.txtNit.text UTF8String],[self.txtEmail.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Alumno insertado correctamente" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
            Alumno *alumno =[[Alumno alloc]init];
            [alumno setCarnet:self.txtCarnet.text];
            [alumno setNombre:self.txtNombre.text];
            [alumno setTelefono:self.txtTelefono.text];
            [alumno setDui:self.txtDui.text];
            [alumno setNit:self.txtNit.text];
            [alumno setEmail:self.txtEmail.text];
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
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
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
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
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

- (IBAction)eliminarAlumno:(id)sender {
    [[self tblLista]setEditing:!self.tblLista.editing animated:YES];
}

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        
        if (sqlite3_exec(encargadoDB, [deleteQuery UTF8String],NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Alumno eliminado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Alumno no eliminado" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        Alumno *alum =[arraydeAlumnos objectAtIndex:indexPath.row];
        [self deleteData:[NSString stringWithFormat:@"DELETE FROM ALUMNO WHERE CARNET IS '%s'",[alum.carnet UTF8String]]];
        [arraydeAlumnos removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
    
    [_txtCarnet resignFirstResponder];
     [_txtNombre resignFirstResponder];
     [_txtTelefono resignFirstResponder];
     [_txtDui resignFirstResponder];
     [_txtNit resignFirstResponder];
     [_txtEmail resignFirstResponder];
    return YES;
    
}

@end
