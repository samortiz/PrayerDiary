//
//  MiscTableViewController.m
//  PrayerDiary
//
//  Created by Sam O on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MiscTableViewController.h"
#import "DataManager.h"

@implementation MiscTableViewController
@synthesize prayerCountsLabel;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self drawStats];
}

- (void)viewDidUnload {
  [self setPrayerCountsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ((indexPath.section == 0) && (indexPath.row == 0)) {
    [self exportData];
  }
  
  // This doesn't look good
  //else if ((indexPath.section == 1) && (indexPath.row == 0)) {
  //  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  //}
}


#pragma mark - Export / Import methods

- (void) exportData {
  NSLog(@"Export button clicked");

  NSData *prayerData = [DataManager getDataFromFile];
  MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
  [picker addAttachmentData:prayerData mimeType:@"application/prayerjournal" fileName:@"prayer_journal.pda"];
  [picker setToRecipients:[NSArray array]];
  [picker setMessageBody:@"Here is all your PrayerJournal Data." isHTML:NO];
  [picker setMailComposeDelegate:self];
  [self presentModalViewController:picker animated:YES];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissModalViewControllerAnimated:YES];
}


// Handle opening a new data file
- (Boolean) handleOpenURL:(NSURL *)url {
  if ([url isFileURL]) {
    NSData *data = [[NSData alloc] initWithContentsOfFile:url.path];
    return [DataManager loadData:data];
  }
  // We don't know how to handle URL's that aren't file URLs!
  return NO; 
}



#pragma mark - TableViewController

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

  // Each time the cell is loaded re-calculate the stats (they may have changed)
  if ((indexPath.section == 1) && (indexPath.row == 0)) {
    [self drawStats];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  }

  return cell;
}



#pragma mark - Statistics

- (void) drawStats {
  
  NSInteger unansweredCount = 0;
  NSArray *unansweredNames = [DataManager getNamesShowAnswered:NO];
  for (NSDictionary *name in unansweredNames) {
    NSArray *items = [name objectForKey:@"items"];
    unansweredCount += [items count];
  }

  NSInteger yesCount = 0;
  NSInteger noCount = 0;
  NSArray *answeredNames = [DataManager getNamesShowAnswered:YES];
  for (NSDictionary *name in answeredNames) {
    NSArray *items = [name objectForKey:@"items"];
    for (NSDictionary *item in items) {
      NSString *answered = [item objectForKey:@"answered"];
      if ([answered isEqualToString:@"Yes"]) {
        yesCount++;
      } else if ([answered isEqualToString:@"No"]) {
        noCount++;
      } else {
        // This shouldn't happen, but you never know
        unansweredCount++;
      }
    } // for    
  } // for
  
  self.prayerCountsLabel.text = [NSString stringWithFormat:@"Unanswered=%d, Yes=%d, No=%d", unansweredCount, yesCount, noCount];
}


@end
