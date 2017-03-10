//
//  MenuSharingViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MenuSharingViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UIImageView* imageView;
    IBOutlet UIButton* btn_submit;
    IBOutlet UIButton* submit;
}

@property (nonatomic,strong) User* currentUser; /// Logined user object

@property (nonatomic,strong) NSString* restaurantID; /// Place ID of restaurant

@end
