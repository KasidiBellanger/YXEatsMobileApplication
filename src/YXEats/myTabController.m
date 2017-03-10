//
//  myTabController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-21.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "myTabController.h"


@interface myTabController()

@end

@implementation myTabController

- (void)viewDidLoad {
    ((SecondViewController*)[[self viewControllers]objectAtIndex:1]).user = _user;
    ((AccountViewController*)[[self viewControllers]objectAtIndex:2]).myUser = _user;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
