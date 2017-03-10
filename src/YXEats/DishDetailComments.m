//
//  DishDetailComments.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-22.
//  Copyright © 2016 Surjit Singh. All rights reserved.
//

#import "DishDetailComments.h"
#import "DishesSharingViewController.h"
#import <Firebase/Firebase.h>

@interface DishDetailComments (){
    NSMutableArray* rating;
    NSMutableArray* comment;
    NSMutableArray* username;
    NSMutableArray* Photo;
}
@end

@implementation DishDetailComments

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dishNameLabel.text = self.myDishName;
    
    if (![[_dishCommentInfo valueForKey:@"empty"]isEqualToString:@"YES"]){
        rating = [[NSMutableArray alloc] init];
        comment = [[NSMutableArray alloc] init];
        username = [[NSMutableArray alloc] init];
        Photo = [[NSMutableArray alloc] init];
    
        for(id key in _dishCommentInfo){
            [rating addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"ratings"]];
            [comment addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"comments"]];
            [username addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"username"]];
            [Photo addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"photo"]];
        }
    
        //[self setDishName:@"Dish Name"];
        [self setRating:[rating objectAtIndex:0]];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    Firebase* ref = [[Firebase alloc]initWithUrl:[NSString stringWithFormat:@"https://yxeats.firebaseio.com/Menus/%@/%@", self.restaurantID, self.myDishName]];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        _dishCommentInfo = snapshot.value;
        rating = [[NSMutableArray alloc] init];
        comment = [[NSMutableArray alloc] init];
        username = [[NSMutableArray alloc] init];
        Photo = [[NSMutableArray alloc] init];
        
        NSLog(@"dishcommentinfo: %@", _dishCommentInfo);
        if (![_dishCommentInfo isEqual:[NSNull null]]){
            if (![_dishCommentInfo[@"empty"]isEqualToString:@"YES"] && !([_dishCommentInfo[@"creator"]isEqualToString:@"hello"])){
                for(id key in _dishCommentInfo){
                    [rating addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"ratings"]];
                    [comment addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"comments"]];
                    [username addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"username"]];
                    [Photo addObject: [[_dishCommentInfo objectForKey:key] valueForKey:@"photo"]];
                }
                [self setRating:[rating objectAtIndex:0]];
            }
            [self.tableForComments reloadData];
        }
        //[self setDishName:@"Dish Name"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDishName:(NSString*) dishName{
    self.dishNameLabel.text = dishName;
}

-(void)setRating:(NSString*) ratingVal{
    self.ratingLabel.text = ratingVal;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return (1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [rating count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [ tableView dequeueReusableCellWithIdentifier: @"Cell" ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor orangeColor]];
    }
    
    cell.textLabel.text = [username objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [comment objectAtIndex:indexPath.row];
    NSString *photoString = [Photo objectAtIndex:indexPath.row];
    

    NSData *data = [[NSData alloc]initWithBase64EncodedString:photoString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:data];
    cell.imageView.image = img;
    
    return (cell);
}

- (IBAction)addDishComments:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TabStory" bundle:nil];// like Main.storyboard for used "Main"
    DishesSharingViewController* otherViewCon = [storyboard instantiateViewControllerWithIdentifier:@"share"];
    otherViewCon.restaurantName = _restaurantID;
    otherViewCon.currentUser = _myUser;
    otherViewCon.dishName = self.dishNameLabel.text;
    [self.navigationController pushViewController:otherViewCon animated:YES];
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
