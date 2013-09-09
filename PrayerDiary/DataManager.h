//
//  DataManager.h
//  PrayerDiary
//
//  Created by Sam O on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Singleton to handle data
@interface DataManager : NSObject {
  NSMutableDictionary *data;
}

@property (nonatomic, retain) NSDictionary *data;

+ (id)sharedManager;

// Load/Store Data
+ (Boolean) loadData:(NSData *)data;
+ (NSData *) getDataFromFile;
+ (void) loadDataFromFile;
+ (void) saveData;

// Name data
+ (NSMutableArray *) getNamesShowAnswered:(Boolean) showAnswered;
+ (NSString *) getNameAtIndex:(NSInteger)nameIndex showAnswered:(Boolean)showAnswered;
+ (NSInteger) getOrCreateIndexForName:(NSString *)name showAnswered:(Boolean)showAnswered;
+ (void) setNameAtIndex:(NSInteger)nameIndex name:(NSString *)newName showAnswered:(Boolean)showAnswered;

// Item data
+ (NSMutableArray *) getItemsAtIndex:(NSInteger)nameIndex showAnswered:(Boolean) showAnswered;
+ (NSMutableDictionary *) getItemAtNameIndex:(NSInteger)nameIndex itemIndex:(NSInteger)itemIndex showAnswered:(Boolean) showAnswered;

// Misc
+ (NSString *) getDocumentPath;

@end
