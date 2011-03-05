//
//  AppConfig.h
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// -------------------- Debug Function --------------------------

#define DEBUG 1

#ifdef DEBUG
#define debug_NSLog(format,...) NSLog(format,##__VA_ARGS__)
#else
#define debug_NSLog(format,...)
#endif

#define EVENT_BRUSH_PIXEL_CHANGED @"BrushPixelChanged"
#define EVENT_BRUSH_COLOR_CHANGED @"BrushColorChanged"


