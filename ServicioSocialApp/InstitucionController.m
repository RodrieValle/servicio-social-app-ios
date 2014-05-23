//
//  InstitucionController.m
//  ServicioSocialApp
//
//  Created by PDM-115 on 20/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "InstitucionController.h"

@interface InstitucionController ()
{
    NSMutableArray *arrayInstitucion;
    sqlite3 *encargadoDB;
    NSString *dbPathString;
    AppDelegate *appDelegate;
}

@end

@implementation InstitucionController

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

    arrayInstitucion =[[NSMutableArray alloc]init];
    [[self institucionTableView] setDelegate:self];
    [[self institucionTableView]setDataSource:self];
    //NSLog(@"En viewdidload antes de la base");
    //[self crearOabrirDB];
    [_edtNombreInstitucion setDelegate:self];
    [_edtIdInstitucion setDelegate:self];
    [_edtNitInstitucion setDelegate:self];
   
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
    return [arrayInstitucion count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Institucion *institucion=[arrayInstitucion objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%d %@", institucion.idInstitucion, institucion.nombre];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"NIT:  %@", institucion.nit];
    return cell;
}



- (IBAction)insertarInstitucion:(id)sender {
    
    char *error;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        NSString *insert_Stmt=[NSString stringWithFormat:@"INSERT INTO INSTITUCION (nombre, nit) values ('%s','%s')",[self.edtNombreInstitucion.text UTF8String],[self.edtNitInstitucion.text UTF8String]];
        const char *insert_stmt=[insert_Stmt UTF8String];
        
        if (sqlite3_exec(encargadoDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Institución insertada correctamente" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
            Institucion *institucion =[[Institucion alloc]init];
            [institucion setNombre:self.edtNombreInstitucion.text];
            [institucion setNit:self.edtNitInstitucion.text];
            
            [arrayInstitucion addObject:institucion];
        }
        else{
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"No se pudo insertar nueva institución" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }

    
}

- (IBAction)consultarInstitucion:(id)sender {
    
    
    
    sqlite3_stmt *statement;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        [arrayInstitucion removeAllObjects];
        NSString *querySql=[NSString stringWithFormat:@"SELECT * FROM INSTITUCION"];
        const char *querysql=[querySql UTF8String];
        
        if (sqlite3_prepare(encargadoDB, querysql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *idinstitucion=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
                
                NSString *nombre=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSString *nit=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
              
                
                Institucion *institucion=[[Institucion alloc]init];
                
                [institucion setIdInstitucion:[idinstitucion intValue]];
                [institucion setNombre:nombre];
                [institucion setNit:nit];
                
                [arrayInstitucion addObject:institucion];
            }
        }
        else {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Lista vacìa" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
    }
    [[self institucionTableView]reloadData];
    
    
}//fin consultar

- (IBAction)actualizarInstitucion:(id)sender {
    
    
    static sqlite3_stmt *statement=nil;
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        char *update_Stmt="UPDATE INSTITUCION SET NOMBRE=?, NIT=?, WHERE IDINSTITUCION=? ";
       
        if (sqlite3_prepare_v2(encargadoDB, update_Stmt, -1, &statement, NULL)==SQLITE_OK){
             //NSLog(@"ENTRO AL SEGUNDO IF");
            sqlite3_bind_text(statement,1,[self.edtNombreInstitucion.text UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement,2,[self.edtNitInstitucion.text UTF8String], -1, SQLITE_TRANSIENT);
            
            
            sqlite3_bind_int(statement, 3, [self.edtIdInstitucion.text intValue]);
            
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
            Institucion *institucion =[[Institucion alloc]init];
            
            [institucion setNombre:self.edtNombreInstitucion.text];
            [institucion setNit:self.edtNitInstitucion.text];
           
            
            
            [institucion setIdInstitucion:[self.edtIdInstitucion.text intValue]];
            
            [arrayInstitucion addObject:institucion];
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Exito" message:@"Institución modificada" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error de operación" message:@"Institución no modificada" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
            
        }
        sqlite3_close(encargadoDB);
    }

    
}

- (IBAction)eliminarInstitucion:(id)sender {
    [[self institucionTableView]setEditing:!self.institucionTableView.editing animated:YES];
}

-(void)deleteData:(NSString *)deleteQuery{
    char *error;
    
    
    
    if (sqlite3_open([appDelegate.dataBasePath UTF8String], &encargadoDB)==SQLITE_OK) {
        
        if (sqlite3_exec(encargadoDB, [deleteQuery UTF8String],NULL, NULL, &error)==SQLITE_OK) {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Institución eliminada" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Mensaje" message:@"Institución no eliminada" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
            [alerta show];
        }
        sqlite3_close(encargadoDB);
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete){
        Institucion *institucion =[arrayInstitucion objectAtIndex:indexPath.row];
        
        [self deleteData:[NSString stringWithFormat:@"DELETE FROM INSTITUCION WHERE IDINSTITUCION IS '%d'", institucion.idInstitucion]];
        [arrayInstitucion removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(BOOL)textFieldShouldReturn: (UITextField *) textField {
    
    [_edtIdInstitucion resignFirstResponder];
    [_edtNombreInstitucion resignFirstResponder];
    [_edtNitInstitucion resignFirstResponder];
 
    return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self edtIdInstitucion]resignFirstResponder];
    [[self edtNombreInstitucion]resignFirstResponder];
    [[self edtNitInstitucion]resignFirstResponder];
}

@end
