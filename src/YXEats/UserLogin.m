//
//  UserLogin.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-26.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "UserLogin.h"

@interface UserLogin(){
    IBOutlet UITextField* username;
    IBOutlet UITextField* password;
}

@end

@implementation UserLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [password setSecureTextEntry:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToLoginScreen:(id)sender{
    [ self dismissViewControllerAnimated: YES completion: nil ];
}

-(IBAction)loginButton:(id)sender{
    NSLog(@"Username: %@, Password: %@", username.text, password.text);
}

@end
