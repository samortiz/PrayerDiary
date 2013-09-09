//
//  NameViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NameViewController.h"
#import "DataManager.h"

@implementation NameViewController

@synthesize showAnswered;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

  // --- View setup ---
  // Programmatically add the edit button as the storyboard doesn't do it right
  if (!self.showAnswered) {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
    [names removeObjectAtIndex:indexPath.row];
    // Update the UI
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  // Update the data model
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
  NSObject *nameObj = [names objectAtIndex:fromIndexPath.row];
  [names removeObjectAtIndex:fromIndexPath.row];
  [names insertObject:nameObj atIndex:toIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [self.tableView reloadData];
  [super setEditing:editing animated:animated];
}


// Need to implement these, or else swipe editing won't work -very strangely
- (void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - NewNameDelegate

- (void) newNameDidCancel: (NewNameViewController *) controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) newNameDidSave: (NewNameViewController *) controller newName:(NSString *)name {
  // Remove the modal NewNameViewController 
  [self dismissViewControllerAnimated:YES completion:nil];
  // Trim whitespace from the name
  NSString *newName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  // Save the name if there is one
  if (newName.length > 0) {
    // Store the new name in the data structure
    [DataManager getOrCreateIndexForName:newName showAnswered:self.showAnswered];
  
    // Update the View
    NSMutableArray *names = [DataManager getNamesShowAnswered:self.showAnswered];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([names count] -1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

// Before we transition to another screen
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"NewNameSegue"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    NewNameViewController *newNameViewController = [[navigationController viewControllers] objectAtIndex:0];
     // Assign delegate so NewNameViwController can call back to this class when done (using the NewNameViewControllerDelegate protocol)
    newNameViewController.delegate = self;

  } else if ([segue.identifier isEqualToString:@"NamesToItemsSegue"] || 
             [segue.identifier isEqualToString:@"AnsweredNamesToItemsSegue"]) {
    // Get the items for the selected row
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSString *name = [DataManager getNameAtIndex:path.row showAnswered:showAnswered];
    
    // Pass the data for the selected row to the destination ItemViewController
    ItemViewController *itemViewController = segue.destinationViewController;
    itemViewController.name = name;
    itemViewController.nameIndex = path.row;
    itemViewController.showAnswered = self.showAnswered;
    
 }
}



#pragma mark - UITextFieldDelegate 
// These methods are used when editing the name in edit mode

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField canResignFirstResponder]) {
    [textField resignFirstResponder];
  }
  return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
  return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
  // Save the edited name
  UIView *contentView = textField.superview;
  NSInteger nameIndex = contentView.tag;
  [DataManager setNameAtIndex:nameIndex name:textField.text showAnswered:self.showAnswered];
  
  [self.tableView reloadData];
}



#pragma mark - Populate the table view with data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
  return [names count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return nil;
}

// This number needs to be bigger than the number of rows in the names table or it will interfere with the lookup of row index
#define TEXTFIELD_TAG 144000

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier;
  cellIdentifier = (self.editing) ? @"nameEditCell" : @"nameCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (self.editing) {
      CGRect f = cell.contentView.frame;
      CGRect textFieldFrame = CGRectMake(f.origin.x+10, f.origin.y+4, f.size.width-84, f.size.height-8);
      UITextField *myTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
      myTextField.adjustsFontSizeToFitWidth = NO;
      myTextField.opaque = YES;
      myTextField.backgroundColor = [UIColor clearColor];
      myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
      myTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
      myTextField.textAlignment = UITextAlignmentLeft;
      myTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      myTextField.keyboardType = UIKeyboardTypeAlphabet;
      myTextField.returnKeyType = UIReturnKeyDefault;
      myTextField.clearButtonMode = UITextFieldViewModeNever;
      myTextField.borderStyle = UITextBorderStyleRoundedRect;
      myTextField.font = [UIFont boldSystemFontOfSize:22];
      myTextField.tag = TEXTFIELD_TAG;
      myTextField.delegate = self;
      cell.contentView.tag = indexPath.row; // used for saving the data in the delegate.textFieldDidEndEditing
      [cell.contentView addSubview:myTextField];
    }
  }
  
  NSString *name = [DataManager getNameAtIndex:indexPath.row showAnswered:self.showAnswered];

  if (self.editing) {
    UITextField *myTextField = (UITextField*)[cell.contentView viewWithTag:TEXTFIELD_TAG];
    myTextField.text = name;
  } else {
    cell.textLabel.text = name;
  }
  return cell;
}


@end
