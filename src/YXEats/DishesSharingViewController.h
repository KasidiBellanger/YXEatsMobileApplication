//
//  DishesSharingViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-17.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import <Firebase/Firebase.h>

@interface DishesSharingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
, UITextViewDelegate>{
    IBOutlet UIImageView* imageView;
    IBOutlet UITextField* nameofDish;
    IBOutlet UITextView* comments;
    IBOutlet UIButton* submit;
    IBOutlet UIButton* submit1;
}

@property (nonatomic) IBOutlet HCSStarRatingView* dishRating; /// Set the dish rating by stars

@property (nonatomic, strong) NSString *restaurantName; /// Place ID for the restaurant

@property (nonatomic, strong) User *currentUser; /// Logined user object

@property (nonatomic,strong) NSString* dishName; /// Name of the dish
@end
