//
//  SearchStuff.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-08.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchStuff.h"

@interface SearchStuff()

@end

@implementation SearchStuff

/// API key for Google Map API
static NSString * const key       = @"AIzaSyA9ECP3ZpdbVOGyK6c98HmRqImBIUv8P1Q";

/**
 * Searching implementation function
 * @params: requestCategory - Which API you want to call
 * @params: parameters - parameters in the HTTP get method
 * @author: Keshan
 */
-(NSDictionary*)networkConnection:(NSString*)requestCategory parameters: (NSDictionary*)parameters{
    __block NSDictionary* returnStuff;
    NSURLRequest *searchRequest;
    
    NSArray* reqCategory = @[@"getPlacesfromGoogle",@"getJsonFromYelp",@"getDistance",@"getPlaceDetails", @"getCurrentAddress"];
    NSUInteger reqItem = [reqCategory indexOfObject:requestCategory];
    switch (reqItem){
        case 0:{
            searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/place/nearbysearch/json" params:parameters];
            break;
        }
        case 1:{
            searchRequest = [NSURLRequest requestWithHost: @"api.yelp.com" path:@"/v2/search/" params:parameters];
            break;
        }
        case 2:{
            searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/distancematrix/json" params:parameters];
            break;
        }
        case 3:{
            searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/place/details/json" params:parameters];
            break;
        }
        case 4:{
            searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/geocode/json" params:parameters];
            break;
        }
        default:{
            break;
        }
    }
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_group_t requestGroup = dispatch_group_create();
    dispatch_group_enter(requestGroup);
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            
            returnStuff = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            //businessArray = searchResponseJSON[@"businesses"];
            dispatch_group_leave(requestGroup);
        }
    }] resume];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
    
    switch(reqItem){
        case 0:{
            break;
        }
        case 1:{
            break;
        }
        case 2:{
            NSMutableArray* arrInApp = [returnStuff objectForKey:@"rows"];
            returnStuff = [arrInApp objectAtIndex:0];
            arrInApp = [returnStuff objectForKey:@"elements"];
            returnStuff = [arrInApp objectAtIndex:0];
            break;
        }
        case 3:{
            break;
        }
        case 4:{
            returnStuff = [returnStuff valueForKeyPath:@"results"];
            break;
        }
        default:{
            break;
        }
    }
    return returnStuff;
}

/**
 * YELP search API parameters generator
 * @author: Keshan
 */
-(NSDictionary*)getJsonFromYelp:(NSString*)filter category: (NSString*)category myCurrentLoc: (NSString*)currentLocation searchLimit:
(NSString*)limit searchRadius: (NSString*)radius coord: (CLLocation*) coord sort:(NSString*) sort
{
    NSDictionary *params;
    if ([sort isEqualToString:@""]){
        params = @{
                   @"category_filter":category,
                   @"location": currentLocation,
                   @"cll":[NSString stringWithFormat:@"%g,%g", coord.coordinate.latitude, coord.coordinate.longitude],
                   @"limit": limit,
                   @"radius_filter": radius,
                   @"cc": @"CA",
                   };
    }
    else
    {
        params = @{
                   @"sort": sort,
                   @"category_filter":category,
                   @"location": currentLocation,
                   @"cll":[NSString stringWithFormat:@"%g,%g", coord.coordinate.latitude, coord.coordinate.longitude],
                   @"limit": limit,
                   @"radius_filter": radius,
                   @"cc": @"CA",
                   };
    }
    return [self networkConnection:@"getJsonFromYelp" parameters:params];
}

/**
 * Get place ID from Google Map API
 * @author: Keshan
 */
-(NSDictionary*)getPlacesfromGoogle:(CLLocation*)myLoc radius:(NSString*)myRadius{
    NSDictionary* params = @{
                             @"keyword": @"Restaurant",
                             @"location":[NSString stringWithFormat:@"%g,%g", myLoc.coordinate.latitude, myLoc.coordinate.longitude],
                             @"radius": myRadius,
                             @"key": key,
                             };
    return [self networkConnection:@"getPlacesfromGoogle" parameters:params];
}

/**
 * Get the distance between user current location and the desti restaurant
 * @author: Keshan
 */
-(NSDictionary*)getDistance:(CLLocation*)myLoc lati: (NSString*)destlati long: (NSString*)destlong{
    NSDictionary* params = @{
                             @"origins": [NSString stringWithFormat:@"%g,%g", myLoc.coordinate.latitude, myLoc.coordinate.longitude],
                             @"destinations":[NSString stringWithFormat:@"%g,%g", [destlati doubleValue], [destlong doubleValue]],
                             @"key": key,
                             };
    return [self networkConnection:@"getDistance" parameters:params];
}

/**
 * Get restaurant's hours, images, address, and so on from Google Map
 * @author: Keshan
 */
-(NSDictionary*)getPlaceDetails:(NSString*) placeID{
    NSDictionary* params = @{
                             @"placeid": placeID,
                             @"key": key,
                             };
    return [self networkConnection:@"getPlaceDetails" parameters:params];
}

/**
 * Get the user current address (translating from coordinates provided by CLLocation)
 * @author: Keshan
 */
-(NSString*)getCurrentAddress:(CLLocation*)myLoc{
    NSDictionary* params = @{
                             @"latlng": [NSString stringWithFormat:@"%g,%g", myLoc.coordinate.latitude, myLoc.coordinate.longitude],
                             @"key": key,
                             };
    NSArray* retArr = [[self networkConnection:@"getCurrentAddress" parameters:params]valueForKey:@"formatted_address"];
    NSString* ret = [retArr objectAtIndex:0];
    return ret;
}

/**
 * Get restaurant Place ID from Google Map API
 * @author: Keshan
 */
-(NSString*)getPlaceID:(NSString*)name myLocation:(CLLocation*)myLocation address:(NSString*)address {
    NSDictionary* params = @{
                             @"name": name,
                             @"location":[NSString stringWithFormat:@"%g,%g", myLocation.coordinate.latitude, myLocation.coordinate.longitude],
                             @"radius": @"30000",
                             @"keyword": address,
                             @"key": key,
                             };
    NSDictionary* ret = [self networkConnection:@"getPlacesfromGoogle" parameters:params];
    if (ret != nil){
        return [[[ret valueForKeyPath:@"results"]valueForKey:@"place_id"]objectAtIndex:0];
    }
    else{
        return @"not found";
    }
}

/**
 * Get restaurant images provided by Google Map
 * @author: Keshan
 */
-(NSData*)getPlacePhotos:(NSString*) photo_reference maxHeight:(NSString*)maxHeight maxWidth:(NSString*) maxWidth{
    __block NSData* retArray;
    NSDictionary* params = @{
                             @"photo_reference": photo_reference,
                             @"maxwidth": maxWidth,
                             @"maxheight": maxHeight,
                             @"key": key,
                             };
    
    dispatch_group_t requestGroup3 = dispatch_group_create();
    dispatch_group_enter(requestGroup3);
    NSURLRequest *searchRequest = [NSURLRequest requestWithHost: @"maps.googleapis.com" path:@"/maps/api/place/photo" params:params];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            
            retArray = data;
            dispatch_group_leave(requestGroup3);
        }
    }] resume];
    dispatch_group_wait(requestGroup3, DISPATCH_TIME_FOREVER);
    return retArray;
}

@end