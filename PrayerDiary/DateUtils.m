//
// Static Date utility functions
//

#import "DateUtils.h"
#import "DataManager.h"

@implementation DateUtils

// Singleton sharedCalendar
// NSCalendar is disgustingly expensive to create! 
+ (NSCalendar *) sharedCalendar {
  static NSCalendar *sharedCalendar = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ 
    sharedCalendar = [NSCalendar currentCalendar]; 
  });
  return sharedCalendar;
}


// Removes all the dates in the array that match the day (at any hour or min)
+ (NSMutableArray *) removeDayFromArray:(NSMutableArray *)array day:(NSDate *)day {
  NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
  NSUInteger i = 0;
  // Go through the array looking for matching dates
  for (id obj in array) {
    if ([obj isKindOfClass:[NSDate class]]) {
      NSDate *thisDate = (NSDate *) obj;
      if ([DateUtils sameDate:thisDate date:day]) {
        [indexes addIndex:i];
      }
    }
    i++;
  }
  [array removeObjectsAtIndexes:indexes];
  return array;
}


+ (PrayerButtonState) getStateForDate:(NSDate *)date dates_prayed:(NSArray *)dates_prayed dates_prayed_w_companion:(NSArray *) dates_prayed_w_companion {
  PrayerButtonState state = PrayerButtonNone;
  Boolean individual = NO;
  Boolean corporate = NO;

  if ([DateUtils dateInArray:dates_prayed date:date]) {
    individual = YES;
  }
  if ([DateUtils dateInArray:dates_prayed_w_companion date:date]) {
    corporate = YES;
  }
  if (individual && !corporate) {
    state = PrayerButtonIndividualOnly;
  } else if (individual && corporate) {
    state = PrayerButtonBoth;
  } else if (!individual && corporate) {
    state = PrayerButtonCorporateOnly;
  } // the none case is already set
  
  return state;

}


+ (PrayerButtonState) getStateForDate:(NSDate *)date nameIndex:(NSInteger)nameIndex itemIndex:(NSInteger)itemIndex showAnswered:(Boolean)showAnswered {
  NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:showAnswered];
  NSDictionary *itemDic = [items objectAtIndex:itemIndex];  
  NSMutableArray *dates_prayed = [itemDic objectForKey:@"dates_prayed"];
  NSMutableArray *dates_prayed_w_companion = [itemDic objectForKey:@"dates_prayed_w_companion"];
  
  return [DateUtils getStateForDate:date dates_prayed:dates_prayed dates_prayed_w_companion:dates_prayed_w_companion];
}


+ (Boolean) dateInArray:(NSArray *)array date:(NSDate *)date {
  for (id obj in array) {
    if ([obj isKindOfClass:[NSDate class]]) {
      NSDate *thisDate = (NSDate *) obj;
      if ([DateUtils sameDate:thisDate date:date]) {
        return YES;
      }
    }
  }
  return NO;
}


#define YMD_FLAGS NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
+ (Boolean) sameDate:(NSDate*)a date:(NSDate*)b {
  NSCalendar *calendar = [DateUtils sharedCalendar];
  
  NSDateComponents *aComp = [calendar components:YMD_FLAGS fromDate:a];
  NSDateComponents *bComp = [calendar components:YMD_FLAGS fromDate:b];
  return aComp.day   == bComp.day   &&
         aComp.month == bComp.month &&
         aComp.year  == bComp.year;
}


@end
