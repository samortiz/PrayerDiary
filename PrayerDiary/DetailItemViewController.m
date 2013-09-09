//
//  DetailItemViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailItemViewController.h"
#import "DataManager.h"
#import "CalendarViewController.h"
#import "ItemViewController.h"
#import "SetDateAnsweredViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DetailItemViewController

@synthesize descriptionTextField;
@synthesize answeredSegmentedControl;
@synthesize answeredDateButton;
@synthesize answeredCommentTextView;

@synthesize nameIndex;
@synthesize itemIndex;

@synthesize showAnswered;
@synthesize origSegmentedControlIndex;


// For formatting the setAnsweredDateButton text
NSDateFormatter *dateFormatter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

  // Format for answeredDate button
  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MMM dd, yyyy"];

  // Lookup the data
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];

  // Set the data values in the UI objects
  NSString *description = [itemDic objectForKey:@"description"];
  if (description == nil) description = @"";
  self.descriptionTextField.text = description;
  
  NSString *answered = [itemDic objectForKey:@"answered"];
  NSInteger answeredSegmentIndex = 0;
  if ([answered isEqualToString:@"Yes"]) {
    answeredSegmentIndex = 1;
  } else if ([answered isEqualToString:@"No"]) {
    answeredSegmentIndex = 2;
  }
  self.answeredSegmentedControl.selectedSegmentIndex = answeredSegmentIndex;
  self.origSegmentedControlIndex = answeredSegmentIndex;
  
  NSDate *answeredDate = [itemDic objectForKey:@"answered_date"];
  NSString *answeredDateString = (answeredDate == nil) ? @"Set Date Answered" : @"Change Date Answered";
  [self.answeredDateButton setTitle:answeredDateString forState:UIControlStateNormal];
  [self.answeredDateButton.titleLabel setTextAlignment:UITextAlignmentCenter];
  
  NSString *answeredComment = [itemDic objectForKey:@"answered_comment"];
  if (answeredComment == nil) answeredComment = @"";
  self.answeredCommentTextView.text = answeredComment;
  
  self.answeredCommentTextView.layer.borderWidth = 1.0f;
  self.answeredCommentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
  self.answeredCommentTextView.layer.cornerRadius = 5;
  self.answeredCommentTextView.clipsToBounds = YES;
  
}

- (void)viewDidUnload
{
  [self setDescriptionTextField:nil];
  [self setAnsweredDateButton:nil];
  [self setAnsweredSegmentedControl:nil];
  [self setAnsweredCommentTextView:nil];
  [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
    // Back button was pressed (self is no longer on the nav stack)
    [self saveTextData];
    // move to/from answered/unanswered as needed
    [self moveItem]; 
    [self reloadItemTable];
  }
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Event Handling for Buttons

- (IBAction) done:(id)sender {
  // The data should already be saved (when changed)
  //[self saveTextData];
  
  UINavigationController *nav = self.navigationController;
  [nav popViewControllerAnimated:YES];

  [self reloadItemTable];
}


- (IBAction) doneDescriptionKeyboard:(id)sender {
  [self saveDescription];
  [sender resignFirstResponder];
}



- (BOOL) textViewShouldEndEditing:(UITextView *)textView {
  [self saveComment];
  [self.answeredCommentTextView resignFirstResponder];
  return YES;
}


- (IBAction) answeredButtonClicked:(id)sender {
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];
  
  NSString *answered = @"?";
  NSInteger answeredIndex = answeredSegmentedControl.selectedSegmentIndex;
  if (answeredIndex == 1) {
    answered = @"Yes";
  } else if (answeredIndex == 2) {
    answered = @"No";
  }
  // Store the new answer
  [itemDic setObject:answered forKey:@"answered"];
  
  // Set the answered date 
  if (answeredIndex == 0) {
    [self setDateAnswered:nil];
  } else {
    NSDate *answeredDate = [itemDic objectForKey:@"answered_date"];
    if (answeredDate == nil) {
      [self setDateAnswered:[NSDate date]];
    }
  }
  
}


- (IBAction) datesPrayedButtonClicked:(id)sender {
  // Display the calendar
  CalendarViewController *cal = [[CalendarViewController alloc] init];
  cal.nameIndex = self.nameIndex;
  cal.itemIndex = self.itemIndex;
  cal.showAnswered = self.showAnswered;
  [self.navigationController pushViewController:cal animated:YES];
}



#pragma mark - SetDateAnsweredDelegate

- (void) setDateAnswered:(NSDate *)answeredDate {
  // Update the stored data
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:self.nameIndex itemIndex:self.itemIndex showAnswered:self.showAnswered];
  if (answeredDate != nil) {
    [itemDic setObject:answeredDate forKey:@"answered_date"];
  } else {
    [itemDic removeObjectForKey:@"answered_date"];
  }
  
  [self.answeredDateButton setTitle:@"Change Date Answered" forState:UIControlStateNormal];

  [self.tableView reloadData]; // Force the table to redraw so the section title will change
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return nil;
  } else if (section == 1) {
    // Check to see if it is answered
    NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:self.nameIndex itemIndex:self.itemIndex showAnswered:self.showAnswered];
    NSDate *answeredDate = [itemDic objectForKey:@"answered_date"];
    if (answeredDate == nil) {
      return @"Answered";
    }
    return [NSString stringWithFormat:@"Answered on %@",[dateFormatter stringFromDate:answeredDate]];  
  }
  return @"Unknown Section";
}


// Before we transition to another screen 
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"SetDateAnsweredSegue"] || [segue.identifier isEqualToString:@"AnsweredSetDateAnsweredSegue"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    SetDateAnsweredViewController *setDateAnsweredViewController = [[navigationController viewControllers] objectAtIndex:0];
    // Assign delegate so SetDateAnsweredController can call back to this class when done, using the setDateAnswered function
    setDateAnsweredViewController.delegate = self;
  } 
}


#pragma mark - Misc 

- (void) saveDescription {
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];
  
  NSString *descriptionStr = descriptionTextField.text;
  if (descriptionStr == nil) descriptionStr = @"";
  [itemDic setObject:descriptionStr forKey:@"description"];
}

- (void) saveComment {
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];
  
  NSString *answeredCommentStr = answeredCommentTextView.text;
  if (answeredCommentStr == nil) answeredCommentStr = @"";
  [itemDic setObject:answeredCommentStr forKey:@"answered_comment"];
}

- (void) saveTextData {
  [self saveDescription];
  [self saveComment];
}


- (void) reloadItemTable {
  // Seems like there is probably a nicer way to do this, it's a bit dirty
  // This will update the parent view (ItemViewController) to reload it's data
  // because the item text may have changed. 
  // I suppose I could use a delegate...
  UINavigationController *nav = self.navigationController;
  for (UIViewController *vc in nav.viewControllers) {
    if ([vc isKindOfClass:[ItemViewController class]]) {
      ItemViewController *itemViewController = (ItemViewController *)vc;
      [itemViewController.tableView reloadData];
    }
  } // for
  
}


// Moves the item to or from the answered/unanswered lists as needed
// This will only move the item if the final changed value is significantly different from the original
- (void) moveItem {
  NSInteger newIndex = self.answeredSegmentedControl.selectedSegmentIndex;
  NSInteger oldIndex = self.origSegmentedControlIndex;
  NSMutableDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];
  
  // If anything changed, and if the change was from/to 0 (unanswered state)
  if ((newIndex != oldIndex) && ((newIndex == 0) || (oldIndex == 0))) {
    NSString *name = [DataManager getNameAtIndex:nameIndex showAnswered:self.showAnswered];
    
    NSInteger unansweredNameIndex = [DataManager getOrCreateIndexForName:name showAnswered:NO];
    NSMutableArray *unansweredItems = [DataManager getItemsAtIndex:unansweredNameIndex showAnswered:NO];

    NSInteger answeredNameIndex = [DataManager getOrCreateIndexForName:name showAnswered:YES];
    NSMutableArray *answeredItems = [DataManager getItemsAtIndex:answeredNameIndex showAnswered:YES];

    if ((newIndex != 0) && (oldIndex == 0)) {
      // We are changing from unanswered to answered (Hallelujah!)
      [unansweredItems removeObject:itemDic];
      [answeredItems insertObject:itemDic atIndex:0];
      self.showAnswered = YES; // the item we are currently on is under the other tab now!
      NSLog(@"answered item for %@", name);
      
    } else if ((newIndex == 0) && (oldIndex != 0)) {
      // We are changing from answered to unanswered (a mistake maybe)
      [answeredItems removeObject:itemDic];
      [unansweredItems insertObject:itemDic atIndex:0];
      self.showAnswered = NO; // The item we are currently on is under the other tab now!
      NSLog(@"unanswered item for %@", name);
    }
  }
  
  
}


@end
