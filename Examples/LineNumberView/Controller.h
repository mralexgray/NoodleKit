//
//  Controller.h
//  Line View Test
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberView;

@interface Controller : NSObject
{
    IBOutlet NSScrollView   *scrollView;
    IBOutlet NSTextView     *scriptView;
	NoodleLineNumberView	*lineNumberView;
}

@end
