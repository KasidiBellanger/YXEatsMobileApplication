//
//  LoginScreen.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-21.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "LoginScreen.h"
#import "UserLogin.h"
#import "User.h"

@interface LoginScreen (){
    UIButton* FBloginButton;
    FBSDKLoginManager* myFBloginButton;
}

@end

@implementation LoginScreen
@synthesize loginControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize all components in the login view
    [lbl_Email setAlpha:0];
    [lbl_retypePass setAlpha:0];
    [retypePass setAlpha:0];
    [email setAlpha:0];
    [loginControl setBackgroundColor:[UIColor orangeColor]];
    [loginControl setTintColor:[UIColor darkGrayColor]];
    [signUpButton setAlpha:0];
    password.delegate = self;
    [self layoutSettings];
    // end of initializtion
}

/**
 * Layout of buttons
 * @author: Kasidi
 */
- (void)layoutSettings{
    [[loginButton layer]setBorderWidth:2.0f];
    [[loginButton layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[loginButton layer]setCornerRadius:20.0f];
    [[loginButton layer]setShadowColor:[UIColor blackColor].CGColor];
    [[loginButton layer]setShadowOpacity:1];
    [[loginButton layer]setShadowOffset:CGSizeMake(3, 3)];
    [[loginButton layer]setShadowRadius:3];
    
    
    
    [[signUpButton layer]setBorderWidth:2.0f];
    [[signUpButton layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[signUpButton layer]setCornerRadius:20.0f];
    [[signUpButton layer]setShadowColor:[UIColor blackColor].CGColor];
    [[signUpButton layer]setShadowOpacity:1];
    [[signUpButton layer]setShadowOffset:CGSizeMake(3, 3)];
    [[signUpButton layer]setShadowRadius:3];
    
    
    [[skip layer]setBorderWidth:2.0f];
    [[skip layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[skip layer]setCornerRadius:20.0f];
    [[skip layer]setShadowColor:[UIColor blackColor].CGColor];
    [[skip layer]setShadowOpacity:1];
    [[skip layer]setShadowOffset:CGSizeMake(3, 3)];
    [[skip layer]setShadowRadius:3];
}

-(void)viewDidAppear:(BOOL)animated{
    [retypePass setSecureTextEntry:YES];
    [password setSecureTextEntry:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMainFrame:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle: nil];
    UINavigationController * vc = [storyboard  instantiateViewControllerWithIdentifier:@"start"];
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 * Sign in with our own database
 * @author: Brendan, Kasidi, Surjit
 */
- (IBAction)signInAction:(id)sender{
    NSString *user = username.text;
    NSString *pass = password.text;
    //NSString *em ;//= email.text;
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com/User"];
    //Firebase *ref = [[Firebase alloc] initWithUrl:@"https://dinosaur-facts.firebaseio.com/dinosaurs"];
//    [[[ref queryOrderedByChild:@"username"] queryEqualToValue:user]
//     observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//         NSLog(@"%@", snapshot.key);
//     }];
    [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot){
        BOOL userExists = false;
        for(FDataSnapshot *child in snapshot.children){
            NSString *em;
            
            if([child.value[@"username"]isEqualToString:user]){
                em = child.value[@"email"];
                userExists = true;
                [ref authUser:em password:pass
          withCompletionBlock:^(NSError *error, FAuthData *authData) {
              if (error) {
                  // There was an error logging in to this account
                  NSLog(@"Error occured when loggin in");
                  UIAlertController *alert=  [UIAlertController
                                              alertControllerWithTitle:@"Error: login"
                                              message:@"error occured while logging in"
                                              preferredStyle:(UIAlertControllerStyleAlert)];
                  
                  UIAlertAction *ok = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style: (UIAlertActionStyleDefault)
                                       handler:^(UIAlertAction *action){
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
                  [alert addAction:ok];
                  [self presentViewController:alert animated:YES completion:nil];
              } else {
                  // We are now logged in
                  _loginUser = [[User alloc] init];
//                  [_loginUser setUsername:user];
//                  [_loginUser setEmail: em];
//                  [_loginUser setPassword:pass];
                  _loginUser.username = user;
                  _loginUser.email = em;
                  _loginUser.password = pass;
                  
                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle: nil];
                  
                  UIViewController * vc = [storyboard  instantiateViewControllerWithIdentifier:@"start"];
                  ((myTabController*)vc).user = _loginUser;
                  //vc.
                  //vc.tabBarController. = tab;
                  
                  //[self presentViewController: tab animated:YES completion:nil];
                  //[vc pushViewController:tab animated:YES];
                  [self presentViewController:vc animated:YES completion:nil];
              }
          }];
                
            }
            
        }
        if (userExists == false){
            UIAlertController *alert=  [UIAlertController
                                       alertControllerWithTitle:@"Error: login"
                                       message:@"username does not exists"
                                       preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style: (UIAlertActionStyleDefault)
                                 handler:^(UIAlertAction *action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

/**
 * Sign in with our own database
 * @author: Brendan, Kasidi, Surjit
 */
- (IBAction)signUpAction:(id)sender{
    NSString *user = username.text;
    NSString *pass = password.text;
    NSString *repass = retypePass.text;
    NSString *em = email.text;
    BOOL valid = true;
    
    if( [user length] == 0){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: username"
                                    message:@"username must be entered"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    else if (repass != pass){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: password"
                                    message:@"password does not match"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    else if([em length] == 0){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: email"
                                    message:@"must enter an email"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    else if ( [pass length] < 4 || [pass length] > 16) {
        UIAlertController *alert=  [UIAlertController
                                     alertControllerWithTitle:@"Error: password"
                                     message:@"password must be between 4 and 16 characters"
                                     preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    else if ( [user length] < 4 || [user length] > 16) {
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: username"
                                    message:@"username must be between 4 and 16 characters"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    //check for whitespace
    NSRange whiteSpaceRange = [user rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: username"
                                    message:@"username cannot contain whitespace"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    whiteSpaceRange = [pass rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
        NSLog(@"Found whitespace");
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: password"
                                    message:@"password cannot contain whitespace"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        valid = false;
    }
    else if(valid == true){
        
        Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com"];
        
        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com/AllUser"];
        [ref observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            BOOL exists = false;
            for(FDataSnapshot *child in snapshot.children){
                // NSLog(@"%@",child);
                if( child.value == user){
                    exists = true;
                    NSLog(@"user name already exists");
                    UIAlertController *alert=  [UIAlertController
                                                alertControllerWithTitle:@"Error: username"
                                                message:@"username already exists"
                                                preferredStyle:(UIAlertControllerStyleAlert)];
                    
                    UIAlertAction *ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style: (UIAlertActionStyleDefault)
                                         handler:^(UIAlertAction *action){
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    //valid = false;
                }
            }
            if(exists == false){
                [myRootRef createUser:em password:pass
             withValueCompletionBlock:^(NSError *error, NSDictionary *result){
                 if (error) {
                     // There was an error creating the account
                     NSLog(@"error occured when creating the account");
                     NSLog(@"%@", error.description);
                 } else {
                     NSString *uid = [result objectForKey:@"uid"];
                     NSLog(@"Successfully created user account with uid: %@", uid);
                     [[myRootRef childByAppendingPath:[NSString stringWithFormat:@"User/%@/username", uid]]setValue:user];
                     [[myRootRef childByAppendingPath:[NSString stringWithFormat:@"User/%@/email", uid]]setValue:em];
                     [[ ref childByAutoId ]setValue: user];
                
                     [myRootRef authUser:em password:pass
                     withCompletionBlock:^(NSError *error, FAuthData *authData) {
                         if (error) {
                             // an error occurred while attempting login
                             NSLog(@"error occured on login");
                         } else {
                             // user is logged in, check authData for data
                             NSLog(@"user logged in");
                             User *loginUser = [[User alloc] init];
                             [loginUser setUsername:user];
                             [loginUser setEmail: em];
                             [loginUser setPassword:pass];
                             
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle: nil];
                             
                             UINavigationController * vc = [storyboard  instantiateViewControllerWithIdentifier:@"start"];
                             ((myTabController*)vc).user = loginUser;
                             [self presentViewController:vc animated:YES completion:nil];
                         }
                }];
                 }
             }];
            }
        } withCancelBlock:^(NSError *error) {
                             NSLog(@"%@", error.description);
        }];
    }
}

/**
 * Login/Signup buttons and textfields display controller
 * @author: Keshan
 */

-(IBAction)switchShow:(id)sender{
    if (loginControl.selectedSegmentIndex == 0){
        [FBloginButton setAlpha:1];
        [loginButton setAlpha:1];
        [lbl_Email setAlpha:0];
        [lbl_retypePass setAlpha:0];
        [retypePass setAlpha:0];
        [email setAlpha:0];
        [signUpButton setAlpha:0];
    }
    else if (loginControl.selectedSegmentIndex == 1){
        [FBloginButton setAlpha:0];
        [lbl_Email setAlpha:1];
        [lbl_retypePass setAlpha:1];
        [retypePass setAlpha:1];
        [email setAlpha:1];
        [loginButton setAlpha:0];
        [signUpButton setAlpha:1];
    }
}


@end
