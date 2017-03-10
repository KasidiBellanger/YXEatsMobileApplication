//
//  DishDetailComments.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DishDetailComments : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableForComments;

@property (nonatomic,strong) NSDictionary* dishCommentInfo;

-(void)setDishName:(NSString*) dishName;
-(void)setRating:(NSString*) rating;

@property (strong,nonatomic) NSString* restaurantID;
@property (strong,nonatomic) User* myUser;
@property (strong,nonatomic) NSString* myDishName;
@end
