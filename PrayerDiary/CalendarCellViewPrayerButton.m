//
//  CalendarCellView.m
//  PrayerDiary
//
//  Created by Sam O on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CalendarCellViewPrayerButton.h"

@implementation CalendarCellViewPrayerButton

// Constructor
- (id) init {
  self = [super init];
  if (self != nil) {
    self.button = [[PrayerButton alloc] init];
  }
  return self;
}


// The prayerButton is the button
- (PrayerButton *) prayerButton {
  return (PrayerButton *) self.button;
}
- (void) setPrayerButton:(PrayerButton *)prayerButton {
  self.button = prayerButton;
}


// Sets the date for this cell, using the month/year from the baseDate supplied. 
- (void) setDateWithBaseDate:(NSDate *)baseDate calendar:(NSCalendar *)calendar {
  [super setDateWithBaseDate:baseDate calendar:calendar];

    // Highlight today's date
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
  NSDateComponents *todaysComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
  if (todaysComponents.day   == components.day &&
      todaysComponents.month == components.month &&
      todaysComponents.year  == components.year ) {
    self.button.backgroundColor = [UIColor redColor];
  } else {
    self.button.backgroundColor = [UIColor clearColor];
  }
  //NSLog(@"%@=%d %d %d",self.date, components.year, components.month, components.day);
  
  // Used for the PrayerButtonDelegate callback to get the date
  self.prayerButton.contextObj = self.date; 
}


@end
