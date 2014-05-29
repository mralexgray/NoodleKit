//
//  Controller.m
//  Line View Test
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import "Controller.h"

@implementation Controller

- (void)awakeFromNib
{
    lineNumberView = [MarkerLineNumberView.alloc initWithScrollView:scrollView];

    [scrollView setVerticalRulerView:lineNumberView];
    [scrollView setHasHorizontalRuler:NO];
    [scrollView  setHasVerticalRuler:YES];
    [scrollView     setRulersVisible:YES];
	
    [scriptView setFont:[NSFont userFixedPitchFontOfSize:[NSFont smallSystemFontSize]]];
    [scriptView setDelegate:(id)self];
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {

  CGFloat(^rf)() = ^CGFloat{ return (CGFloat)((arc4random()%255)/255.); };

  [lineNumberView setMarkerColor:[NSColor colorWithCalibratedRed:rf() green:rf() blue:rf() alpha:1]];
}

@end
