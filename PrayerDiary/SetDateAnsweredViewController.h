//
//  SetDateAnsweredViewController.h
//  PrayerDiary
//
//  Created by Sam O on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetDateAnsweredDelegate <NSObject>
- (void) setDateAnswered:(NSDate *)date;
@end

@interface SetDateAnsweredViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id<SetDateAnsweredDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
