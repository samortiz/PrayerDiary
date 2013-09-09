//
//  CalendarView.h
//  PrayerDiary
//
//  Created by Sam O on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CXCalendarView.h"
#import "PrayerButton.h"

@interface CalendarView : CXCalendarView

@property(nonatomic, weak) id<PrayerButtonDelegate> prayerButtonDelegate;

@end
