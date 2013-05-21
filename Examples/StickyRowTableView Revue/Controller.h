//
//  Controller.h
//
//  Created by Paul Kim on 8/21/09.
//  Copyright 2009-2012 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

@class NoodleTableView;

@interface Controller : NSObject
@property (assign) IBOutlet NoodleTableView	*stickyRowTableView;
@property (assign) IBOutlet NSTableView      *iPhoneTableView;
@property (strong) NSMutableArray				*names;
@end
