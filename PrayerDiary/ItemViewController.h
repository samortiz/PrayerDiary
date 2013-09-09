//
//  ItemViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewItemViewController.h"
#import "PrayerButton.h"


@interface ItemViewController : UITableViewController <NewItemViewControllerDelegate, PrayerButtonDelegate>

// The name of the person these prayer items are for
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger nameIndex;
@property (assign, nonatomic) Boolean showAnswered;

@end
