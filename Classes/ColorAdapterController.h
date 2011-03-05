//
//  ColorAdapterController.h
//  iSign
//
//  Created by jeff on 11-3-4.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorAdapterController : UITableViewController {
	NSArray *_colors;
	UIColor *_currentColor;
}

@property (nonatomic, retain) NSArray *colors;
@property (nonatomic, retain) UIColor *currentColor;

-(id) initWithColor:(UIColor *)color;

@end
