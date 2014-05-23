//
//  LoginViewController.m
//  ServicioSocialApp
//
//  Created by PDM-115 on 22/05/14.
//  Copyright (c) 2014 Rodrigo Herrera. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (IBAction)Acceder:(id)sender {
    if([self.txtUsuario.text  isEqual: @"admin"] && [self.txtPassword.text  isEqual: @"admin"] )
    {
        ViewController *secondViewController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        [self presentModalViewController:secondViewController animated:YES];
    }
    else{
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Datos inválidos" message:@"El usuario o la contraseña son incorrectos" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [alerta show];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self txtUsuario ]resignFirstResponder];
    [[self txtPassword]resignFirstResponder];
}
@end
