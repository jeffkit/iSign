//
//  FileUtils.m
//  iSign
//
//  Created by jeff on 11-2-17.
//  Copyright 2011 jeffkit.info. All rights reserved.
//

#import "FileUtils.h"


@implementation FileUtils

+(NSString *)getDocumentPath{
	NSArray *dirPaths;
	NSString *docsDir;
	
	dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
	docsDir = [dirPaths objectAtIndex:0];
	
	return docsDir;
}
@end
