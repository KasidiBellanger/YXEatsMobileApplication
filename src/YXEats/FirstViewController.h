//
//  FirstViewController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-12.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPAPISample.h"
@import GoogleMaps;
#import "NSURLRequest+OAuth.h"
#import <Firebase/Firebase.h>
#import "AdvancedSearch.h"
#import "SearchStuff.h"
#import "User.h"

@interface FirstViewController : UIViewController <GMSMapViewDelegate,UITableViewDelegate, UITableViewDataSource,
UISearchBarDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate>{
    NSMutableArray *contentList;     // will be deleted in a moment
    NSMutableArray *filteredContentList;  /// search result array
    BOOL isSearching;               /// indicate that the user is searching
    NSTimer* searchDelay;           /// timer for detect the user input is ended
    IBOutlet UIButton* refresh;     /// refresh the top picks results
    UIImage* refreshImg;
    NSString* identifier;           /// Device Identifier
    IBOutlet UILabel* label_Toppicks;
    IBOutlet UIButton* btnAdvanced;
}

@property (nonatomic, strong) IBOutlet GMSMapView *mapView; /// Google Map Controller

@property (strong, nonatomic) IBOutlet UIView *subview;  /// Google Map subview

@property IBOutlet UISearchBar* searchBar;  /// SearchBar for "find a particular restaurant"

@property (nonatomic,retain) CLLocationManager *locationManager;  /// Managing the user location

@property (nonatomic,retain) IBOutlet UITableView *topPicks;  /// Top picks table view

@property (nonatomic,strong) NSMutableArray* searchParameters; /// Advance search parameters

@property (nonatomic) BOOL advanceSearch; /// Indicator for advance search

@property (nonatomic,strong) User* myUser; /// Logined user object

@end

