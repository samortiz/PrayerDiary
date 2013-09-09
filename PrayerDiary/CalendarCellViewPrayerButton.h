//
//  CalendarCellView.h
//  PrayerDiary
//
//  Created by Sam O on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CXCalendarCellViewDefault.h"
#import "PrayerButton.h"

@interface CalendarCellViewPrayerButton : CXCalendarCellViewDefault

@property (nonatomic, strong) PrayerButton *prayerButton;

@end
