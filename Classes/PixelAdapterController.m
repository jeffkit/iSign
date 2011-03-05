    //
//  PixelAdapterController.m
//  iSign
//
//  Created by jeff on 11-2-25.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "PixelAdapterController.h"
#import "AppConfig.h"

@implementation PixelAdapterController

@synthesize slider = _slider;
@synthesize sample = _sample;

@synthesize color = _color;
@synthesize pixel = _pixel;

- (id) initWithPixel:(CGFloat)pixel color:(UIColor *)color{
	debug_NSLog(@"[PixelAdapterController initWithPixel:%f color:%@]",pixel,color);
	if (self = [super init]) {
		self.color = color;
		self.pixel = pixel;
	}
	
	return self;
}

- (void)loadView {
	[super viewDidLoad];
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor whiteColor];
	self.view = view;
	[view release];
}
 
- (void)refreshBrush{
	debug_NSLog(@"[PixelAdapterController refreshBrush]");

	//在图片中间，使用自己的笔触和color画出一点。
	
	debug_NSLog(@"sample frame : %f , %f",self.sample.frame.size.width,self.sample.frame.size.height);
	debug_NSLog(@"sample frame Point : %f , %f",self.sample.frame.origin.x,self.sample.frame.origin.y);
	
	UIGraphicsBeginImageContext(self.sample.frame.size);
	[self.sample.image drawInRect:CGRectMake(150, 11.5, self.sample.frame.size.width, self.sample.frame.size.height)];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineWidth(context, self.pixel);
	
	if (CGColorGetNumberOfComponents(self.color.CGColor) == 4) {
		const CGFloat *c = CGColorGetComponents(self.color.CGColor);
		CGContextSetRGBStrokeColor(context, c[0], c[1], c[2], c[3]);
	}
	
	CGContextMoveToPoint(context, 25.5, 25.5);
	CGContextAddLineToPoint(context, 25.5, 25.5);
	CGContextStrokePath(context);
	CGContextFlush(context);
	self.sample.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	debug_NSLog(@"End of [PixelAdapterController refreshBrush]");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	debug_NSLog(@"[PixelAdapterController viewDidLoad]");
	UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 20, 130, 23)];
	slider.maximumValue = PIXEL_MAX_VALUE;
	slider.minimumValue = PIXEL_MIN_VALUE;
	slider.value = self.pixel;
	[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	self.slider = slider;
	[self.view addSubview:self.slider];
	[slider release];				
	
	debug_NSLog(@"create brush Sample");
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150,6.5,50,50)];
	self.sample = imageView;
	[imageView release];
	[self.view addSubview:self.sample];
	
	debug_NSLog(@"the subviews is : %@", self.view.subviews);
	
	[self refreshBrush];
}



- (void)sliderAction:(id)sender{
	debug_NSLog(@"Slider value changed!");
	self.pixel = self.slider.value;
	[self refreshBrush];
	
	//发出笔触修改的事件
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setObject:self forKey:@"adapter"];
	[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BRUSH_PIXEL_CHANGED
														object:@""
													  userInfo:dic];
	[dic release];
	debug_NSLog(@"after sending a notification");
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[_sample release];
	[_slider release];
	
	[_color release];
    [super dealloc];
}


@end
