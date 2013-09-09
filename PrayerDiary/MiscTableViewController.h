//
//  MiscTableViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MiscTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *prayerCountsLabel;

- (void) exportData;

- (Boolean) handleOpenURL:(NSURL *)url;

- (void) drawStats;

@end
