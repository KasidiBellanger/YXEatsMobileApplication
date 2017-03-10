//
//  ChangeAccountSettings.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-16.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "ChangeAccountSettings.h"
#import <Firebase/Firebase.h>

@implementation ChangeAccountSettings{
    NSData* photoData; /// Binary data of user avatar (JPEG)
    UITapGestureRecognizer* singleTap; /// Tap gesture recognizer for open the camera
    NSString* saved_oldpass; /// user old password
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[btn_verify setEnabled:NO];
    [btn_submit setEnabled:NO];
    [btn_submit setAlpha:0];
    [password setSecureTextEntry:YES];
    [password setAlpha:0];
    [retypePass setSecureTextEntry:YES];
    [retypePass setAlpha:0];
    [oldpass setSecureTextEntry:YES];
    lbl_username.text = self.myUser.username;
    [avatar setAlpha:0];
    [lbl_email setAlpha:0];
    [lbl_avatar setAlpha:0];
    [lbl_password setAlpha:0];
    [lbl_retypepass setAlpha:0];
    [email setAlpha:0];
    [email setText:[_myUser email]];
    [avatar setImage:_cur_avatar];
    [self addInputAccessoryViewForTextView:retypePass];
    [self addInputAccessoryViewForTextView:password];
    // Do any additional setup after loading the view.
}

/**
 * Button layout settings
 * @author: Kasidi
 */
-(void)layoutSettings{
    [[btn_verify layer]setBorderWidth:2.0f];
    [[btn_verify layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btn_verify layer]setCornerRadius:20.0f];
    [[btn_verify layer]setShadowOpacity:1];
    [[btn_verify layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btn_verify layer]setShadowRadius:3];
    
    [[btn_submit layer]setBorderWidth:2.0f];
    [[btn_submit layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btn_submit layer]setCornerRadius:20.0f];
    [[btn_submit layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btn_submit layer]setShadowOpacity:1];
    [[btn_submit layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btn_submit layer]setShadowRadius:3];
    
    
    [[btn_dissmiss layer]setBorderWidth:2.0f];
    [[btn_dissmiss layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btn_dissmiss layer]setCornerRadius:20.0f];
    [[btn_dissmiss layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btn_dissmiss layer]setShadowOpacity:1];
    [[btn_dissmiss layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btn_dissmiss layer]setShadowRadius:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButton:(id)sender{
    [ self dismissViewControllerAnimated: YES completion: nil ];
}

/**
 * Add a done button on the keyboard
 * @author: Keshan
 */
- (void)addInputAccessoryViewForTextView:(UITextField *)textView{
    //Create the toolbar for the inputAccessoryView
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [toolbar sizeToFit];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    //Add the done button and set its target:action: to call the method returnTextView:
    toolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                     [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(returnBreakdown:)],
                     nil];
    
    //Set the inputAccessoryView
    [textView setInputAccessoryView:toolbar];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) returnBreakdown:(UIButton *)sender{
    [retypePass resignFirstResponder];
    [password resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![[oldpass text]isEqualToString:@""]){
        [btn_verify setEnabled:YES];
    }
}

-(IBAction)verifyClicked:(id)sender{
    [self verificationOfOldpass];
}

/**
 * Verify the user's current password
 * @author: Keshan
 */
-(void)verificationOfOldpass{
    Firebase* ref = [[Firebase alloc]initWithUrl:@"https://yxeats.firebaseio.com/User"];
    [ref authUser:self.myUser.email password:[oldpass text] withCompletionBlock:^(NSError *error, FAuthData *authData) {
        [oldpass setText:@""];
        if (error){
            /// If password is wrong, pop up an alert window
            UIAlertController *alert=  [UIAlertController
                                        alertControllerWithTitle:@"Error: Wrong password!"
                                        message:@"Verification failed!"
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"Try again"
                                 style: (UIAlertActionStyleDefault)
                                 handler:^(UIAlertAction *action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else{
            /// If password is correct, show other components in the storyboard
            [oldpass setText:@"Verified"];
            [oldpass setTextColor:[UIColor redColor]];
            [btn_submit setAlpha:1];
            [btn_verify setAlpha:0];
            [password setAlpha:1];
            [retypePass setAlpha:1];
            [avatar setAlpha:1];
            [oldpass setEnabled:NO];
            [lbl_email setAlpha:1];
            [lbl_avatar setAlpha:1];
            [lbl_password setAlpha:1];
            [lbl_retypepass setAlpha:1];
            [email setEnabled:NO];
            [email setAlpha:1];
            singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTaped:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [avatar addGestureRecognizer:singleTap];
            [avatar setUserInteractionEnabled:YES];
            [btn_submit setEnabled:YES];
        }
    }];
}

/**
 * Open the camera when user touches their avatar image
 * @author: Keshan
 */
-(void)imageTaped:(UIGestureRecognizer*) gestureRegcognizer{
    [UIView animateWithDuration:0.5 animations:^(void){
        imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }else
        {
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        [self presentViewController:imgPicker animated:YES completion:nil];
    }];
}

/**
 * This function can convert image to JPEG data with 80% quality
 * @author: Keshan
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    avatar.image = chosenImage;
    photoData = UIImageJPEGRepresentation(chosenImage, 0.8);
    [imgPicker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * This function will check every field to make sure the user is not missing something
 * @author: Keshan
 */
-(BOOL)dataValidation{
    if ([[password text]isEqualToString:[retypePass text]]){
        if ([[password text]isEqualToString:@""]){
            return NO;
        }
        if ([[password text]length] < 4){
            return NO;
        }
    }
    return YES;
}

/** 
 * Send the new password to the Firebase to update user's password
 * If password is successfully updated, call another function to update
 * avatar.
 * @author: Keshan
 */
- (IBAction)submitClicked:(id)sender{
    if (![self dataValidation]){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: Field(s) is/are missing"
                                    message:@"Please finish all fields showed above"
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    Firebase* ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/User"]];
            [ref changePasswordForUser:self.myUser.email fromOld:_myUser.password toNew:[password text] withCompletionBlock:^(NSError *error) {
                if (error){
                    UIAlertController *alert=  [UIAlertController
                                                alertControllerWithTitle:@"Error: Submission"
                                                message: @"Network failure for password"
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
                else{
                    [self.myUser setPassword:[password text]];
                    [self changeAvatar];
                }
            }];
}

/**
 * Send the user's new avatar to the Firebase
 * @author: Keshan
 */
-(void)changeAvatar{
    Firebase* ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/Avatars/%@", self.myUser.username]];
    NSString* photo = [photoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary* pushAvatar = @{
                                 @"photo": photo
                                 };
    
    [ref setValue: pushAvatar withCompletionBlock:^(NSError *error, Firebase *ref) {
        if (error){
            UIAlertController *alert=  [UIAlertController
                                        alertControllerWithTitle:@"Error: Submission"
                                        message:@"Network failure"
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
        else{
            UIAlertController *alert=  [UIAlertController
                                        alertControllerWithTitle:@"Success: Thank you"
                                        message:@"Your account has been updated!"
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style: (UIAlertActionStyleDefault)
                                 handler:^(UIAlertAction *action){
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}

@end
