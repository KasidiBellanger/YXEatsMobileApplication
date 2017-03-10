//
//  DishListViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "DishListViewController.h"
#import "DishesSharingViewController.h"
#import "DishDetailComments.h"

@interface DishListViewController (){
    Firebase *ref; /// Firebase object
    __block NSDictionary* ret; /// Returned JSON string from Firebase
    BOOL existance; /// Indicator: Check the dish list of this restaurant exists or not
    __block UITextField* dishField; /// Name of the new dish
    UITableView* menuList; /// tableView of dish
}

@end

@implementation DishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// If user logined as anonymous user, he/she will not allow to leave or view comment
    if (_myUser == nil){
        UIAlertController *alert=  [UIAlertController
                                    alertControllerWithTitle:@"Warning: You are not login"
                                    message:@"Sorry~@ If you would like to review or add comment, you need to login first."
                                    preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style: (UIAlertActionStyleDefault)
                             handler:^(UIAlertAction *action){
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    // Do any additional setup after loading the view.
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [lbl_nocomments setAlpha:0];
    [dishlist setAlpha:1];
    ret = nil;
    existance = NO;
    
    /// Connect to firebase to grab dish list
    ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/Menus/%@", self.restaurantID]];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == nil){
            existance = NO;
            ret = nil;
        }
        else{
            existance = YES;
            ret = snapshot.value;
            [dishlist reloadData];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundColor:[UIColor orangeColor]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if (ret == nil){
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(10, 10, 24, 24);
        cell.accessoryView = spinner;
        [spinner startAnimating];
        cell.textLabel.text = @"";
        return cell;
    }
    if (![ret isEqual:[NSNull null]]){
        if(indexPath.row < [ret count]){
            cell.textLabel.text = [[ret allKeys]objectAtIndex:indexPath.row];
        }
        else{
            cell.textLabel.text = @" ";
        }
    }
    else{
        cell.textLabel.text = @"No result";
        [lbl_nocomments setText:@"Add The First Comment!"];
        [lbl_nocomments setAlpha:1];
        [dishlist setAlpha:0];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > [[ret allKeys]count] - 1){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];
    DishDetailComments* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"dishdetails"];
    otherViewCon.dishCommentInfo = [ret valueForKey:[NSString stringWithFormat:@"%@", [[ret allKeys]objectAtIndex:indexPath.row]]];
    otherViewCon.myUser = self.myUser;
    otherViewCon.restaurantID = self.restaurantID;
    NSLog(@"%@", [[ret allKeys]objectAtIndex:indexPath.row]);
    otherViewCon.myDishName = [[ret allKeys]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:otherViewCon animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 * Add a new dish to this restaurant and send its name to Firebase
 * @author: Keshan
 */
-(IBAction)addComments:(id)sender{
    UIAlertController *alert=  [UIAlertController
                                alertControllerWithTitle:@"Add a new dish!"
                                message:@"Please enter the name of dish here"
                                preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style: (UIAlertActionStyleDefault)
                         handler:^(UIAlertAction *action){
                             NSDictionary* creator = @{
                                                       @"creator": self.myUser.username,
                                                       @"empty" : @"YES"
                                                       };
                             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
                             /// If user entered an empty string, return directly
                             if ([[dishField text]isEqualToString:@""]){
                                 return;
                             }
                             
                             dispatch_async(queue, ^{
                                 /// Push data to Firebase
                                 [[ref childByAppendingPath:[NSString stringWithFormat:@"%@", [dishField text]]]setValue:creator];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     /// Update UI at main thread
                                     existance = YES;
                                     [dishlist setAlpha:1];
                                     [lbl_nocomments setAlpha:0];
                                     [dishlist reloadData];
                                 });
                             });
                         }];
    UIAlertAction *cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style: (UIAlertActionStyleDefault)
                         handler:^(UIAlertAction *action){
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull dishname) {
        dishname.placeholder = @"Name of dish";
        dishField = dishname;
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
