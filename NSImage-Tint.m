//
//  NSImage-Tint.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import "NSImage-Tint.h"

CGFloat const TBITintMatrixGrayscale[] = {
    .3, .59, .11,
    .3, .59, .11,
    .3, .59, .11 };

CGFloat const TBITintMatrixSepia[] = {
    .393, .769, .189,
    .349, .686, .168,
    .272, .534, .131 };

CGFloat const TBITintMatrixBluetone[] = {
    .272, .534, .131,
    .349, .686, .168,
    .393, .769, .189 };

@implementation NSImage (Tint)

- (NSImage *)tintWithMatrix:(CGFloat *)matrix;
{
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    
    NSSize imageSize = [bitmap size];
    
    int pixels = imageSize.height * [bitmap bytesPerRow];
    unsigned char *bitmapData = [bitmap bitmapData];
    int samplesPerPixel = [bitmap samplesPerPixel];
    
    for (int i = 0; i < pixels; i = i + samplesPerPixel) {
        CGFloat red = bitmapData[i];
        CGFloat green = bitmapData[i + 1];
        CGFloat blue = bitmapData[i + 2];
        
        bitmapData[i]     = MIN (red * matrix[0] + green * matrix[1] + blue * matrix[2], 255.0f); // red
        bitmapData[i + 1] = MIN (red * matrix[3] + green * matrix[4] + blue * matrix[5], 255.0f); // green
        bitmapData[i + 2] = MIN (red * matrix[6] + green * matrix[7] + blue * matrix[8], 255.0f); // blue
    }

    NSImage *image = [[NSImage alloc] initWithSize:[bitmap size]];
    [image addRepresentation:bitmap];
    [bitmap release];
    
    return [image autorelease];
}

- (NSImage *)grayscaleImage
{
    return [self tintWithMatrix:TBITintMatrixGrayscale];
}

- (NSImage *)sepiaImage
{
    return [self tintWithMatrix:TBITintMatrixSepia];
}

- (NSImage *)bluetoneImage
{
    return [self tintWithMatrix:TBITintMatrixBluetone];
}

@end
