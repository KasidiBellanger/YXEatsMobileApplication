//
//  SignUpViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-26.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface SignUpViewController : UIViewController
    @property IBOutlet UITextField* username;
    @property IBOutlet UITextField* password;
    @property IBOutlet UITextField* retypepassword;
    @property IBOutlet UITextField* email;
@property IBOutlet UIButton* signUp;

@end
