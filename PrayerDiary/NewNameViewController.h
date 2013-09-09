//
//  NewNameViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewNameViewController;

@protocol NewNameViewControllerDelegate <NSObject>
- (void) newNameDidCancel: (NewNameViewController *) controller;
- (void) newNameDidSave: (NewNameViewController *) controller newName:(NSString *) name;
@end


@interface NewNameViewController : UITableViewController

@property (weak, nonatomic) id <NewNameViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction) cancel:(id)sender;
- (IBAction) done:(id)sender;
- (IBAction) keyboardDone:(id)sender;

@end
