//
//  SearchStuff.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-08.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#ifndef SearchStuff_h
#define SearchStuff_h
@import GoogleMaps;
#import "NSURLRequest+OAuth.h"
#import <Firebase/Firebase.h>
#import <UIKit/UIKit.h>
#import "YPAPISample.h"

@interface SearchStuff : NSObject

-(NSDictionary*)getDistance:(CLLocation*)myLoc lati: (NSString*)destlati long: (NSString*)destlong;
-(NSDictionary*)getPlacesfromGoogle:(CLLocation*)myLoc radius:(NSString*)myRadius;
-(NSDictionary*)getJsonFromYelp:(NSString*)filter category: (NSString*)category myCurrentLoc: (NSString*)currentLocation searchLimit:
(NSString*)limit searchRadius: (NSString*)radius coord: (CLLocation*) coord sort:(NSString*) sort;
-(NSDictionary*)getPlaceDetails:(NSString*) placeID;
-(NSData*)getPlacePhotos:(NSString*) photo_reference maxHeight:(NSString*)maxHeight maxWidth:(NSString*) maxWidth;
-(NSString*)getCurrentAddress:(CLLocation*)myLoc;
-(NSString*)getPlaceID:(NSString*)name myLocation:(CLLocation*)myLocation address:(NSString*)address;
@end



#endif /* SearchStuff_h */
