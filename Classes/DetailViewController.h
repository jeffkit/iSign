//
//  DetailViewController.h
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignViewController.h"

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *_toolbar;
    
    NSString *_detailItem;
    UILabel *_detailDescriptionLabel;
	
	SignViewController *_signViewController;
	
	IBOutlet UIBarButtonItem *_btSave;
	IBOutlet UIBarButtonItem *_btClear;
	IBOutlet UIBarButtonItem *_btSync;
	
	NSOperationQueue *_queue;
	
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btSave;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btClear;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *btSync;

@property (nonatomic, retain) NSString *detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) SignViewController *signViewController;

@property (nonatomic, retain) NSOperationQueue *queue;


- (IBAction)clearCanvas:(id)sender;
- (IBAction)saveImage:(id)sender;
- (IBAction)sync:(id)sender;
- (IBAction)changePixel:(id)sender;
- (IBAction)changeColor:(id)sender;

@end
