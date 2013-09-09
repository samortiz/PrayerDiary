//
//  PrayerButton.m
//  PrayerDiary
//
//  Created by Sam O on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrayerButton.h"

@implementation PrayerButton

@synthesize imageView;
@synthesize delegate;
@synthesize contextObj;
@synthesize state;

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    state = PrayerButtonNone;
    [self setBackgroundImage:[UIImage imageNamed:[PrayerButton imagePathForState:state]] forState:UIControlStateNormal];
  }
  return self;
}


#pragma mark Touch Handling

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
  [super touchesMoved:touches withEvent:event];

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];

  switch (state) {
    case PrayerButtonNone:
      self.state = PrayerButtonIndividualOnly;
      break;

    case PrayerButtonIndividualOnly:
      self.state = PrayerButtonBoth;
      break;
      
    case PrayerButtonBoth:
      self.state = PrayerButtonCorporateOnly;
      break;
      
    case PrayerButtonCorporateOnly:
      self.state = PrayerButtonNone;
      break;
  }
  
  [self setState:state];
}


#pragma mark Data

- (void) setState:(PrayerButtonState)newState {
  if (state != newState) {
    state = newState;

    NSString *newImageName = [PrayerButton imagePathForState:self.state];
  
    // Set the button image to reflect the new state
    [self setBackgroundImage:[UIImage imageNamed:newImageName] forState:UIControlStateNormal];

    // request a redraw
    [self.imageView setNeedsDisplay];
 
    // Call the delegate function to notify of a state change
    [self.delegate stateChanged:self newState:newState];
  }
}

+ (NSString *) imagePathForState:(PrayerButtonState)state {
  switch (state) {
    case PrayerButtonNone:
      return @"prayerbutton_empty.png";

    case PrayerButtonIndividualOnly:
      return @"prayerbutton_bl.png";
  
    case PrayerButtonBoth:
      return @"prayerbutton_filled.png";
      
    case PrayerButtonCorporateOnly:
      return @"prayerbutton_tr.png";
  }
  [NSException raise:@"Error! Uknown PrayerButtonState. " format:@"state=%d", state];
  
}


@end
