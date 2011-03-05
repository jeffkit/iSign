    //
//  SignViewController.m
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "SignViewController.h"
#import "AppConfig.h"
#import "PixelAdapterController.h"

#define kDetailViewFrame CGRectMake(0, 44, 768, 960)
#define kDrawingFrame CGRectMake(0, 0, 768, 960)

@implementation SignViewController

@synthesize drawImage = _drawImage;
@synthesize file = _file;
@synthesize color = _color;
@synthesize pixel = _pixel;

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
	
	
	self.color = [UIColor redColor];
	self.pixel = 10.0;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updatePixel:)
												 name:EVENT_BRUSH_PIXEL_CHANGED
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateColor:)
												 name:EVENT_BRUSH_COLOR_CHANGED
											   object:nil];
}

-(void)updatePixel:(id)sender{
	debug_NSLog(@"[SignViewController updatePixel:%@]",[sender userInfo]);
	NSDictionary *dic = [sender userInfo];
	PixelAdapterController *pc = (PixelAdapterController *)[dic objectForKey:@"adapter"];
	self.pixel = pc.pixel;
}

-(void)updateColor:(id)sender{
	debug_NSLog(@"[SignViewController updateColor:%@]",[sender userInfo]);
	NSDictionary *dic = [sender userInfo];
	self.color = [dic objectForKey:@"color"];
	debug_NSLog(@"color updated to %@",self.color);
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
	[_color release];
    [super dealloc];
}

#pragma mark _
#pragma mark drawImage

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	debug_NSLog(@"[SignViewController touchesBegan] , %@",touches);
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	lastPoint = [touch locationInView:self.drawImage];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.drawImage];
	
	[self drawLinefrom:lastPoint to:currentPoint flush:NO];
	
	lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	debug_NSLog(@"[SignViewController touchesEnd]");
	if(!mouseSwiped) {
		[self drawLinefrom:lastPoint to:lastPoint flush:YES];
	}
}

-(void)drawLinefrom:(CGPoint)from to:(CGPoint)to flush:(BOOL)flush{
	UIGraphicsBeginImageContext(self.view.frame.size);
	[self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineWidth(context,self.pixel);
	
	if (CGColorGetNumberOfComponents(self.color.CGColor) == 4) {
		const CGFloat *c = CGColorGetComponents(self.color.CGColor);
		CGContextSetRGBStrokeColor(context, c[0], c[1], c[2], c[3]);
	}
	
	CGContextMoveToPoint(context, from.x, from.y);
	CGContextAddLineToPoint(context, to.x, to.y);
	CGContextStrokePath(context);
	
	if (flush) {
		CGContextFlush(context);
	}

	self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}


@end
