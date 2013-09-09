//
//  NewNameViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewNameViewController.h"

@implementation NewNameViewController

@synthesize delegate;
@synthesize nameTextField;


- (void)viewDidLoad {
  [super viewDidLoad];
  // Pop up the keyboard on loading the screen
  [self.nameTextField becomeFirstResponder];
}

- (void)viewDidUnload {
  [self setNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// ---- Delegate -----

- (IBAction)cancel:(id)sender {
  [self.delegate newNameDidCancel:self];
}

- (IBAction)done:(id)sender {
  [self.delegate newNameDidSave:self newName:self.nameTextField.text];
}

- (IBAction)keyboardDone:(id)sender {
  [sender resignFirstResponder];
  [self.delegate newNameDidSave:self newName:self.nameTextField.text];
}


@end
