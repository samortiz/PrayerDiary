//
//  CXCalendarCellView.m
//  Calendar
//

#import "CXCalendarCellViewDefault.h"

@implementation CXCalendarCellViewDefault

@synthesize button;
@synthesize date;
@synthesize day;
@synthesize delegate;

// Constructor
- (id) init {
  self = [super init];
  if (self != nil) {
    self.button = [[UIButton alloc] init];
  }
  return self;
}

- (void) setDay: (NSUInteger)newDay {
  day = newDay;
  [self.button setTitle: [NSString stringWithFormat: @"%d", newDay] forState:UIControlStateNormal];
}

// Called when the button in this cell is clicked
// This will pass the call up to the calendarView to handle
- (void) buttonTouched {
  if ([self.delegate respondsToSelector:@selector(cellTouched:)]) {
    [self.delegate cellTouched:self];
  }
}

// Sets the date for this cell, using the month/year from the baseDate supplied. 
- (void) setDateWithBaseDate:(NSDate *)baseDate calendar:(NSCalendar *)calendar {
  NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:baseDate];
  components.day = self.day;
  components.hour = 0;
  components.minute = 0;
  components.second = 0;
  NSDate *cellDate = [calendar dateFromComponents:components];
  self.date = cellDate;
  //NSLog(@"date=%@ components=%d %d %d",cellDate, components.year, components.month, components.day);
}


@end
