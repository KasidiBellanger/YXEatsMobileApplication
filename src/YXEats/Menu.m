//
//  Menu.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "Menu.h"
#import <Firebase/Firebase.h>
#import "MenuSharingViewController.h"


@implementation Menu{
    Firebase* ref; /// Firebase object
    __block NSDictionary* ret;  /// JSON string returned from firebase
    NSMutableArray* photoarray; /// Menu photos array
    UIActivityIndicatorView* spinner; /// Loading spinner
    NSInteger count; /// Photo counts
    BOOL next; /// Indicate that next photo is available
    BOOL previous; /// Indicate that previous photo is available
}

- (void) viewDidLoad {
    [super viewDidLoad];
    previous = NO;
    if([photoarray isEqual:[NSNull null]]){
        next = NO;
        lbl_nomenu.alpha = 1;
    }

}

- (void) didReceiveMemoryWarning {
    
}

- (void) viewWillAppear:(BOOL)animated{
    /// Initialize loading spinner
    [super viewWillAppear:YES];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    count = 0;
    [lbl_nomenu setAlpha:0];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.view.frame.size.height/2 - frame.size.height/2;
    spinner.frame = frame;
    spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    /// End of initialization of loading spinner
    
    /// Create swipe gestures (left and right)
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImageLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeImageRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeLeft];
    
    /// End of create swipe gestures
    
    /// Get menu photos from firebase
    ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/MenuPhotos/%@", self.restaurantID]];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if ([snapshot.value isEqual:[NSNull null]]){
            ret = nil;
            next = NO;
            lbl_nomenu.alpha = 1;
            [spinner stopAnimating];
        }
        else{
            ret = snapshot.value;
            photoarray = [[NSMutableArray alloc]init];
            for (id key in ret){
                NSString* tempStr = [ret valueForKey:key][@"photo"];
                [photoarray addObject:[[NSData alloc]initWithBase64EncodedString:tempStr options:NSDataBase64DecodingIgnoreUnknownCharacters]];
            }
            [spinner stopAnimating];
            if (count < [photoarray count] - 1){
                next = YES;
            }
            else{
                next = NO;
            }
            
            [menuView setImage:[UIImage imageWithData:[photoarray objectAtIndex:0]]];
            
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    /// End of get menu photos from firebase
}

/**
 * Push to MenuSharing (add menu photo)
 * @author: Keshan
 */
-(IBAction)AddMenu:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];
    MenuSharingViewController* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"addmenu"];
    otherViewCon.currentUser = self.currentUser;
    otherViewCon.restaurantID = self.restaurantID;
    [self.navigationController pushViewController:otherViewCon animated:YES];
}

/**
 * Detect for left swipe on menu image view
 * @author: Keshan
 */
- (void)swipeImageLeft:(UISwipeGestureRecognizer *)gesture {
    if (next==YES){
        [self nextClicked];
    }
}

/**
 * Detect for right swipe on menu image view
 * @author: Keshan
 */
- (void)swipeImageRight:(UISwipeGestureRecognizer *)gesture {
    if (previous==YES){
        [self previousClicked];
    }
}

/**
 * Handle left swipe
 * @author: Keshan
 */
-(void)previousClicked{
    count--;
    menuView.image = [UIImage imageWithData:[photoarray objectAtIndex:count]];
    if (count == 0){
        previous = NO;
    }
    next = YES;
}

/**
 * Handle right swipe
 * @author: Keshan
 */
-(void)nextClicked{
    count++;
    menuView.image = [UIImage imageWithData:[photoarray objectAtIndex:count]];
    if (count == [photoarray count] - 1){
        next = NO;
    }
    previous = YES;
}
@end
