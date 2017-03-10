//
//  SignUpViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-26.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController (){
    IBOutlet UITextField* username;
    IBOutlet UITextField* password;
    IBOutlet UITextField* retypepassword;
    IBOutlet UITextField* email;
    IBOutlet UIButton* signUp;
    
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [password setSecureTextEntry:YES];
    [retypepassword setSecureTextEntry:YES];
    [super viewDidLoad];
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com"];
    // Write data to Firebase
    [myRootRef setValue:@"Do you have data? You'll love Firebase."];
    // Do any additional setup after loading the view.
    [myRootRef createUser:@"bobtony@example.com" password:@"correcthorsebatterystaple"
 withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
     if (error) {
         // There was an error creating the account
     } else {
         NSString *uid = [result objectForKey:@"uid"];
         NSLog(@"Successfully created user account with uid: %@", uid);
     }
 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backToLoginScreen:(id)sender{
    [ self dismissViewControllerAnimated: YES completion: nil ];
}

-(IBAction)registerUser:(id)sender
{
    NSString *user = self.username.text;
    NSString *pass = self.password.text;
    NSString *repass = self.retypepassword.text;
    NSString *em = self.email.text;
    
     NSLog(@"username: %@", user);
     NSLog(@"password: %@", pass);
     NSLog(@"email: %@", em);
    
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com"];
    // Write data to Firebase
    [myRootRef setValue:@"Do you have data? You'll love Firebase."];
    // Do any additional setup after loading the view.
    [myRootRef createUser:@"bobtony@example.com" password:@"correcthorsebatterystaple"
 withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
     if (error) {
         // There was an error creating the account
     } else {
         NSString *uid = [result objectForKey:@"uid"];
         NSLog(@"Successfully created user account with uid: %@", uid);
     }
 }];
    
}


@end
