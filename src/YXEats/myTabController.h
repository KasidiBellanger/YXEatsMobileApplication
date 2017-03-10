//
//  myTabController.h
//  YXEats
//
//  Created by Keshan Huang on 2016-02-21.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "User.h"
#import "AccountViewController.h"

@interface myTabController : UITabBarController

@property (nonatomic) User *user;

@end
