// Protocols for Calendar Cells

// Forward reference 
@protocol CXCalendarCellView;



// Notifications when a cell is clicked 
@protocol CXCalendarCellViewDelegate <NSObject>
- (void) cellTouched:(NSObject<CXCalendarCellView> *)cell;
@end



// Cell View - Contains a button
@protocol CXCalendarCellView <NSObject>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSDate *date;  
@property (nonatomic, assign) NSUInteger day;
@property (nonatomic, weak  ) NSObject<CXCalendarCellViewDelegate> *delegate;

- (void) buttonTouched;

- (void) setDateWithBaseDate:(NSDate *)baseDate calendar:(NSCalendar *)calendar;

@end


