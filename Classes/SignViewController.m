    //
//  SignViewController.m
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "SignViewController.h"
#import "AppConfig.h"

#define kDetailViewFrame CGRectMake(0, 44, 768, 960)
#define kDrawingFrame CGRectMake(0, 0, 768, 960)

@implementation SignViewController

@synthesize drawImage = _drawImage;
@synthesize file = _file;

/**
 从文件名初始化视图
 */
-(id)initWithFile:(NSString *)f{
	debug_NSLog(@"[SignViewController initWithFile:%@]",f);
	if (self = [super init]) {
		self.file = f;
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	debug_NSLog(@"[SignViewController viewDidLoad]");
    [super viewDidLoad];
	self.view.frame = kDetailViewFrame;
	UIImage *image;
	if (self.file == nil) {
		image = [[UIImage alloc] initWithData:nil];
	}else {
		image= [[UIImage alloc]initWithContentsOfFile:self.file];
	}
	
	self.drawImage = [[UIImageView alloc] initWithFrame:kDrawingFrame];
	self.drawImage.image = image;
	if (self.file == nil){
		self.drawImage.backgroundColor = [UIColor whiteColor];
	}
	[self.view addSubview:self.drawImage];
	
	debug_NSLog(@"views : %@",self.view.subviews);
	mouseMoved = 0;
	[image release];
	debug_NSLog(@"end of [SignViewController viewDidLoad]");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
	debug_NSLog(@"[SignViewController viewDidUnload]");
    [super viewDidUnload];
	self.drawImage = nil;
	self.file = nil;
}


- (void)dealloc {
	debug_NSLog(@"[SignViewController deallo]");
	[_drawImage release];
	[_file release];
    [super dealloc];
}

#pragma mark _
#pragma mark drawImage

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	debug_NSLog(@"[SignViewController touchesBegan] , %@",touches);
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self.drawImage];
	debug_NSLog(@"last Point x : %f,y : %f",lastPoint.x,lastPoint.y);	
	//lastPoint.y -= 20;
	debug_NSLog(@"last Point after ajust : %f",lastPoint.y);
	 
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.drawImage];
	//currentPoint.y -= 20;
	
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}


@end
