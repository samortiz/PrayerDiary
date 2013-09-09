//
//  DataManager.m
//  PrayerDiary
//
//  Created by Sam O on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

// Singleton pattern to handle application-wide data
@implementation DataManager

@synthesize data;

#pragma mark Singleton Methods

+ (id)sharedManager {
  static DataManager *sharedDataManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ 
    sharedDataManager = [[self alloc] init]; 
  });
  return sharedDataManager;
}

- (id)init {
  if (self = [super init]) {
    data = [NSMutableDictionary dictionary];
  }
  return self;
}


#pragma mark Loading and Saving Data

// Load all the app data returns NO if there was an error
+ (Boolean) loadData:(NSData *)data {
  DataManager *dataManager = [DataManager sharedManager];
  NSError *error;
  dataManager.data = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainers format:nil error:&error];
  if (error) {
    return NO;
  } 
  return YES;
}

+ (NSData *) getDataFromFile {
  NSString *path = [DataManager getDocumentPath];
  return [[NSData alloc] initWithContentsOfFile:path];
}

// Get and load the data
+ (void) loadDataFromFile {
  NSData *data = [DataManager getDataFromFile];
  [DataManager loadData:data];
}

// Write out the current data to the file system
+ (void) saveData {
  DataManager *dataManager = [DataManager sharedManager];
  NSString *path = [DataManager getDocumentPath];
  [dataManager.data writeToFile:path atomically:YES];
  //NSLog(@"Saved %@", dataManager.data);  
}



#pragma mark - Names

+ (NSMutableArray *) getNamesShowAnswered:(Boolean)showAnswered {
  DataManager *dataManager = [DataManager sharedManager];
  NSString *key = showAnswered ? @"answered_names" : @"unanswered_names";
  NSMutableArray *names = [dataManager.data objectForKey:key];
  if (names == nil) {
    names = [NSMutableArray array];
    [dataManager.data setValue:names forKey:key];
  }
  return names;
}


// returns the index for the specified name
// If the name does not exist this will create it and then return the index of the newly created name
+ (NSInteger) getOrCreateIndexForName:(NSString *)name showAnswered:(Boolean)showAnswered {
  // Get the correect array of names
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];

  // Go through the array and see if we can find the matching name
  NSInteger nameIndex = 0;
  for (NSMutableDictionary *nameDic in names) {
    NSString *foundName = [nameDic objectForKey:@"name"];
    if ([name isEqualToString:foundName]) {
      return nameIndex;
    }
    nameIndex++;
  }
  
  // If no name matches, then we will append the name to the array
  NSMutableDictionary *nameDic = [NSMutableDictionary dictionary];
  [nameDic setValue:name forKey:@"name"];
  [names addObject:nameDic];
  NSLog(@"Created name %@ for showAnswered=%d", name, showAnswered);
  return [names indexOfObject:nameDic];
}


// Returns the string for the name at the specified index
+ (NSString *) getNameAtIndex:(NSInteger)nameIndex showAnswered:(Boolean)showAnswered {
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
  NSMutableDictionary *nameDic = [names objectAtIndex:nameIndex];
  NSString *name = [nameDic objectForKey:@"name"];
  return name;
}


+ (void) setNameAtIndex:(NSInteger)nameIndex name:(NSString *)newName showAnswered:(Boolean)showAnswered {
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
  NSMutableDictionary *nameDic = [names objectAtIndex:nameIndex];
  [nameDic setObject:newName forKey:@"name"];  
}


#pragma mark - Items

+ (NSMutableArray *) getItemsAtIndex:(NSInteger)nameIndex showAnswered:(Boolean)showAnswered  {
  NSMutableArray *names = [DataManager getNamesShowAnswered:showAnswered];
  NSMutableDictionary *nameDic = [names objectAtIndex:nameIndex];
  if (nameDic == nil) {
    [NSException exceptionWithName:@"Index out of Bounds" reason:[NSString stringWithFormat:@"names array does not contain index %d",nameIndex] userInfo:nil];
  }
  NSString *key = @"items";
  NSMutableArray *items = [nameDic objectForKey:key];
  if (items == nil) {
    items = [NSMutableArray array];
    [nameDic setValue:items forKey:key];
    NSLog(@"Created new items list for nameIndex=%d showAnswered=%d", nameIndex, showAnswered);
  }
  return items;
}

// Gets the Dictionary for the item
+ (NSMutableDictionary *) getItemAtNameIndex:(NSInteger)nameIndex itemIndex:(NSInteger)itemIndex showAnswered:(Boolean)showAnswered {
  NSMutableArray *items = [DataManager getItemsAtIndex:nameIndex showAnswered:showAnswered];
  NSMutableDictionary *itemDic = [items objectAtIndex:itemIndex];
  return itemDic;
}



#pragma mark Misc

// Check if the data files exists in Documents, if not copy it from the bundle
// Returns the path to the file in the documents directory
+ (NSString *) getDocumentPath {

  NSError *error;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:@"prayer_journal.pda"];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:path]) {
    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"prayer_journal" ofType:@"pda"];
    [fileManager copyItemAtPath:bundle toPath:path error:&error];
  }
  
  return path;
}






@end
