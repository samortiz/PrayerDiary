//
//  NewItemViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"

@implementation NewItemViewController

@synthesize delegate;
@synthesize itemTextField;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Pop up the keyboard on loading the screen
  [self.itemTextField becomeFirstResponder];
}

- (void)viewDidUnload {
  [self setItemTextField:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Handle button actions

- (IBAction)cancel:(id)sender {
  [self.delegate newItemDidCancel:self];
}

- (IBAction)done:(id)sender {
  [self.delegate newItemDidSave:self newItem:self.itemTextField.text];
}

- (IBAction)keyboardDone:(id)sender {
  [sender resignFirstResponder];
  [self.delegate newItemDidSave:self newItem:self.itemTextField.text];
}


@end
