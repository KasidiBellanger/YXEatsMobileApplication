//
//  PreviewDishesRankingViewController.m
//  YXEats
//
//  Created by Keshan Huang on 2016-02-28.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "PreviewDishesRankingViewController.h"
#import <Firebase/Firebase.h>

@interface PreviewDishesRankingViewController (){
    
}

@end

@implementation PreviewDishesRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://dinosaur-facts.firebaseio.com/dinosaurs"];
    [[ref queryOrderedByChild:[NSString stringWithFormat:@"/Menus/%@", self.restaurantID]]
     observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
         
         NSLog(@"%@ was %@ meters tall", snapshot.key, snapshot.value[@"height"]);
     }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    // Contents of the search results
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setBackgroundColor:[UIColor orangeColor]];
            cell.textLabel.textColor = [UIColor whiteColor];
        }

    return cell;
}
    
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Share the list to Facebook" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
        FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
        button.shareContent = content;
        [self.view addSubview:button];
        
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Share your favourite dishes" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Add comments");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1,action2];
//    
//    // add all actions to a group
//    UIPreviewActionGroup *group1 = [UIPreviewActionGroup actionGroupWithTitle:@"Action Group" style:UIPreviewActionStyleDefault actions:actions];
//    NSArray *group = @[group1];
    
    // and return them (return the array of actions instead to see all items ungrouped)
    return actions;
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
