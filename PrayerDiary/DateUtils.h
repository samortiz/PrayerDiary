//
// Static Utility Date Functions 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PrayerButton.h"

@interface DateUtils : NSObject

+ (NSMutableArray *) removeDayFromArray:(NSMutableArray *)array day:(NSDate *)day;

+ (PrayerButtonState) getStateForDate:(NSDate *)date dates_prayed:(NSArray *)dates_prayed dates_prayed_w_companion:(NSArray *)dates_prayed_w_companion;

+ (PrayerButtonState) getStateForDate:(NSDate *)date nameIndex:(NSInteger)nameIndex itemIndex:(NSInteger)itemIndex showAnswered:(Boolean)showAnswered;

+ (Boolean) dateInArray:(NSArray *)array date:(NSDate *)date;

+ (Boolean) sameDate:(NSDate*)a date:(NSDate*)b;

@end
