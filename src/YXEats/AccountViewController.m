//
//  AccountViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-16.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "AccountViewController.h"
#import "FirstViewController.h"

@implementation AccountViewController{
    Firebase* ref;  /// Firebase communication object
    __block NSDictionary* ret;  /// Returned JSON string from Firebase
    NSData* photoData; /// Binary photo data (JPEG)
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [setting setEnabled:NO];
    [self layoutSettings];
    if (((myTabController*)self.tabBarController).user != nil){
        lbl_username.text = ((myTabController*)self.tabBarController).user.username;
        [signUp setAlpha:0];
    }
    else{
        lbl_username.text = @"You are not Login!";
        [setting setAlpha:0];
        lbl_username.textColor = [UIColor redColor];
    }
}

/**
 * Button layout settings
 * @author: Kasidi
 */
- (void)layoutSettings{
    [[signUp layer]setBorderWidth:2.0f];
    [[signUp layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[signUp layer]setCornerRadius:20.0f];
    [[signUp layer]setShadowColor:[UIColor blackColor].CGColor];
    [[signUp layer]setShadowOpacity:1];
    [[signUp layer]setShadowOffset:CGSizeMake(3, 3)];
    [[signUp layer]setShadowRadius:3];
    
    [[settings layer]setBorderWidth:2.0f];
    [[settings layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[settings layer]setCornerRadius:20.0f];
    [[settings layer]setShadowColor:[UIColor blackColor].CGColor];
    [[settings layer]setShadowOpacity:1];
    [[settings layer]setShadowOffset:CGSizeMake(3, 3)];
    [[settings layer]setShadowRadius:3];
}
-(void)didReceiveMemoryWarning{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    /// Get user's avatar from firebase
    ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/Avatars/%@", self.myUser.username]];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value isEqual:[NSNull null]]){
            ret = nil;
            [avatar setImage:[UIImage imageNamed:@"anonymous"]];
        }
        else{
            ret = snapshot.value;
            photoData = [[NSData alloc]initWithBase64EncodedString:[ret valueForKey:@"photo"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [avatar setImage:[UIImage imageWithData:photoData]];
        }
        [setting setEnabled:YES];
    }];
}

/**
 * Push to ChangeAccountsettings
 * Users can change their password and avartar
 * @author: Keshan
 */
-(IBAction)settingsClicked:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AccountSettings" bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Settings"];
    ((ChangeAccountSettings*)vc).myUser = self.myUser;
    ((ChangeAccountSettings*)vc).cur_avatar = [UIImage imageWithData:photoData];
    [self presentViewController:vc animated:YES completion:nil];
}

/**
 * If the user logined as anonymous, he/she can back to login screen
 * and log in with a specific user or signup a new one
 * @author: Keshan
 */
-(IBAction)signUpClicked:(id)sender{
    FirstViewController *temp = ((FirstViewController*)[[[[self.tabBarController viewControllers]objectAtIndex:0]viewControllers]objectAtIndex:0]);
    [temp.mapView removeObserver:temp forKeyPath:@"myLocation"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
