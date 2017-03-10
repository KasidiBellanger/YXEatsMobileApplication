//
//  ChangeAccountSettings.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-16.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ChangeAccountSettings : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>{
    IBOutlet UILabel* lbl_username;
    IBOutlet UITextField* password;
    IBOutlet UITextField* retypePass;
    IBOutlet UITextField* email;
    UIImagePickerController* imgPicker;
    IBOutlet UIImageView* avatar;
    IBOutlet UITextField* oldpass;
    IBOutlet UIButton* btn_submit;
    IBOutlet UIButton* btn_verify;
    IBOutlet UIButton* btn_dissmiss;
    IBOutlet UILabel* lbl_password;
    IBOutlet UILabel* lbl_retypepass;
    IBOutlet UILabel* lbl_email;
    IBOutlet UILabel* lbl_avatar;
}

@property (nonatomic,strong) User* myUser; /// Logined user object

@property (nonatomic,strong) UIImage* cur_avatar; /// The image data of current user avatar
@end
