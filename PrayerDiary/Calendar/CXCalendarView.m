//
//  CXCalendarView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarView.h"
#import "CXCalendarCellView.h"
#import "CXCalendarCellViewDefault.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kGridMargin = 4;

@implementation CXCalendarView

@synthesize delegate;

static const CGFloat kDefaultMonthBarButtonWidth = 60;

- (id) initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame: frame])) {
    self.backgroundColor = [UIColor clearColor];
    
    self.selectedDate = nil;
    self.displayedDate = [NSDate date];
    
    _monthBarHeight = 48;
    _weekBarHeight = 32;
  }
  return self;
}


- (NSCalendar *) calendar {
  if (!_calendar) {
    _calendar = [NSCalendar currentCalendar];
  }
  return _calendar;
}


- (void) setCalendar: (NSCalendar *) calendar {
  if (_calendar != calendar) {
    calendar = calendar;
    [self setNeedsLayout];
  }
}


#pragma mark - Date Selection

// CXCalendarCellViewDelegate method (called when user clicks a button in a cell)
- (void) cellTouched:(NSObject<CXCalendarCellView> *)cell {
  self.selectedDate = cell.date;
}


- (NSDate *) selectedDate {
  return _selectedDate;
}

- (void) setSelectedDate: (NSDate *) selectedDate {
  if (![selectedDate isEqual: _selectedDate]) {
    _selectedDate = selectedDate;
    
    for (NSObject<CXCalendarCellView> *cellView in self.dayCells) {
      cellView.button.selected = NO;
    }
    
    [[self cellForDate: selectedDate].button setSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
      [self.delegate calendarView: self didSelectDate: _selectedDate];
    }
  }
}


- (NSDate *) displayedDate {
  return _displayedDate;
}


- (void) setDisplayedDate: (NSDate *) displayedDate {
  if (_displayedDate != displayedDate) {
    _displayedDate = displayedDate;
    
    NSString *monthName = [[[NSDateFormatter new] standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
    self.monthLabel.text = [NSString stringWithFormat: @"%@ %d", NSLocalizedString(monthName, @""), self.displayedYear];
    
    for (NSObject<CXCalendarCellView> *cell in self.dayCells) {
      // Set the date for this cell, based on the newly selected month/year
      [cell setDateWithBaseDate:displayedDate calendar:self.calendar];

      // Delegate method called when date is changed
      if ([self.delegate respondsToSelector:@selector(calendarView:willDisplayCell:)]) {
        [self.delegate calendarView:self willDisplayCell:cell];
      }
    }
    
    [self setNeedsLayout];
  }
}


- (NSUInteger)displayedYear {
  NSDateComponents *components = [self.calendar components: NSYearCalendarUnit fromDate: self.displayedDate];
  return components.year;
}


- (NSUInteger)displayedMonth {
  NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit fromDate: self.displayedDate];
  return components.month;
}


- (CGFloat) monthBarHeight {
  return _monthBarHeight;
}


- (void) setMonthBarHeight: (CGFloat) monthBarHeight {
  if (_monthBarHeight != monthBarHeight) {
    _monthBarHeight = monthBarHeight;
    [self setNeedsLayout];
  }
}


- (CGFloat) weekBarHeight {
  return _weekBarHeight;
}


- (void) setWeekBarHeight: (CGFloat) weekBarHeight {
  if (_weekBarHeight != weekBarHeight) {
    _weekBarHeight = weekBarHeight;
    [self setNeedsLayout];
  }
}


- (void) monthForward {
  NSDateComponents *monthStep = [NSDateComponents new];
  monthStep.month = 1;
  self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}


- (void) monthBack {
  NSDateComponents *monthStep = [NSDateComponents new];
  monthStep.month = -1;
  self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
}


- (void) reset {
  self.selectedDate = nil;
}


- (NSDate *) displayedMonthStartDate {
  NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                  fromDate: self.displayedDate];
  components.day = 1;
  return [self.calendar dateFromComponents: components];
}


- (NSObject<CXCalendarCellView> *) cellForDate: (NSDate *) date {
  NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                  fromDate: date];
  if (components.month == self.displayedMonth &&
      components.year == self.displayedYear &&
      [self.dayCells count] >= components.day) {
    return [self.dayCells objectAtIndex:(components.day - 1)];
  }
  return nil;
}


- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat top = 0;
  
  if (self.monthBarHeight) {
    self.monthBar.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBarHeight);
    self.monthLabel.frame = CGRectMake(0, top, self.bounds.size.width, self.monthBar.bounds.size.height);
    self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth, top,kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
    self.monthBackButton.frame = CGRectMake(0, top, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
    top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
  } else {
    self.monthBar.frame = CGRectZero;
  }
  
  if (self.weekBarHeight) {
    self.weekdayBar.frame = CGRectMake(0, top, self.bounds.size.width, self.weekBarHeight);
    for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
      UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
      label.frame = CGRectMake((self.weekdayBar.bounds.size.width / 7) * (i % 7), 0, self.weekdayBar.bounds.size.width / 7, self.weekdayBar.bounds.size.height);
    }
    top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
  } else {
    self.weekdayBar.frame = CGRectZero;
  }
  
  // Calculate shift
  NSDateComponents *components = [self.calendar components:NSWeekdayCalendarUnit fromDate:[self displayedMonthStartDate]];
  NSInteger shift = components.weekday - self.calendar.firstWeekday;
  if (shift < 0) {
    shift = 7 + shift;
  }
  
  // Calculate range
  NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.displayedDate];
  
  self.gridView.frame = CGRectMake(kGridMargin, top, self.bounds.size.width - kGridMargin * 2, self.bounds.size.height - top);
  CGFloat cellHeight = self.gridView.bounds.size.height / 6.0;
  CGFloat cellWidth = (self.bounds.size.width - kGridMargin * 2) / 7.0;
  for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
    NSObject<CXCalendarCellView> *cellView = [self.dayCells objectAtIndex:i];
    cellView.button.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7), cellWidth, cellHeight);
    cellView.button.hidden = i >= range.length;
    cellView.button.selected = [cellView.date isEqualToDate:self.selectedDate];
  }
}


- (UIView *) monthBar {
  if (!_monthBar) {
    _monthBar = [[UIView alloc] init];
    _monthBar.backgroundColor = [UIColor blueColor];
    _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview: _monthBar];
  }
  return _monthBar;
}


- (UILabel *) monthLabel {
  if (!_monthLabel) {
    _monthLabel = [[UILabel alloc] init];
    _monthLabel.font = [UIFont systemFontOfSize: [UIFont buttonFontSize]];
    _monthLabel.textColor = [UIColor whiteColor];
    _monthLabel.textAlignment = UITextAlignmentCenter;
    _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _monthLabel.backgroundColor = [UIColor clearColor];
    [self.monthBar addSubview: _monthLabel];
  }
  return _monthLabel;
}


- (UIButton *) monthBackButton {
  if (!_monthBackButton) {
    _monthBackButton = [[UIButton alloc] init];
    [_monthBackButton setTitle: @"<" forState:UIControlStateNormal];
    _monthBackButton.titleLabel.font = [UIFont systemFontOfSize: [UIFont buttonFontSize]];
    _monthBackButton.titleLabel.textColor = [UIColor whiteColor];
    [_monthBackButton addTarget: self action: @selector(monthBack) forControlEvents: UIControlEventTouchUpInside];
    [self.monthBar addSubview: _monthBackButton];
  }
  return _monthBackButton;
}


- (UIButton *) monthForwardButton {
  if (!_monthForwardButton) {
    _monthForwardButton = [[UIButton alloc] init];
    [_monthForwardButton setTitle: @">" forState:UIControlStateNormal];
    _monthForwardButton.titleLabel.font = [UIFont systemFontOfSize: [UIFont buttonFontSize]];
    _monthForwardButton.titleLabel.textColor = [UIColor whiteColor];
    [_monthForwardButton addTarget: self action: @selector(monthForward) forControlEvents: UIControlEventTouchUpInside];
    [self.monthBar addSubview: _monthForwardButton];
  }
  return _monthForwardButton;
}


- (UIView *) weekdayBar {
  if (!_weekdayBar) {
    _weekdayBar = [[UIView alloc] init];
    _weekdayBar.backgroundColor = [UIColor clearColor];
  }
  return _weekdayBar;
}


- (NSArray *) weekdayNameLabels {
  if (!_weekdayNameLabels) {
    NSMutableArray *labels = [NSMutableArray array];
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc] init];
    dateFromatter.calendar = self.calendar;
    for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
      NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);
      UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
      label.tag = i;
      label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
      label.textAlignment = UITextAlignmentCenter;
      NSString *weekdayName = [[dateFromatter shortWeekdaySymbols] objectAtIndex: index];
      label.text = NSLocalizedString(weekdayName, @"");
      [labels addObject:label];
      [_weekdayBar addSubview: label];
    }
    [self addSubview:_weekdayBar];
    _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
  }
  return _weekdayNameLabels;
}


- (UIView *) gridView {
  if (!_gridView) {
    _gridView = [[UIView alloc] init];
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview: _gridView];
  }
  return _gridView;
}


- (NSArray *) dayCells {
  if (!_dayCells) {
    NSMutableArray *cells = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 31; ++i) {
      NSObject<CXCalendarCellView> *cell = [self createCell];
      [self initializeCell:cell forDay:i];
      [cells addObject:cell];
      [self.gridView addSubview: cell.button];
    }
    _dayCells = [[NSArray alloc] initWithArray:cells];
  }
  return _dayCells;
}


// Returns a newly created cell for the specified day (method exists to be overridden)
- (NSObject<CXCalendarCellView> *) createCell {
  CXCalendarCellViewDefault *cell = [[CXCalendarCellViewDefault alloc] init];
  return cell;
}


// Made to easily override the display of cells at creation
- (void) initializeCell : (NSObject<CXCalendarCellView> *)cell forDay:(NSInteger)day {
  cell.button.backgroundColor = [UIColor clearColor];
  [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [cell.button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
  cell.button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
  cell.button.tag = day;
  cell.day = day;
  cell.delegate = self;
  [cell.button addTarget:cell action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
}


@end
