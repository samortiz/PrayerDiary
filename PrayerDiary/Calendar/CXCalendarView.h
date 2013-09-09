//
//  CXCalendarView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCalendarCellView.h"
#import "PrayerButton.h"

@class CXCalendarView;


@protocol CXCalendarViewDelegate <NSObject>
@optional
-(void) calendarView:(CXCalendarView *)calendarView didSelectDate:(NSDate *)selectedDate;
-(void) calendarView:(CXCalendarView *)calendarView willDisplayCell:(NSObject<CXCalendarCellView> *)cell;
@end


@interface CXCalendarView : UIView <CXCalendarCellViewDelegate> {
@protected
  NSCalendar *_calendar;
  
  NSDate *_selectedDate;
  NSDate *_displayedDate;
  
  UIView *_monthBar;
  UILabel *_monthLabel;
  UIButton *_monthBackButton;
  UIButton *_monthForwardButton;
  UIView *_weekdayBar;
  NSArray *_weekdayNameLabels;
  UIView *_gridView;
  NSArray *_dayCells;
  
  CGFloat _monthBarHeight;
  CGFloat _weekBarHeight;
}

@property(nonatomic, strong) NSCalendar *calendar;

@property(nonatomic, weak) id<CXCalendarViewDelegate> delegate;
@property(nonatomic, strong) NSDate *selectedDate;

@property(nonatomic, strong) NSDate *displayedDate;
@property(nonatomic, readonly) NSUInteger displayedYear;
@property(nonatomic, readonly) NSUInteger displayedMonth;

- (void) monthForward;
- (void) monthBack;

- (void) reset;

// UI
@property(readonly) UIView *monthBar;
@property(readonly) UILabel *monthLabel;
@property(readonly) UIButton *monthBackButton;
@property(readonly) UIButton *monthForwardButton;
@property(readonly) UIView *weekdayBar;
@property(readonly) NSArray *weekdayNameLabels;
@property(readonly) UIView *gridView;
@property(readonly) NSArray *dayCells;

@property(assign) CGFloat monthBarHeight;
@property(assign) CGFloat weekBarHeight;

- (NSObject<CXCalendarCellView> *) cellForDate: (NSDate *) date;

// CXCalendarCellViewDelegate
- (void) cellTouched:(NSObject<CXCalendarCellView> *)cell;

// Create a new cell object given the specified day
- (NSObject<CXCalendarCellView> *) createCell;

// Setup the cell, including adding listeners and delegate
- (void) initializeCell : (NSObject<CXCalendarCellView> *)cell forDay:(NSInteger)day;

@end