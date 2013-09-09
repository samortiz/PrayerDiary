//
//  CXCalendarCellView.h
//  Calendar
//
#import <UIKit/UIKit.h>
#import "CXCalendarCellView.h"

@interface CXCalendarCellViewDefault : NSObject <CXCalendarCellView>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSDate *date;  
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, weak  ) NSObject<CXCalendarCellViewDelegate> *delegate;

- (void) buttonTouched;
- (void) setDateWithBaseDate:(NSDate *)baseDate calendar:(NSCalendar *)calendar;

@end
