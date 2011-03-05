//
//  PixelAdapterController.h
//  iSign
//
//  Created by jeff on 11-2-25.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PIXEL_MAX_VALUE 50.0
#define PIXEL_MIN_VALUE 1.0

@interface PixelAdapterController : UIViewController {
	UIImageView *_sample;
	UISlider *_slider;
	
	CGFloat _pixel;
	UIColor *_color;
}

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UIImageView *sample;

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) CGFloat pixel;

- (id) initWithPixel:(CGFloat)pixel color:(UIColor *)color;


@end
