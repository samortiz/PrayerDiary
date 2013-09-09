//
//  CalendarViewController
//  PrayerDiary
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "PrayerButton.h"

@interface CalendarViewController : UIViewController <CXCalendarViewDelegate, PrayerButtonDelegate>

@property(strong, nonatomic) CalendarView *calendarView;

@property (assign, nonatomic) NSInteger nameIndex;
@property (assign, nonatomic) NSInteger itemIndex;
@property (assign, nonatomic) Boolean showAnswered;

@end
