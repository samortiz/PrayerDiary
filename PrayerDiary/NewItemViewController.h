//
//  NewItemViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewItemViewController;

@protocol NewItemViewControllerDelegate <NSObject>
- (void) newItemDidCancel: (NewItemViewController *) controller;
- (void) newItemDidSave: (NewItemViewController *) controller newItem:(NSString *) item;
@end


@interface NewItemViewController : UITableViewController

@property (weak, nonatomic) id <NewItemViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *itemTextField;

- (IBAction) cancel:(id)sender;
- (IBAction) done:(id)sender;
- (IBAction) keyboardDone:(id)sender;

@end
