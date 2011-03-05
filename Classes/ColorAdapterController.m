//
//  ColorAdapterController.m
//  iSign
//
//  Created by jeff on 11-3-4.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "ColorAdapterController.h"
#import "AppConfig.h"


@implementation ColorAdapterController

@synthesize colors = _colors;
@synthesize currentColor = _CurrentColor;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}

-(id) initWithColor:(UIColor *)color{
	if (self = [super init]) {
		self.currentColor = color;
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray *color = [[NSArray alloc] initWithObjects:
					  [UIColor colorWithRed:1 green:0 blue:0 alpha:1],			//red
					  [UIColor colorWithRed:0 green:1 blue:0 alpha:1],			//green
					  [UIColor colorWithRed:0 green:0 blue:1 alpha:1],			//blue
					  [UIColor colorWithRed:0 green:1 blue:1 alpha:1],			//cyan
					  [UIColor colorWithRed:1 green:1 blue:0 alpha:1],			//yellow
					  [UIColor colorWithRed:1 green:0 blue:1 alpha:1],			//magenta
					  [UIColor colorWithRed:1 green:0.5 blue:0 alpha:1],		//orange
					  [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:1],		//purple
					  [UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:1],	//brown
					  [UIColor colorWithRed:1 green:1 blue:1 alpha:1],			//white
					  nil];
	self.colors = color;
	[color release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.colors count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSUInteger row = [indexPath row];
	cell.contentView.backgroundColor = [self.colors objectAtIndex:row];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	debug_NSLog(@"[ColorAdapterController didSelectRowAtIndexPath:%@]",indexPath);
	NSUInteger row = [indexPath row];
	self.currentColor = [self.colors objectAtIndex:row];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setObject:self.currentColor forKey:@"color"];
	debug_NSLog(@"color will be change");
	[[NSNotificationCenter defaultCenter] postNotificationName:EVENT_BRUSH_COLOR_CHANGED
														object:@""
													  userInfo:dic];
	[dic release];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	
}


- (void)dealloc {
	[_colors release];
	[_currentColor release];
    [super dealloc];
}


@end

