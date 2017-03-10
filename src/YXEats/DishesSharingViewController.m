//
//  DishesSharingViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-17.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "DishesSharingViewController.h"

@interface DishesSharingViewController (){
    UIImagePickerController *imgPicker;
    UITapGestureRecognizer* singleTap;
    NSData* photoData;
    IBOutlet UIButton* btn_submit;
}

@end

@implementation DishesSharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[submit1 layer]setBorderWidth:2.0f];
    [[submit1 layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[submit1 layer]setCornerRadius:20.0f];
    [[submit1 layer]setShadowColor:[UIColor blackColor].CGColor];
    [[submit1 layer]setShadowOpacity:1];
    [[submit1 layer]setShadowOffset:CGSizeMake(3, 3)];
    [[submit1 layer]setShadowRadius:3];
    
    
    
    
    /// Initialize the tap gesture recognizer (tap to open camera)
    singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:singleTap];
    [imageView setUserInteractionEnabled:YES];
    UIImage *camera = [[UIImage alloc]init];
    camera = [UIImage imageNamed:@"camera"];
    [btn_submit setEnabled:NO];
    [imageView setImage:camera];
    [comments setText:nil];
    comments.delegate = self;
    [[comments layer]setBorderWidth:2.0f];
    [[comments layer]setBorderColor:[UIColor whiteColor].CGColor];
    [self addInputAccessoryViewForTextView:comments];
    nameofDish.text = self.dishName;
    [nameofDish setEnabled:NO];
    /// If user logined as anonymous user, he/she will not allow to leave comment
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [nameofDish setDelegate:self];
}

/**
 * Tap gesture recognizer: when user touched the image view, open
 * the camera to capture the photo. If user did not authorized access
 * to the camera, then open the photo library.
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
 * Convert captured photo to JPEG format with 80% quality
 * @author: Keshan
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    photoData = UIImageJPEGRepresentation(chosenImage, 0.8);
    [imgPicker dismissViewControllerAnimated:YES completion:NULL];
    [self makeSubmitEnabled];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [imgPicker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField{
    [self makeSubmitEnabled];
}

- (void) textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextfield:textView up:YES];
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    [self animateTextfield:textView up:NO];
    [self makeSubmitEnabled];
}

/**
 * Move the view up a little bit to make the textfield all visbile
 * during the typing
 * @author: Keshan
 */
- (void) animateTextfield: (UITextView*) textView up: (BOOL)up{
    const int movementDistance = 130;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) returnBreakdown:(UIButton *)sender{
    [comments resignFirstResponder];
}

/**
 * Check all fields have typed in something
 * @author: Keshan
 */
- (void)makeSubmitEnabled{
    if (photoData == nil){
        [btn_submit setEnabled:NO];
        return;
    }
    if ([[comments text]isEqualToString:@""]){
        [btn_submit setEnabled:NO];
        return;
    }
    if ([[nameofDish text]isEqualToString:@""]){
        [btn_submit setEnabled:NO];
        return;
    }
    [btn_submit setEnabled:YES];
}

/**
 * Add a "done" button on the keyboard
 * @author: Keshan
 */
- (void)addInputAccessoryViewForTextView:(UITextView *)textView{
    
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

/**
 * Send dish image and comment to Firebase
 * @author: Keshan, Surjit
 */
-(IBAction)addDish: (id) sender{
    NSString *dishName = nameofDish.text;
    CGFloat rating =  _dishRating.value;
    NSString *comment = comments.text;
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com"];
    Firebase *menuRef = [ref childByAppendingPath:@"Menus"];
    
    NSLog(@"%f",rating);
    
    if( [dishName length] == 0){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: dish name"
                                    message:@"dish name must be entered"
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
    if (rating == 0){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Error: rating"
                                    message:@"must be enter a rating"
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
        NSString* dataString = [photoData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        Firebase *restRef = [menuRef childByAppendingPath: self.restaurantName];
        
        NSString * ratingStr = [NSString stringWithFormat:@"%.2f", rating];
        
        NSDictionary *dish = @{
                               @"username": self.currentUser.username,
                               @"ratings": ratingStr,
                               @"comments": comment,
                               @"photo" : dataString
                               };
        
        Firebase *dishRef = [restRef childByAppendingPath: dishName];
        Firebase *cleanProcess = [dishRef childByAppendingPath:@"empty"];
        [cleanProcess setValue:nil];
        cleanProcess = [dishRef childByAppendingPath:@"creator"];
        [cleanProcess setValue:nil];
        
        dishRef = [dishRef childByAutoId];
        [dishRef setValue: dish withCompletionBlock:^(NSError *error, Firebase *ref) {
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
                                            message:@"Your comments has been added. Thank you for sharing!"
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
        }];
    }
}

@end
