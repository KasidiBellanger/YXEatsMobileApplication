//
//  SecondViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-01.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController (){
    IBOutlet UIPickerView* feedbackPicker;  /// Selection view of feedback options
    IBOutlet UITextView* feedbackInfo;  /// Feedback info typed by user
    IBOutlet UILabel* lbl_feedback;
    NSArray* pickerOptions;  /// Options for UIPickerview
    NSString* pickedCategory; /// Selected feedback option
}

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[feedbackInfo layer]setBorderWidth:3.0f];
    [[feedbackInfo layer]setBorderColor:[UIColor whiteColor].CGColor];
    NSLog(@"userinFeed: %@", _user.username);
    feedbackInfo.delegate = self;
    [self addInputAccessoryViewForTextView:feedbackInfo];
    [self layoutSettings];
}

/**
 * Button layout settings
 * @author: Kasidi
 */
-(void)layoutSettings{
    [[send layer]setBorderWidth:2.0f];
    [[send layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[send layer]setCornerRadius:20.0f];
    [[send layer]setShadowColor:[UIColor blackColor].CGColor];
    [[send layer]setShadowOpacity:1];
    [[send layer]setShadowOffset:CGSizeMake(3, 3)];
    [[send layer]setShadowRadius:3];
}

- (void) viewDidAppear:(BOOL)animated
{
    /// Set the default feedback option
    [feedbackPicker selectRow:2 inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    pickerOptions = [[NSArray alloc]initWithObjects:@"Misconduct",@"Problems/Bugs", @"Suggestions", @"Account Problem", @"Other", nil];
    [feedbackInfo setText:@""];
}

/**
 * Add a done button to keyboard
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

- (void) textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextfield:textView up:YES];
    //textView.scrollEnabled = YES;
    textView.text = @"";
}

-(void) textViewDidEndEditing:(UITextView *)textView{
    [self animateTextfield:textView up:NO];
}

/**
 * Move the view up a little bit to make the textfield all visbile
 * during the typing
 * @author: Keshan
 */
- (void) animateTextfield: (UITextView*) textView up: (BOOL)up{
    const int movementDistance = 120;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void) returnBreakdown:(UIButton *)sender{
    [feedbackInfo resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerOptions count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerOptions objectAtIndex:row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [pickerOptions objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickedCategory = [pickerOptions objectAtIndex:row];
    if ([pickedCategory isEqualToString:@"Account Problem"]){
        feedbackInfo.text = @"Please clearly indicate your account name and what's happening to your account";
    }
    else {
        feedbackInfo.text = @"";
    }
}

/**
 * Send the feedback info to Firebase
 * @author: Keshan
 */
- (IBAction)sendFeedback:(id)sender{
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://yxeats.firebaseio.com/Feedbacks"];
    ref = [ref childByAutoId];
    if (_user!=nil){
        [[ref childByAppendingPath:[NSString stringWithFormat:@"%@/%@", pickedCategory, _user.username]]setValue:[feedbackInfo text]];
    }
    else{
        [[ref childByAppendingPath:pickedCategory]setValue:[feedbackInfo text]];
    }
    
    UIAlertController *alert=  [UIAlertController
                                alertControllerWithTitle:@"Finished"
                                message:@"Thank you for your feedback. We will contact you later!"
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

@end
