//
//  NSWindow-Zoom.h
//  NoodleKit
//
//  Created by Paul Kim on 6/18/07.
//  Copyright 2007-2009 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

/*
 Provides a "zoom" animation for windows when ordering on and off screen.
 
 For more details, check out the related blog posts at http://www.noodlesoft.com/blog/2007/06/30/animation-in-the-time-of-tiger-part-1/ and http://www.noodlesoft.com/blog/2007/09/20/animation-in-the-time-of-tiger-part-3/
 */

@interface NSWindow (NoodleEffects)

- (void)animateToFrame:(NSRect)frameRect duration:(NSTimeInterval)duration;

- (void)zoomOnFromRect:(NSRect)startRect;
- (void)zoomOffToRect:(NSRect)endRect;

@end
