//
//  DetailItemViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDateAnsweredViewController.h"

@interface DetailItemViewController : UITableViewController <SetDateAnsweredDelegate, UITextViewDelegate>


@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *answeredSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *answeredDateButton;
@property (strong, nonatomic) IBOutlet UITextView *answeredCommentTextView;

@property (assign, nonatomic) NSInteger nameIndex;
@property (assign, nonatomic) NSInteger itemIndex;

@property (assign, nonatomic) Boolean showAnswered;
@property (assign, nonatomic) NSInteger origSegmentedControlIndex;

- (IBAction) done:(id)sender;
- (IBAction) doneDescriptionKeyboard:(id)sender;
- (IBAction) datesPrayedButtonClicked:(id)sender;
- (IBAction) answeredButtonClicked:(id)sender;

- (BOOL) textViewShouldEndEditing:(UITextView *)textView;

- (void) saveDescription;
- (void) saveComment;
- (void) saveTextData;
- (void) reloadItemTable;
- (void) moveItem;

@end
