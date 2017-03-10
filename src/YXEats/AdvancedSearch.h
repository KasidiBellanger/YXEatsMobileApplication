//
//  AdvancedSearch.h
//  YXEats
//
//  Created by Keshan Huang on 2016-03-05.
//  Copyright © 2016 Keshan Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "RMPickerViewController.h"

@interface AdvancedSearch : UIViewController < UIPickerViewDelegate,UIPickerViewDataSource>{
    NSArray* categories;
    NSArray* filters;
//    DropDownListView * Dropobj;
    IBOutlet UIPickerView* radius;
    IBOutlet UIButton* btnFilters;
    IBOutlet UIButton* btnCategories;
    IBOutlet UIButton* btnDone2;
     IBOutlet UIButton* btnDone;
    IBOutlet UIButton* btnCancel;
}

@property (strong, nonatomic) IBOutlet UILabel *selectedFilters;

@property (strong, nonatomic) IBOutlet UILabel *selectedCategories;

@property (strong,nonatomic) NSMutableArray* testArr;

@property (strong, nonatomic) NSMutableArray* searchParameters;


//- (IBAction)filtersPressed:(id)sender;
//
//- (IBAction)categoriesPressed:(id)sender;

@end
