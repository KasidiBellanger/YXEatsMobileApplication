//
//  Menu.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface Menu : UIViewController{
    IBOutlet UILabel* lbl_nomenu;
    IBOutlet UIImageView* menuView;
}

@property (nonatomic) User* currentUser; /// Logined user object

@property (nonatomic,strong)NSString* restaurantID; /// PlaceID of restaurant

@end
