//
//  LoginScreen.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-21.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myTabController.h"
#import "YPAPISample.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"


@interface LoginScreen : UIViewController <UITextFieldDelegate>{
    IBOutlet UISegmentedControl *loginControl;
    IBOutlet UILabel* lbl_retypePass;
    IBOutlet UILabel* lbl_Email;
    IBOutlet UITextField* username;
    IBOutlet UITextField* password;
    IBOutlet UITextField* retypePass;
    IBOutlet UITextField* email;
    IBOutlet UIButton* loginButton;
    IBOutlet UIButton* signUpButton;
    IBOutlet UIButton* skip;
}

-(IBAction)gotoMainFrame:(id)sender; // Jump to Home view

@property (strong,nonatomic) IBOutlet UISegmentedControl* loginControl; //Segmentation controller for login and signup

@property (nonatomic) User *loginUser; //User object for logined user



@end
