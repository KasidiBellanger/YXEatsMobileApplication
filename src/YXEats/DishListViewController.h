//
//  DishListViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Firebase/Firebase.h>

@interface DishListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView* dishlist;
    IBOutlet UILabel* lbl_nocomments;
}

@property (nonatomic,strong) User* myUser; /// Logined user object

@property (nonatomic,strong) NSString* restaurantID; /// Place ID of restaurant

@property (nonatomic,strong) NSString* restuantAddress; /// Restaurant address

@end
