//
//  AdvancedSearch.m
//  YXEats
//
//  Created by Keshan Huang on 2016-03-05.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import "AdvancedSearch.h"

@interface AdvancedSearch (){
    NSArray* radiusSelection;
    UIPickerView *filtersPicker;
    UIPickerView *categoriesPicker;
    NSInteger pickerViewer;
    RMPickerViewController *pickerController1;
    RMPickerViewController *pickerController;
    NSArray* sortSelection;
    NSArray* showCategories;
}

@end

@implementation AdvancedSearch


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutSettings];
    // Do any additional setup after loading the view.
    //Create select action
}

/**
 * Button layout settings
 * @author: Kasidi
 */
-(void)layoutSettings{
    [[btnFilters layer]setBorderWidth:2.0f];
    [[btnFilters layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btnFilters layer]setCornerRadius:20.0f];
    [[btnFilters layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btnFilters layer]setShadowOpacity:1];
    [[btnFilters layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btnFilters layer]setShadowRadius:3];
    
    [[btnCategories layer]setBorderWidth:2.0f];
    [[btnCategories layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btnCategories layer]setCornerRadius:20.0f];
    [[btnCategories layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btnCategories layer]setShadowOpacity:1];
    [[btnCategories layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btnCategories layer]setShadowRadius:3];
    
    [[btnDone2 layer]setBorderWidth:2.0f];
    [[btnDone2 layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btnDone2 layer]setCornerRadius:20.0f];
    [[btnDone2 layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btnDone2 layer]setShadowOpacity:1];
    [[btnDone2 layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btnDone2 layer]setShadowRadius:3];
    
    [[btnCancel layer]setBorderWidth:2.0f];
    [[btnCancel layer]setBorderColor:[UIColor whiteColor].CGColor];
    [[btnCancel layer]setCornerRadius:20.0f];
    [[btnCancel layer]setShadowColor:[UIColor blackColor].CGColor];
    [[btnCancel layer]setShadowOpacity:1];
    [[btnCancel layer]setShadowOffset:CGSizeMake(3, 3)];
    [[btnCancel layer]setShadowRadius:3];
    
    [btnDone2 setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    /// Search radius options
    radiusSelection = @[@"500m", @"1000m", @"2000m", @"3000m", @"5000m", @"10000m"];
    /// Sort options
    sortSelection = [[NSArray alloc]initWithObjects:@"Best Matched",@"Distance", @"Rating", nil];
    /// Category parameters provided by YELP
    categories = @[@"tradamerican", @"chinese", @"vietnamese", @"italian", @"mexican", @"japanese", @"hotdogs",@"indpak", @"french",@"gluten_free", @"vegetarian", @"sushi", @"steak"];
    /// User friendly version of YELP parameters
    showCategories = [[NSArray alloc]initWithObjects:@"American(Traditional)", @"Chinese", @"Vietnamese", @"Italian", @"Mexican", @"Japanese", @"Fast Food",@"Indian", @"French",@"Gluten Free", @"Vegetarian", @"Sushi", @"Steakhouses", nil];
    /// Initializae search params
    self.searchParameters = [[NSMutableArray alloc]initWithObjects:@"1500m",@" ",@" ",@"NO",nil];
    /// Default search radius
    [radius selectRow:2 inComponent:0 animated:YES];

    /// Animation picker view for sorting selection
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    pickerViewer = 2;
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[pickerController1.picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([pickerController1.picker selectedRowInComponent:i])];
        }
        
        NSLog(@"Successfully selected rows: %@", selectedRows);
        pickerViewer = 0;
    }];
    
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
        pickerViewer = 0;
    }];
    
    /// Animation picker view for category selection
    pickerController1 = [RMPickerViewController actionControllerWithStyle:style selectAction:selectAction andCancelAction:cancelAction];
    pickerController1.picker.delegate = self;
    pickerController1.picker.dataSource = self;
    //
    RMActionControllerStyle style1 = RMActionControllerStyleWhite;
    RMAction *selectAction1 = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[pickerController.picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([pickerController.picker selectedRowInComponent:i])];
        }
        
        NSLog(@"Successfully selected rows: %@", selectedRows);
        pickerViewer = 0;
    }];
    
    
    RMAction *cancelAction1 = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Row selection was canceled");
        pickerViewer = 0;
    }];
    
    //Create picker view controller
    pickerController = [RMPickerViewController actionControllerWithStyle:style1 selectAction:selectAction1 andCancelAction:cancelAction1];
    filtersPicker = pickerController.picker;
    pickerController.picker.delegate = self;
    pickerController.picker.dataSource = self;
    
}

- (IBAction)openPickerController:(id)sender {
    //Create select action
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];

}

- (IBAction)openCategoriesController:(id)sender {
    //Now just present the picker controller using the standard iOS presentation method
    [self presentViewController:pickerController1 animated:YES completion:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == radius){
        return [radiusSelection count];
    }
    else if ([pickerView isEqual:pickerController.picker]){
        return [sortSelection count];
    }
    else{
        return [categories count];
    }
    // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == radius){
        return [radiusSelection objectAtIndex:row];
    }
    else if ([pickerView isEqual:pickerController.picker]){
        return [sortSelection objectAtIndex:row];
    }
    else{
        return [showCategories objectAtIndex:row];
    }
}

-(NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == radius){
        NSAttributedString * att = [[NSAttributedString alloc]initWithString:[radiusSelection objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return att;
    }
    return nil;
    
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == radius){
        [self.testArr replaceObjectAtIndex:0 withObject:[radiusSelection objectAtIndex:row]];
    }
    else if ([pickerView isEqual:pickerController.picker]){
        [self.testArr replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%ld", row]];
        [btnDone2 setEnabled:YES];
    }
    else{
        [self.testArr replaceObjectAtIndex:2 withObject:[categories objectAtIndex:row]];
        [btnDone2 setEnabled:YES];
    }
}

-(IBAction)doTheSearch:(id)sender{
    [ self.testArr replaceObjectAtIndex:3 withObject:@"YES"];
    [ self dismissViewControllerAnimated: YES completion: nil ];
}

-(IBAction)cancelSearch:(id)sender{
    [ self.testArr replaceObjectAtIndex:3 withObject:@"NO"];
    [ self dismissViewControllerAnimated: YES completion: nil ];
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
