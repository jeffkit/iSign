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
}

@property (nonatomic, retain) UIImageView *drawImage;
@property (nonatomic, retain) NSString *file;
-(id)initWithFile:(NSString *)f;
@end
