//
//  HomepageTableRestaurantsDetails.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-27.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "HomepageTableRestaurantsDetails.h"
#import "NSURLRequest+OAuth.h"
#import "SearchStuff.h"
#import "DishListViewController.h"
@import GoogleMaps;
#import "Menu.h"



static NSString * const key = @"AIzaSyA9ECP3ZpdbVOGyK6c98HmRqImBIUv8P1Q";

@interface HomepageTableRestaurantsDetails (){
    NSString* restaturantNameLabelText; // text for restaturant page on top of the view
    NSDictionary* apitempResult;       // hold JSON details for restaurant
    UIActivityIndicatorView *spinner;
    SearchStuff* mySearch;
}

@end

@implementation HomepageTableRestaurantsDetails

@synthesize restName;
@synthesize restaurantName;
@synthesize nameOfRestaurant;


- (void)viewDidLoad {
    [super viewDidLoad];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.view.frame.size.height/2 - frame.size.height/2;
    spinner.frame = frame;
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [self layoutSettings];
    NSLog(@"address:%@", _addressofRestaurant);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        nameOfRestaurant = [mySearch getPlaceID:nameOfRestaurant myLocation:_myLocation address:_addressofRestaurant];
        [self callApiObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            // calling setHoursToStoreLable  to set restaurant time
            [self setHoursToStoreLable];
            
            //set name of the restaurant
            [self SetRestaurantLabelName];
            
            [self setPictures];
            [spinner stopAnimating];
            [StoreHoursLabel setText:@"Store Hours: "];
        });
    });
}

/**
 * Layout of buttons
 * @author: Kasidi
 */
-(void)layoutSettings{
    [[menu layer]setBorderWidth:2.0f];
    [[menu layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[menu layer]setCornerRadius:20.0f];
    [[menu layer]setShadowColor:[UIColor blackColor].CGColor];
    [[menu layer]setShadowOpacity:1];
    [[menu layer]setShadowOffset:CGSizeMake(3, 3)];
    [[menu layer]setShadowRadius:3];
    
    [[dish layer]setBorderWidth:2.0f];
    [[dish layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[dish layer]setCornerRadius:20.0f];
    [[dish layer]setShadowColor:[UIColor blackColor].CGColor];
    [[dish layer]setShadowOpacity:1];
    [[dish layer]setShadowOffset:CGSizeMake(3, 3)];
    [[dish layer]setShadowRadius:3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    mySearch = [[SearchStuff alloc]init];
}

/**
 * Set restaurant hours to the label: storeHours
 * @author: Surjit
 */
- (void)setHoursToStoreLable {
    NSArray* weekHoursArr = [[[apitempResult valueForKey:@"result"]valueForKey:@"opening_hours"]valueForKey:@"weekday_text"];
    //Array to format weekHoursArr in correct format to display and add all whole week to this NSString array.
    NSString* tempStr[7];
    for (int i = 0; i < 7; i++) {
        tempStr[i] = [NSString stringWithFormat:@"%@", [weekHoursArr objectAtIndex:i]];
    }

    // check iOS date and get int day of the week to get index for day in tempStr.
    // day int zero is sunday for iOS.
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int dayOfWeek = ([components weekday]);
    NSLog(@"dayofWeek: %d", dayOfWeek);
    
    // subtract 2 from dayOfweek to get right day from tempStr. as index 0 in this array is monday.
    dayOfWeek = dayOfWeek - 2;
    if (dayOfWeek == -1){
        dayOfWeek = 6;
    }
    NSLog(@"dayofWeek: %d", dayOfWeek);
    NSString* day = [NSString stringWithFormat:@"%@", [weekHoursArr objectAtIndex:(dayOfWeek)]];
    
    // here trimming the name of week eg from this Tuesday: 11:00 AM – 1:00 AM to 11:00 AM – 1:00 AM
    NSString *newString;
    if (!(day.length < 8)) {
        NSRange range = [day rangeOfString:@" "];
        newString = [day substringFromIndex:range.location];
    }else if (day){
        newString = @"no hours info available";
    }
    else{
        newString = day;
    }
   

    // finally setting the TIME to store hour lable
    self.storeHours.text = newString;
    self.storeHours.numberOfLines = 2;
}

/**
 * Set restaurant name to the label: restaurantName
 * @author: Surjit
 */
-(void)SetRestaurantLabelName {
    NSString* tempName = [[apitempResult valueForKey:@"result"]valueForKey:@"name"];
    self.restaurantName.text = tempName;
}

/**
 * Get restaurant details from Google API
 * @author: Surjit
 */
-(void)callApiObject{
    // google place api call through object to get tapped restaurant details JSON
    apitempResult = [mySearch getPlaceDetails:nameOfRestaurant];

}

/**
 * Set restaurant image to the imageview: imgForRestaurant
 * @author: Surjit
 */
-(void)setPictures{
    //NSArray* tempPlace = [[apitempResult valueForKey:@"result"]valueForKey:@"photos"];
    NSArray* tempPlace = [[[apitempResult valueForKey:@"result"]valueForKey:@"photos"]valueForKey:@"photo_reference"];
    // here is doing only one photo key Array has more in for expanding animation feature
    
    if (!tempPlace) {
        UIImage *img = [UIImage imageNamed:@"sorrynophoto.jpg"];
        self.imgForRestaurant.image = img;
        self.imgForRestaurant.layer.cornerRadius = 10.0;
        self.imgForRestaurant.clipsToBounds = YES;
    }else{
    NSString* photoRef = tempPlace[0];
    
    SearchStuff* getPhotos = [[SearchStuff alloc]init];
    NSString* imgHeight = @"300";
    NSString* imgWidth = @"400";
    
    NSData* dataFromApi = [getPhotos getPlacePhotos:photoRef maxHeight:imgHeight  maxWidth:imgWidth];
    
    UIImage *image=[UIImage imageWithData:dataFromApi];

    self.imgForRestaurant.image = image;
    self.imgForRestaurant.layer.cornerRadius = 10.0;
    self.imgForRestaurant.clipsToBounds = YES;
    }

}

/**
 * Button Action: Push to DishListView
 * @author: Keshan
 */
-(IBAction)addDishesComment:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
    DishListViewController* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"dishlist"];
    otherViewCon.restaurantID = nameOfRestaurant;
    otherViewCon.myUser = _currentUser;
    [self.navigationController pushViewController:otherViewCon animated:YES];
}

/**
 * Button Action: Push to Menu
 * @author: Keshan
 */
-(IBAction)showMenus:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
    Menu* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"menu"];
    otherViewCon.restaurantID = nameOfRestaurant;
    otherViewCon.currentUser = _currentUser;
    [self.navigationController pushViewController:otherViewCon animated:YES];
}

@end
