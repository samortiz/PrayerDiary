//
//  ItemViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define ROW_HEIGHT 35.0f
#define FONT_SIZE 14

#import "ItemViewController.h"
#import "DataManager.h"
#import "DetailItemViewController.h"
#import "DateUtils.h"

@implementation ItemViewController

@synthesize name;  // NSString with the name of the person being prayed for
@synthesize nameIndex; // Index into names array of selected person
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
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;  
  }
  
  self.tableView.rowHeight = ROW_HEIGHT;
  
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
  return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:self.showAnswered];
    [items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  // Update the data model
  NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:self.showAnswered];
  NSDictionary *itemDic = [items objectAtIndex:fromIndexPath.row];
  [items removeObjectAtIndex:fromIndexPath.row];
  [items insertObject:itemDic atIndex:toIndexPath.row];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}

/* -- Not needed with custom cell layout
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  [cell.textLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
}
*/


// Manually call jumping to the details view, this is because the cell in storyboard isn't being used
// I'm using a custom cell so I can add subviews, I can't seem to add subviews to a storyboard cell somehow
// This just calls the segue that's in the storyboard, like you'd expect it to.
// I pass in the indexPath so prepareForSegue will know which row this call is coming from
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *segueName = self.showAnswered ? @"AnsweredItemToDetailSegue" : @"ItemToDetailSegue" ;
  [self performSegueWithIdentifier:segueName sender:indexPath];
}

// Handle clicking on the accessory button
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
  [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}



#pragma mark - NewItemViewControllerDelegate

- (void) newItemDidCancel: (NewItemViewController *) controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) newItemDidSave: (NewItemViewController *) controller newItem:(NSString *)item {
  // Remove the modal NewItemViewController 
  [self dismissViewControllerAnimated:YES completion:nil];
  // Trim whitespace from the item description
  NSString *newItem = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  // Save the name if there is one
  if (newItem.length > 0) {
    // Store the data
    NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:self.showAnswered];
    NSMutableDictionary *newItemDic = [NSMutableDictionary dictionaryWithObject:newItem forKey:@"description"];
    [newItemDic setValue:[NSMutableArray array] forKey:@"dates_prayed"];
    [newItemDic setValue:[NSMutableArray array] forKey:@"dates_prayed_w_companion"];
    [items addObject:newItemDic];
    
    // Update the View
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([items count] -1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}

// Before we transition to another screen
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"NewItemSegue"]) {
    UINavigationController *navigationController = segue.destinationViewController;
    NewItemViewController *newItemViewController = [[navigationController viewControllers] objectAtIndex:0];
    // set self as the delegate so the NewItemViewController can call back when it is done
    newItemViewController.delegate = self;
    
  } else if ([segue.identifier isEqualToString:@"ItemToDetailSegue"] || 
             [segue.identifier isEqualToString:@"AnsweredItemToDetailSegue"]) {
    DetailItemViewController *detail = segue.destinationViewController;
    NSIndexPath * indexPath = (NSIndexPath *) sender;
    detail.nameIndex = self.nameIndex;
    detail.itemIndex = indexPath.row;
    detail.showAnswered = self.showAnswered;
  }
  
}


#pragma mark - Populate the table view with data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:self.showAnswered];
  return [items count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSString *header = @"Today pray for %@";
  if (self.showAnswered) {
    header = @"Answered prayers for %@";
  }
  return [NSString stringWithFormat:header, name];
}


#define CELL_LABEL 1
#define CELL_BUTTON 2

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"itemCell";
  if (self.showAnswered) {
    cellIdentifier = @"answeredItemCell";
  }
  
  UILabel * mainLabel;
  PrayerButton *button;
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    // Custom layout for the cell
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    CGRect mainLabelRect = CGRectMake(40.0, 0.0, 240.0, ROW_HEIGHT);
    if (self.showAnswered) {
      mainLabelRect = CGRectMake(5.0, 0.0, 280.0, ROW_HEIGHT);
    }
    
    mainLabel = [[UILabel alloc] initWithFrame:mainLabelRect];
    mainLabel.tag = CELL_LABEL;
    mainLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    mainLabel.textAlignment = UITextAlignmentLeft;
    mainLabel.textColor = [UIColor blackColor];
    mainLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [cell.contentView addSubview:mainLabel];

    if (!self.showAnswered) {
      button = [[PrayerButton alloc] initWithFrame:CGRectMake(0,0,ROW_HEIGHT, ROW_HEIGHT)];
      button.tag = CELL_BUTTON;
      button.userInteractionEnabled = YES;
      button.delegate = self;
      button.contextObj = [NSNumber numberWithInt:indexPath.row]; 
      [cell.contentView addSubview: button];
    }
    
  } else { // Cell was already found
    mainLabel = (UILabel *)[cell.contentView viewWithTag:CELL_LABEL];
    if (!self.showAnswered) {
      button = (PrayerButton *)[cell.contentView viewWithTag:CELL_BUTTON];
    }
  }

  // Get the item
  NSDictionary *itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:indexPath.row showAnswered:self.showAnswered]; 

  NSString *description = [itemDic objectForKey:@"description"];
  if (showAnswered) {
    // Show the date answered
    NSDate *answeredDate = [itemDic objectForKey:@"answered_date"];
    if (answeredDate != nil) {
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"MM/dd/12"];
      NSString *answeredDateString = [dateFormatter stringFromDate:answeredDate];
      description = [NSString stringWithFormat:@"%@ %@", answeredDateString, description];  
    }
    
    // Show the answered state
    NSString *answered = [itemDic objectForKey:@"answered"];
    if (answered != nil) {
      // Just the first character
      NSString *shortAnswer = [answered substringToIndex:1];
      description = [NSString stringWithFormat:@"%@ %@", shortAnswer, description];
    }
  }
  
  mainLabel.text = description;
    
  if (!self.showAnswered) {
  button.state = [DateUtils getStateForDate:[NSDate date] nameIndex:nameIndex itemIndex:indexPath.row showAnswered:self.showAnswered];
  }
  
  return cell;
}


#pragma mark PrayerButtonDelegate

- (void) stateChanged:(PrayerButton *) button newState:(PrayerButtonState)state {

  NSInteger itemIndex = [(NSNumber *)button.contextObj intValue];
  NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:self.showAnswered];
  NSDictionary *itemDic = [items objectAtIndex:itemIndex];
  NSMutableArray *dates_prayed = [itemDic objectForKey:@"dates_prayed"];
  NSMutableArray *dates_prayed_w_companion = [itemDic objectForKey:@"dates_prayed_w_companion"];
  NSDate *now = [NSDate date];

  // Check for incomplete initialization
  if (dates_prayed == nil) {
    dates_prayed = [NSMutableArray array];
    [itemDic setValue:dates_prayed forKey:@"dates_prayed"];
  }
  if (dates_prayed_w_companion == nil) {
    dates_prayed_w_companion = [NSMutableArray array];
    [itemDic setValue:dates_prayed_w_companion forKey:@"dates_prayed_w_companion"];
  }
  
  // Remove today's date from both date lists
  [DateUtils removeDayFromArray:dates_prayed day:now];
  [DateUtils removeDayFromArray:dates_prayed_w_companion day:now];
  
  // Add today's date as needed
  if ((state == PrayerButtonIndividualOnly) || (state == PrayerButtonBoth)) {
    [dates_prayed addObject:now]; 
  }
  if ((state == PrayerButtonCorporateOnly) || (state == PrayerButtonBoth)) {
    [dates_prayed_w_companion addObject:now]; 
  }
  
}



@end
