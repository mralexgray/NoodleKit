//
//  NoodleLineNumberMarker.m
//  NoodleKit
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import "NoodleLineNumberMarker.h"


@implementation NoodleLineNumberMarker

- (id)initWithRulerView:(NSRulerView *)aRulerView lineNumber:(CGFloat)line image:(NSImage *)anImage imageOrigin:(NSPoint)imageOrigin
{
	if ((self = [super initWithRulerView:aRulerView markerLocation:0.0 image:anImage imageOrigin:imageOrigin]) != nil)
	{
		_lineNumber = line;
	}
	return self;
}

- (void)setLineNumber:(NSUInteger)line
{
	_lineNumber = line;
}

- (NSUInteger)lineNumber
{
	return _lineNumber;
}

#pragma mark NSCoding methods

#define NOODLE_LINE_CODING_KEY		@"line"

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil)
	{
		if ([decoder allowsKeyedCoding])
		{
			_lineNumber = [[decoder decodeObjectForKey:NOODLE_LINE_CODING_KEY] unsignedIntegerValue];
		}
		else
		{
			_lineNumber = [[decoder decodeObject] unsignedIntegerValue];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	
	if ([encoder allowsKeyedCoding])
	{
		[encoder encodeObject:@(_lineNumber) forKey:NOODLE_LINE_CODING_KEY];
	}
	else
	{
		[encoder encodeObject:@(_lineNumber)];
	}
}


#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone
{
	id		copy;
	
	copy = [super copyWithZone:zone];
	[copy setLineNumber:_lineNumber];
	
	return copy;
}


@end
