//
//  PreviewDishesRankingViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-28.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface PreviewDishesRankingViewController : UIViewController<UITableViewDelegate, UITableViewDelegate>{
    IBOutlet UITableView* topDishes;
}

@property (nonatomic,strong) NSString* restaurantID;

@property (nonatomic,strong) NSString* restuantAddress;

@end
