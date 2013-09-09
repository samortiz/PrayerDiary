//
//  CalendarView.m
//  PrayerDiary
//
//  Created by Sam O on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCellViewPrayerButton.h"

@implementation CalendarView

@synthesize prayerButtonDelegate;

- (id<PrayerButtonDelegate>) prayerButtonDelegate {
  return prayerButtonDelegate;
}
 
- (void) setPrayerButtonDelegate:(id<PrayerButtonDelegate>)newDelegate { 
  prayerButtonDelegate = newDelegate;
  // Set the delegate for all the buttons
  for (NSObject<CXCalendarCellView> *cell in self.dayCells) {
    PrayerButton *prayerButton = (PrayerButton *)cell.button;
    prayerButton.delegate = newDelegate;
  }
}


// Returns a newly created cell
- (NSObject<CXCalendarCellView> *) createCell {
  CalendarCellViewPrayerButton *cell = [[CalendarCellViewPrayerButton alloc] init];
  return cell;
}


@end
