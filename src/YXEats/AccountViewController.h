//
//  AccountViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-16.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myTabController.h"
#import "ChangeAccountSettings.h"
#import "User.h"

@interface AccountViewController : UIViewController{
    IBOutlet UILabel* lbl_username;
    IBOutlet UIButton* setting;
    IBOutlet UIImageView* avatar;
    IBOutlet UIButton* signUp;
    IBOutlet UIButton* settings;
}

@property (nonatomic,strong) User* myUser; /// Logined user object

@end
