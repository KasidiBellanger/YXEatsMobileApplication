//
//  SecondViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-01.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Firebase/Firebase.h>

@interface SecondViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>{
    IBOutlet UIButton* send;
}

@property (nonatomic) User *user; /// Logined user object

@end
