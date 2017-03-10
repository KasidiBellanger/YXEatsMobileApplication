//
//  HomepageTableRestaurantsDetails.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-27.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "DishesSharingViewController.h"

@interface HomepageTableRestaurantsDetails : UIViewController{
    IBOutlet UILabel* StoreHoursLabel;
    IBOutlet UIButton* dish;
    IBOutlet UIButton* menu;
}

@property (nonatomic,strong) IBOutlet UILabel* restaurantName; /// IBOutlet: label for restaurant name
@property (nonatomic,strong) NSString* restName;    /// Restaurant name
@property (nonatomic,strong) NSString* nameOfRestaurant;  /// Google Place ID of restaurant

@property (weak, nonatomic) IBOutlet UILabel *storeHours;  /// IBOutlet: restaurant hours

@property IBOutlet UIButton* addDishComments;

/**
 * Set restaurant hours to the label: storeHours
 * @author: Surjit
 */
- (void)setHoursToStoreLable;

/**
 * Set restaurant name to the label: restaurantName
 * @author: Surjit
 */
-(void)SetRestaurantLabelName;

@property (weak, nonatomic) IBOutlet UIImageView *imgForRestaurant; /// IBOutlet: imageview for restaurant

@property (nonatomic,strong) CLLocation* myLocation; /// My current location
@property (nonatomic,strong) NSString* addressofRestaurant;  /// Address of restaurant
@property (nonatomic, strong) User *currentUser;  /// Logined user object

@end
