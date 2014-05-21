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
    //sqlite3 *;
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
    // Do any additional setup after loading the view.
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
}

- (IBAction)consultarProyectoButton:(id)sender {
}
- (IBAction)eliminarProyectoButton:(id)sender {
}

- (IBAction)actualizarProyectoButton:(id)sender {
}
@end
