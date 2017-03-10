//
//  FirstViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-12.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "FirstViewController.h"
@import CoreLocation;
#import "HomepageTableRestaurantsDetails.h"
#import <AudioToolbox/AudioServices.h>
#import "myTabController.h"
#import "PreviewDishesRankingViewController.h"

static NSString * const key       = @"AIzaSyA9ECP3ZpdbVOGyK6c98HmRqImBIUv8P1Q";

@interface FirstViewController () <GMSAutocompleteViewControllerDelegate>{
    BOOL firstLocationUpdate;
    NSDictionary* results;     // JSON string for google result
    GMSGeocoder* googleCoder;  // Google map variable
    NSMutableArray* arrResults;       // Translate the returned JSON string into an array
    NSString* placeID;         // Place id for tapped cell in top pick
    NSArray* loc;
    NSArray* searchResults;
    SearchStuff* mySearchEngine;
    NSString* myCurAdd;
    GMSCameraPosition *camera;
    BOOL isInitialzed;
    BOOL isTimeout;
    CGSize iOSDeviceScreenSize;
}

@end

@implementation FirstViewController

@synthesize topPicks;

- (void)viewDidLoad {
    
    //Decoration For Buttons
    [[btnAdvanced layer]setBorderWidth:2.0f];
    [[btnAdvanced layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btnAdvanced layer]setCornerRadius:20.0f];
    [[btnAdvanced layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btnAdvanced layer]setShadowOpacity:1];
    [[btnAdvanced layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btnAdvanced layer]setShadowRadius:3];
    
    
    
    
   // [btnDone setEnabled:NO];
  //  [btnDone setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    ///Getting the screen size of the device
    ///for use later in deciding how many table rows to use
    iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    
    /// Initialize the Google Maps
    //self.mapView.delegate = self;
    [self.mapView setMyLocationEnabled:YES];
    isInitialzed = NO;
    
    //Initialize the search bar
    [self searchBarProperties];
    self.searchBar.delegate = self;
    
    camera = [GMSCameraPosition cameraWithLatitude:52.1333
                                          longitude:-106.6833
                                               zoom:10];
    
    
    /// Start updating the user's current location
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    /// Request the authorization from the user (Location service) , if the
    /// iOS version is >= 8.0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }

    /// Refresh buttom
    refreshImg = [UIImage imageNamed:@"ic_refresh"];
    [refresh setImage:refreshImg forState:UIControlStateNormal];
    
    /// Initialize search engine
    mySearchEngine = [[SearchStuff alloc]init];
    _advanceSearch = NO;
    
    [self.locationManager startUpdatingLocation];
    
    /// UUID
    identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    /// Update the user's current location on the Google Map
    if (isInitialzed == NO){
        isInitialzed = YES;
        self.mapView = [GMSMapView mapWithFrame:self.subview.bounds camera:camera];
        self.mapView.settings.myLocationButton = YES;
        /// Make google map able to resize
        self.mapView.translatesAutoresizingMaskIntoConstraints = YES;
        [self.mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mapView.myLocationEnabled = YES;
        });
        [self.subview addSubview:self.mapView];
    }
}

/**
 * Shake for randomly pick up a restaurant for you!
 * @author: Keshan
 */
- (void) motionBegan:(UIEventSubtype)motion withEvent:(nullable UIEvent *)event{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    if (event.type == UIEventSubtypeMotionShake){
        int randomInt = arc4random_uniform(4);
        NSString* restName = [NSString stringWithFormat:@"%@", [[arrResults objectAtIndex:randomInt]valueForKey:@"name"]];
        UIAlertController *alert1=  [UIAlertController
                                     alertControllerWithTitle:@"Random selection:"
                                     message:restName
                                     preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *ok1 = [UIAlertAction
                              actionWithTitle:@"OK"
                              style: (UIAlertActionStyleDefault)
                              handler:^(UIAlertAction *action){
                                  [alert1 dismissViewControllerAnimated:YES completion:nil];
                              }];
        
        UIAlertAction *visit = [UIAlertAction
                              actionWithTitle:@"Details"
                              style: (UIAlertActionStyleDefault)
                              handler:^(UIAlertAction *action){
                                  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
                                  HomepageTableRestaurantsDetails* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetails"];
                                  NSDictionary* resultsobjectTest =[arrResults objectAtIndex:randomInt];
                                  [otherViewCon setNameOfRestaurant:[resultsobjectTest valueForKey:@"name"]];
                                  [otherViewCon setMyLocation:self.mapView.myLocation];
                                  otherViewCon.currentUser = ((myTabController*)self.tabBarController).user;
                                  if ([[resultsobjectTest valueForKey:@"vicinity"]isEqualToString:@""]){
                                      [otherViewCon setAddressofRestaurant:[[resultsobjectTest valueForKey:@"location"]valueForKey:@"display_address"]];
                                  }
                                  else{
                                      [otherViewCon setAddressofRestaurant:[resultsobjectTest valueForKey:@"vicinity"]];
                                  }
                                  
                                  [self.navigationController pushViewController:otherViewCon animated:YES];
                              }];
        
        [alert1 addAction:ok1];
        [alert1 addAction:visit];
        [self presentViewController:alert1 animated:YES completion:nil];
    }
}

/**
 * Check the user is using advance search now or not.
 * Put the searching network connection to the background thread
 * and the main UI thread will update the search result
 * on the TopPicks tableView after network returns something
 * @author: Keshan
 */
- (void)viewWillAppear:(BOOL)animated{
    isTimeout = NO;
    [btnAdvanced setEnabled:NO];
    NSTimer* timeout;
    timeout = [NSTimer scheduledTimerWithTimeInterval:10.0
                                              target:self
                                              selector:@selector(timeoutCheck:)
                                              userInfo:nil
                                              repeats:NO];
    if ([[_searchParameters objectAtIndex:3]isEqualToString:@"YES"]){
        [label_Toppicks setText:[NSString stringWithFormat:@"Search Result:"]];
        [arrResults removeAllObjects];
        [self.topPicks reloadData];
        myCurAdd = [mySearchEngine getCurrentAddress:self.mapView.myLocation];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_async(queue, ^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doAdvanceSearch];
                [self markOntheMap:loc];
                [self.topPicks reloadData];
            });
        });
        [_searchParameters replaceObjectAtIndex:3 withObject:@"NO"];
        
    }
    else{
        [label_Toppicks setText:[NSString stringWithFormat:@"Top Picks:"]];
    }
    
}

/**
 * Waiting for 10 seconds
 * If the device cannot get something from network
 * then show TimeOut or No Result at TopPicks tableCells
 * @author: Keshan
 */
-(void)timeoutCheck:(NSTimer*) t{
    if ([arrResults count] == 0){
        isTimeout = YES;
        [self.topPicks reloadData];
    }
    [t invalidate];
}

///*Function: previewingContext
//  3DTouch previewing viewer
// */
// - (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
//    
//    // check if we're not already displaying a preview controller
//    if ([self.presentedViewController isKindOfClass:[HomepageTableRestaurantsDetails class]]) {
//        return nil;
//    }
//    
//    // shallow press: return the preview controller here
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];
//    UIViewController *previewController = [storyboard instantiateViewControllerWithIdentifier:@"SmallRank"];
//     CGPoint cellPostion = [self.topPicks convertPoint:location fromView:self.view];
//     NSIndexPath* path = [self.topPicks indexPathForRowAtPoint:cellPostion];
//     if (path){
//         NSDictionary* resultsobjectTest =[arrResults objectAtIndex:path.row];
//         if ([resultsobjectTest valueForKey:@"vicinity"] == nil){
//             ((PreviewDishesRankingViewController*)previewController).restaurantID = [mySearchEngine getPlaceID:[resultsobjectTest valueForKey:@"name"] myLocation:self.mapView.myLocation address:[[[resultsobjectTest valueForKey:@"location"]valueForKey:@"address"]objectAtIndex:0]];
//         }
//         else{
//             ((PreviewDishesRankingViewController*)previewController).restaurantID = [mySearchEngine getPlaceID:[resultsobjectTest valueForKey:@"name"] myLocation:self.mapView.myLocation address:[resultsobjectTest valueForKey:@"vicinity"]];
//         }
//     }
//    return previewController;
//}


/**
 * Get the user's initial location
 * and set up a timer to periodically
 * update the top picks tableView
 * @author: Keshan
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
     CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:15];
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
            // Translate the coordination to real address and then call the Yelp API
            // to search the nearest restaurant
            NSString* fullAddress =[NSString stringWithFormat:@"%@+%@",[[[response results]objectAtIndex:0]thoroughfare], [[[response results]objectAtIndex:0]locality]];
            [self getRestaurantInfo:location fullAddress:fullAddress];
        }];
        
    }
}

/*
 * Update the top picks table when user touched refresh button
 * @author: Keshan
 */
-(IBAction)refreshTheTopPicks{
    _advanceSearch = NO;
    isTimeout = NO;
    [label_Toppicks setText:@"Top Picks: "];
    CLLocation *location = self.mapView.myLocation;
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
        [self getRestaurantInfo:location fullAddress:[NSString stringWithFormat:@"%@+%@",[[[response results]objectAtIndex:0]thoroughfare], [[[response results]objectAtIndex:0]locality]]];
    }];
}


/*
 * This function will return the information of Top 3 Restaurant
 * by using JSON string. 
 * @params: myLoc - User's current location
 * @params: myAddress - User's current address (translating from coordinates)
 * @author: Keshan
 */
-(void)getRestaurantInfo:(CLLocation*) myLoc fullAddress:(NSString*) myAddress{
    /* Block for get data from Google Map */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        results = [mySearchEngine getPlacesfromGoogle:myLoc radius:@"1000"];
        NSArray* temp = [results valueForKeyPath:@"results"];
        arrResults = [[NSMutableArray alloc]initWithArray:temp];
        loc = [[[results valueForKey:@"results"]valueForKey:@"geometry"]valueForKey:@"location"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self markOntheMap:loc];
            [self.topPicks reloadData];
        });
    });
}

/**
 * Create marker on the Google Map to demonstrate the restaurant location
 * @params: coord - Coordinates of restaurant showed on the TopPicks tableView
 * @author: Keshan
 */
-(void)markOntheMap:(NSArray*) coord{
    [self.mapView clear];
    long limit = MIN(5, [coord count]);
    if (_advanceSearch==NO){
        for (int i=0; i<limit; i++){
            CLLocationCoordinate2D position =
            CLLocationCoordinate2DMake([[[coord objectAtIndex:i]valueForKey:@"lat"]doubleValue],
                                   [[[coord objectAtIndex:i]valueForKey:@"lng"]doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            NSDictionary* resultsobject =[arrResults objectAtIndex:i];
            marker.title = resultsobject[@"name"];
            marker.map = self.mapView;
        }
    }
    else{
        for (int i=0; i<[coord count]; i++){
            CLLocationCoordinate2D position =
            CLLocationCoordinate2DMake([[[coord objectAtIndex:i]valueForKey:@"latitude"]doubleValue],
                                       [[[coord objectAtIndex:i]valueForKey:@"longitude"]doubleValue]);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            NSDictionary* resultsobject =[arrResults objectAtIndex:i];
            marker.title = resultsobject[@"name"];
            marker.map = self.mapView;
        }
    }
}

/**
 * Search bar initialization
 * @author: Keshan
 */
-(void)searchBarProperties{
    self.searchBar.placeholder = @"Find a specific restaurant";
    [self.searchBar sizeToFit];
    [self.searchBar setBarStyle:UIBarStyleDefault];
    [self.searchBar setShowsCancelButton: NO];
    self.searchDisplayController.displaysSearchBarInNavigationBar=YES;
    contentList = [[NSMutableArray alloc] init];
    filteredContentList = [[NSMutableArray alloc] init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /// Return the number of rows in the section.
    if (tableView != self.topPicks){
        if (isSearching) {
            [tableView setBackgroundColor:[UIColor orangeColor]];
            return [filteredContentList count];
        }
        else{
            return [contentList count];
        }
    }
    else{
        
        /// If the iphone device is a a 4s or smaller
        /// only show 3 rows instead of 4
        if(iOSDeviceScreenSize.height <= 480)
        {
            return 2;
        }
        else
        {
            return 6;
        }
        
    }
}


/**
 * Contents in the table cells.
 * @author: Keshan
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    // Contents of the search results
    if (tableView != self.topPicks){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor orangeColor]];
             cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        if (isSearching) {
            cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
        }
        else {
            cell.textLabel.text = [filteredContentList objectAtIndex:indexPath.row];
        }
        return cell;
    }
    // Contents in the top picks table, which are 3 top rated restaurant near the user
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor orangeColor]];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if (isTimeout == YES){
            cell.textLabel.text = @"Timeout. Check network connection";
            cell.accessoryView = nil;
            return cell;
        }
        if ([arrResults count] == 0){
            UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            spinner.frame = CGRectMake(10, 10, 24, 24);
            cell.accessoryView = spinner;
            [spinner startAnimating];
            cell.textLabel.text = @"";
            return cell;
        }
        if (indexPath.row < [arrResults count]){
            if (_advanceSearch == YES){
                NSDictionary* resultsobject =[arrResults objectAtIndex:indexPath.row];
                NSDictionary* distance = [mySearchEngine getDistance:self.mapView.myLocation lati:[[loc objectAtIndex:indexPath.row]valueForKey:@"latitude"] long:[[loc objectAtIndex:indexPath.row]valueForKey:@"longitude"]];
                cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", resultsobject[@"name"], [[distance valueForKey:@"distance"]valueForKey:@"text"]];
                [btnAdvanced setEnabled:YES];
            }
            else{
                NSDictionary* resultsobject =[arrResults objectAtIndex:indexPath.row];
                NSDictionary* distance = [mySearchEngine getDistance:self.mapView.myLocation lati:[[[resultsobject valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lat"] long:[[[resultsobject valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lng"]];
                cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", resultsobject[@"name"], [[distance valueForKey:@"distance"]valueForKey:@"text" ]];
                [btnAdvanced setEnabled:YES];
            }
        }
        else {
             cell.textLabel.text = @" ";
        }
        return cell;
    }
}

/**
 * Push to the restaurant profile viewer when user touched table cell
 * @author: Keshan, Surjit
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.topPicks){
        if ([arrResults count] == 0 || indexPath.row >= [arrResults count]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
        HomepageTableRestaurantsDetails* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetails"];
        NSDictionary* resultsobjectTest =[arrResults objectAtIndex:indexPath.row];
        otherViewCon.currentUser = ((myTabController*)self.tabBarController).user;
        [otherViewCon setNameOfRestaurant:[resultsobjectTest valueForKey:@"name"]];
        [otherViewCon setMyLocation:self.mapView.myLocation];
        NSLog(@"Reulst Object: %@", resultsobjectTest);
        NSLog(@"test: %@", [resultsobjectTest valueForKey:@"vicinity"]);
        if ([resultsobjectTest valueForKey:@"vicinity"] == nil){
            [otherViewCon setAddressofRestaurant:[[[resultsobjectTest valueForKey:@"location"]valueForKey:@"address"]objectAtIndex:0]];
        }
        else{
            [otherViewCon setAddressofRestaurant:[resultsobjectTest valueForKey:@"vicinity"]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:otherViewCon animated:YES];
        
    }
    else{
        if ([filteredContentList count] == 0 || indexPath.row >= [filteredContentList count]){
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
        HomepageTableRestaurantsDetails* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"RestaurantDetails"];
        NSDictionary* resultsobjectTest =[searchResults objectAtIndex:indexPath.row];
        otherViewCon.currentUser = ((myTabController*)self.tabBarController).user;
        [otherViewCon setNameOfRestaurant:[resultsobjectTest valueForKey:@"name"]];
        [otherViewCon setMyLocation:self.mapView.myLocation];
        if ([[resultsobjectTest valueForKey:@"vicinity"]isEqualToString:@""]){
            [otherViewCon setAddressofRestaurant:[[resultsobjectTest valueForKey:@"location"]valueForKey:@"display_address"]];
        }
        else{
            [otherViewCon setAddressofRestaurant:[resultsobjectTest valueForKey:@"vicinity"]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:otherViewCon animated:YES];
    }
}

/**
 * Show the serach bar's search result on the tableView
 * @author: Keshan
 */
- (void)searchTableList {
    for (NSString *tempStr in contentList) {
            [filteredContentList addObject:tempStr];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

/*
 * Function that makes the search bar in working order, which includes a NSTimer
 * to do the searching after user types in all the contexts. This timer will determine
 * user stopped typing by checking the input has 1.0 seconds gap.
 * @params: searchText - User typed in stuff
 * @author: Keshan
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchDelay invalidate], searchDelay = nil;
    
    if([searchText length] >= 4 ) {
        searchDelay = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(doDelayedSearch:)
                                                     userInfo:searchText
                                                      repeats:NO];
    }
    else {
        isSearching = NO;
    }
}

/**
 * Delegate function for search bar timer
 * @params: t - NSTimer from serachBar
 * @author: Keshan
 */
-(void)doDelayedSearch:(NSTimer*)t{
    NSDictionary* retDict =[self getPlacesfromGoogle1:self.mapView.myLocation keyword: [NSString stringWithFormat:(@"%@"), self.searchBar.text]];
    NSArray* retArray = [[retDict valueForKeyPath:@"results"]valueForKey:@"name"];
    NSArray* address = [[retDict valueForKeyPath:@"results"]valueForKey:@"vicinity"];
    searchResults = [retDict valueForKeyPath:@"results"];
    isSearching = YES;
    [contentList removeAllObjects];
    [filteredContentList removeAllObjects];
    [contentList addObjectsFromArray:retArray];
    for (int i = 0; i<[contentList count]; i++){
        [contentList replaceObjectAtIndex:i withObject:[[NSString stringWithFormat:@"%@ - %@", [retArray objectAtIndex:i], [address objectAtIndex:i]]stringByReplacingOccurrencesOfString:@", Saskatoon" withString:@""]];
    }
    [self searchTableList];
    searchDelay = nil;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchTableList];
}

/**
 * Get place ID by providing a specific restaurant name
 * @params: myLoc - User current location
 * @params: keyword - Restaurant's name
 * @author: Keshan
 */
-(NSDictionary*)getPlacesfromGoogle1:(CLLocation*)myLoc keyword:(NSString*)keyword{
    __block NSDictionary* retArray;
    NSDictionary* params = @{
                             @"type": @"restaurant",
                             @"name": keyword,
                             @"location":[NSString stringWithFormat:@"%g,%g", myLoc.coordinate.latitude, myLoc.coordinate.longitude],
                             @"radius": @"10000",
                             @"key": key,
                             };
    dispatch_group_t requestGroup3 = dispatch_group_create();
    dispatch_group_enter(requestGroup3);
    NSURLRequest *searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/place/nearbysearch/json" params:params];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            
            retArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            dispatch_group_leave(requestGroup3);
        }
    }] resume];
    
    dispatch_group_wait(requestGroup3, DISPATCH_TIME_FOREVER);
    
    return retArray;
}

/**
 * Push to advance search viewer
 * @author: Keshan
 */
-(IBAction)advanceSearch:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
    AdvancedSearch* searchView = [storyboard instantiateViewControllerWithIdentifier:@"advanceSearch"];
    self.searchParameters = [[NSMutableArray alloc]initWithObjects:@"1500m",@"",@"", @"NO", @"0", nil];
    searchView.testArr = self.searchParameters;
    [self presentViewController:searchView animated:YES completion:nil];
}

/**
 * Call Yelp API to do the advance search by using 
 * the parameters set by the user
 * @author: Keshan
 */
 
-(void)doAdvanceSearch{
    _advanceSearch = YES;
    results = [mySearchEngine getJsonFromYelp:[self.searchParameters objectAtIndex:1]
                                     category:[self.searchParameters objectAtIndex:2]
                                 myCurrentLoc:myCurAdd
                                  searchLimit:@"4"
                                 searchRadius:[[self.searchParameters objectAtIndex:0]stringByReplacingOccurrencesOfString:@"m" withString:@""]
                                        coord:self.mapView.myLocation
                                         sort:[self.searchParameters objectAtIndex:1]];
//    results =  [self getPlacesAdvance:self.mapView.myLocation radius:[self.searchParameters objectAtIndex:0] filters:filters categories:[self.searchParameters objectAtIndex:2]];
    NSArray* temp = results[@"businesses"];
    arrResults = [[NSMutableArray alloc]initWithArray:temp];
    loc = [[[results valueForKeyPath:@"businesses"]valueForKey:@"location"]valueForKey:@"coordinate"];
}
@end
