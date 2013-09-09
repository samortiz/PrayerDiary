//
//  CalendarViewController.m
//  PrayerDiary
//

#import "CalendarViewController.h"
#import "DataManager.h"
#import "DateUtils.h"

@implementation CalendarViewController

@synthesize calendarView;
@synthesize nameIndex;
@synthesize itemIndex;
@synthesize showAnswered;

NSMutableDictionary *itemDic;
NSMutableArray *dates_prayed;
NSMutableArray *dates_prayed_w_companion;

- (void) loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor whiteColor];
  self.calendarView = [[CalendarView alloc] initWithFrame: self.view.bounds];
  [self.view addSubview: self.calendarView];
  self.calendarView.frame = self.view.bounds;
  self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

  // Setup the data 
  itemDic = [DataManager getItemAtNameIndex:nameIndex itemIndex:itemIndex showAnswered:self.showAnswered];
  dates_prayed = [itemDic objectForKey:@"dates_prayed"];
  dates_prayed_w_companion = [itemDic objectForKey:@"dates_prayed_w_companion"];
  
  // Delegate must be assigned before setting displayedDate, so the callback on willDisplayCell will be triggered
  self.calendarView.delegate = self;  // Handle cell events, updates to display and clicks
  self.calendarView.prayerButtonDelegate = self; // handle PrayerButton clicks
  self.calendarView.selectedDate = [NSDate date];
  self.calendarView.displayedDate = [NSDate date];
  
}


#pragma mark CXCalendarViewDelegate

- (void) calendarView:(CXCalendarView *)calendarView didSelectDate:(NSDate *)date {
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"MMM dd, yyyy"];
//  NSLog(@"Calendar selected date cell: %@", [dateFormatter stringFromDate:date]);
}


- (void) calendarView:(CXCalendarView *)calendarView willDisplayCell:(NSObject<CXCalendarCellView> *)cell {
  PrayerButtonState state = [DateUtils getStateForDate:cell.date dates_prayed:dates_prayed dates_prayed_w_companion:dates_prayed_w_companion];
  // Need the explicit cast, because UIButton state isn't the same (it's readonly), it really is a PrayerButton though
  PrayerButton *prayerButton = (PrayerButton *)cell.button;
  prayerButton.state = state;
}



#pragma mark PrayerButtonDelegate

- (void) stateChanged:(PrayerButton *) button newState:(PrayerButtonState)state {
  NSDate *date = (NSDate *)button.contextObj;
  
  // Check for incomplete initialization
  if (dates_prayed == nil) {
    dates_prayed = [NSMutableArray array];
    [itemDic setValue:dates_prayed forKey:@"dates_prayed"];
  }
  if (dates_prayed_w_companion == nil) {
    dates_prayed_w_companion = [NSMutableArray array];
    [itemDic setValue:dates_prayed_w_companion forKey:@"dates_prayed_w_companion"];
  }
  
  // Remove the date from both date lists
  [DateUtils removeDayFromArray:dates_prayed day:date];
  [DateUtils removeDayFromArray:dates_prayed_w_companion day:date];
  
  // Add the date as needed
  if ((state == PrayerButtonIndividualOnly) || (state == PrayerButtonBoth)) {
    [dates_prayed addObject:date]; 
  }
  if ((state == PrayerButtonCorporateOnly) || (state == PrayerButtonBoth)) {
    [dates_prayed_w_companion addObject:date]; 
  }
 
  // Need to refresh the view
  [calendarView setNeedsLayout];

  //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  //[dateFormatter setDateFormat:@"MMM dd, yyyy"];
  //NSLog(@"Button Changed state to %d for date %@", state, [dateFormatter stringFromDate:date]);
  //NSLog(@"Data is now %@", [DataManager getNames]);
  
}


@end
