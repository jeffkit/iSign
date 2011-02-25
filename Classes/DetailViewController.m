//
//  DetailViewController.m
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "SignViewController.h"
#import "AppConfig.h"
#import "FileUtils.h"
#import "ASIFormDataRequest.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar = _toolbar;
@synthesize popoverController = popoverController;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize signViewController = _signViewController;
@synthesize btSync = _btSync;
@synthesize btSave = _btSave;
@synthesize btClear = _btClear;
@synthesize queue = _queue;

#pragma mark _
#pragma mark Bottun Event Handlers

- (IBAction)clearCanvas:(id)sender{
	debug_NSLog(@"[DetailViewController clearCanvas]");
	self.signViewController.drawImage.image = nil; 
}

- (IBAction)saveImage:(id)sender{
	debug_NSLog(@"[DetailViewController saveImage]");	
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.signViewController.drawImage.image, 1.0)];
	BOOL newImage = NO;
	if (self.signViewController.file == nil) {
		NSDate *now = [NSDate date];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:SS"];
		
		NSString *docsDir = [FileUtils getDocumentPath];
		NSString *dateStr = [dateFormatter stringFromDate:now];
		debug_NSLog(@"the date object is : %@",[dateFormatter stringFromDate:now]);
		NSString *file = [dateStr stringByAppendingString:@".png"];
		self.signViewController.file = [docsDir stringByAppendingPathComponent:file];

		
		[dateFormatter release];
		newImage = YES;
	}
	debug_NSLog(@"will save file to : %@",self.signViewController.file);
	[imageData writeToFile:self.signViewController.file atomically:YES];
	if (newImage) {
		// 如果是新建的文件，则通知上层控制器更新。
		[[NSNotificationCenter defaultCenter] postNotificationName:@"newImageSaved" object:nil];	
	}
}

- (IBAction)sync:(id)sender{
	[self saveImage:nil]; // 同步之前，先保存文件。
	debug_NSLog(@"[DetailViewController Sync]");
	// 用ASI异步地传输文件，放到一个队列中。
	if (self.queue == nil) {
		self.queue = [[[NSOperationQueue alloc] init] autorelease];
	}
	
	//该地址是接受一个photo参数的文件，并返回字符串表示上传是否成功。("SUCCESS","FAIL","ERROR")
	NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
	NSString *urlStr = [userDef stringForKey:@"server"];
	debug_NSLog(@"the url getting from userDefault is : %@",urlStr);
	if (urlStr == nil || [urlStr length] == 0) {
		debug_NSLog(@"system config not found");
		urlStr = @"http://localhost:5000";
	}
	NSURL *url = [NSURL URLWithString:urlStr];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setFile:self.signViewController.file forKey:@"file"];
	request.delegate = self;
	[self.queue addOperation:request];
}


- (void)requestFinished:(ASIHTTPRequest *)request{
	debug_NSLog(@"[DetailViewController requestFinished]");
	NSString *responseString = [request responseString];
	if (![responseString isEqualToString:@"SUCCESS"]) {
		debug_NSLog(@"Upload file fail!");
		//通知一下么？
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"这不是我的错" 
													   message:@"这肯定不是我的错，一定是那个Web程序员没有返回正确的状态，他没搞定！"
													  delegate:nil 
											 cancelButtonTitle:@"我找Web程序员算帐去！" 
											 otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request{
	debug_NSLog(@"[DetailViewController requestFailed]");
	NSError *error = [request error];
	//通知一下失败的原因
	debug_NSLog(@"the error userinfo is : %@",[error userInfo]);
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"不勒个是吧" 
												   message:@"你看见我有可能是因为网络没联通或是服务器没开启"
												  delegate:nil 
										 cancelButtonTitle:@"好吧,俺检查下设置！" 
										 otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 如果新的item是空的，意味着需要创建一张新的ImageView。
 */
- (void)setDetailItem:(NSString *)newDetailItem {
	debug_NSLog(@"[DetailViewController setDetailItem:%@]",newDetailItem);
	debug_NSLog(@"origin detailItem : %@",_detailItem);
	
    if (newDetailItem == nil || ![_detailItem isEqualToString:newDetailItem]) {
	// 如果新的item是空的，或者非空而不等于旧item时处理
		debug_NSLog(@"click another item!");
        [_detailItem release];
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }
    if (self.popoverController != nil) {
		debug_NSLog(@"dismiss Popover %@",self.popoverController.contentViewController);
        [self.popoverController dismissPopoverAnimated:YES];
    }        
	debug_NSLog(@"end of setDetailItem");
}


/**
 
 */
- (void)configureView {
	debug_NSLog(@"[DetailViewController configureView]");
	if (self.signViewController != nil) {
		[self.signViewController.view removeFromSuperview];
	}
	
	SignViewController *sctl = [[SignViewController alloc] initWithFile:self.detailItem]; 
	self.signViewController = sctl;
	[self.view addSubview:self.signViewController.view];
	[sctl release]; 
	
	
	//self.detailDescriptionLabel.text = self.detailItem;
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"所有嘉宾";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [_toolbar release];
    
    [_detailItem release];
    [_detailDescriptionLabel release];
	
	[_signViewController release];
	
	[_btSave release];
	[_btClear release];
	[_btSync release];
	
	[_queue release];
    [super dealloc];
}

@end
