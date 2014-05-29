//
//  NoodleLineNumberMarker.h
//  NoodleKit
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

/*! Marker for NoodleLineNumberView.
    For more details, see the related blog post at:  http://www.noodlesoft.com/blog/2008/10/05/displaying-line-numbers-with-nstextview/
 */

@interface NoodleLineNumberMarker : NSRulerMarker

- (id) initWithRulerView:(NSRulerView*)rv lineNumber:(CGFloat)l
                   image:(NSImage*)i     imageOrigin:(NSPoint)io;

@property NSUInteger lineNumber;

@end
