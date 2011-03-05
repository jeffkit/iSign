//
//  RootViewController.m
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "iSignAppDelegate.h"
#import "FileUtils.h"
#import "AppConfig.h"


@implementation RootViewController

@synthesize detailViewController = _detailViewController;
@synthesize files = _files;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	//在右边增加一个新建按钮
	UIBarButtonItem *create = [[UIBarButtonItem alloc] initWithTitle:@"有客到" 
															   style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(create)];
	self.navigationItem.rightBarButtonItem = create;
	[create release];
	
	[self reloadSource];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver:self
	 selector:@selector(reloadSource)
	 name:@"newImageSaved"
	 object:nil];
}


-(void)reloadSource{
	debug_NSLog(@"[RootViewController reloadSource]");
	//把文件夹下面的图片文件名全读取一遍，存进数据里。
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *docsDir = [FileUtils getDocumentPath];
	
	NSLog(@"the document path : %@",docsDir);
	NSArray *fileList = [fm directoryContentsAtPath:docsDir];
	
	
	NSMutableArray *tmpFiles = [[NSMutableArray alloc] initWithArray:fileList];
	
	self.files = tmpFiles;
	
	[tmpFiles release];
	[fm release];
	
	[self.view reloadData];
}

/**
 有客到，创建一张空白签名
 */
-(void)create {
	self.detailViewController.detailItem = nil;
}


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	debug_NSLog(@"[RootViewController tableView:numberOfRowsInSection]");
    // Return the number of rows in the section.
    return [self.files count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    debug_NSLog(@"[RootViewController tableView:cellForRowAtIndexPath]");
	
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.files objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	debug_NSLog(@"[RootViewController tableView:didSelectRowAtIndexPath:%@]",indexPath);    
	NSString *docsDir = [FileUtils getDocumentPath];
	NSString *path = [self.files objectAtIndex:indexPath.row];
	NSString *imagePath = [docsDir stringByAppendingPathComponent:path];
    self.detailViewController.detailItem = imagePath;
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	debug_NSLog(@"end of [RootViewController tableView:didSelectRowAtIndexPath]");
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    _detailViewController = nil;
	_files = nil;
}


- (void)dealloc {
    [_detailViewController release];
	[_files release];
    [super dealloc];
}


@end

