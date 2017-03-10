//
//  MenuSharingViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "MenuSharingViewController.h"
#import <Firebase/Firebase.h>

@implementation MenuSharingViewController{
    UIImagePickerController *imgPicker;  /// Image picker for capture the restaurant menu
    UITapGestureRecognizer* singleTap;  /// Tap gesture recognizer for image picker
    NSData* photoData; /// Binary data of menu photo
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    // Initialize Tap gesture recognizer
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:singleTap];
    [imageView setUserInteractionEnabled:YES];
    
    // End of initialization
    
    UIImage *camera = [[UIImage alloc]init];
    camera = [UIImage imageNamed:@"camera"];
    [imageView setImage:camera];
    
    [btn_submit setEnabled:NO];
    
    /// Anonymous user cannot add menu photo
    if (_currentUser == nil){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Warning: You are not login"
                                    message:@"Sorry~@ If you would like to add comment, you need to login first."
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)didReceiveMemoryWarning{
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    imgPicker = [[UIImagePickerController alloc]init];
}

/**
 * Enable the camera to capture the menu photo
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
 * Save the photo as JPEG format, 80% quality
 * @author: Keshan
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    photoData = UIImageJPEGRepresentation(chosenImage, 0.8);
    [btn_submit setEnabled:YES];
    [imgPicker dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * Send the photo JPEG file to the Firebase
 * @author: Keshan
 */
- (IBAction)sendMenu:(id)sender{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com/MenuPhotos"];
    Firebase *menuPhotoRef = [ref childByAppendingPath:[NSString stringWithFormat:@"%@", self.restaurantID]];
    menuPhotoRef = [menuPhotoRef childByAutoId];
    NSString* dataString = [photoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *menu = @{
                           @"username": self.currentUser.username ,
                           @"photo" : dataString
                           };
    [menuPhotoRef setValue: menu withCompletionBlock:^(NSError *error, Firebase *ref) {
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
                                        message:@"The menu has been added. Thank you for sharing!"
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
@end
