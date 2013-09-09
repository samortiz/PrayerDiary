//
//  PrayerButton.h
//  PrayerDiary
//
//  Created by Sam O on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrayerButton;

typedef enum {
   PrayerButtonNone
  ,PrayerButtonIndividualOnly
  ,PrayerButtonBoth
  ,PrayerButtonCorporateOnly
} PrayerButtonState;


@protocol PrayerButtonDelegate <NSObject>
- (void) stateChanged:(PrayerButton *) button newState:(PrayerButtonState)state;
@end


@interface PrayerButton : UIButton

@property (nonatomic) PrayerButtonState state;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) id <PrayerButtonDelegate> delegate;
@property (strong, nonatomic) id contextObj;

+ (NSString *) imagePathForState:(PrayerButtonState)state;


@end
