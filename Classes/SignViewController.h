//
//  SignViewController.h
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignViewController : UIViewController {
	CGPoint lastPoint;
	BOOL mouseSwiped;	
	int mouseMoved;	
	UIImageView *_drawImage;
	NSString *_file;
	
	CGFloat _pixel;
	UIColor *_color;
}

@property (nonatomic, retain) UIImageView *drawImage;
@property (nonatomic, retain) NSString *file;
@property (nonatomic, assign) CGFloat pixel;
@property (nonatomic, retain) UIColor *color;

-(id)initWithFile:(NSString *)f;
-(void)drawLinefrom:(CGPoint)from to:(CGPoint)to flush:(BOOL)flush;
@end
