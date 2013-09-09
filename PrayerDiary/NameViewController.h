//
//  NameViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewNameViewController.h"
#import "ItemViewController.h"
#import "NewItemViewController.h"

@interface NameViewController : UITableViewController <NewNameViewControllerDelegate, UITextFieldDelegate>

@property (assign, nonatomic) Boolean showAnswered;

@end
