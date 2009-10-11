//
//  NSImage-Tint.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-11.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import "NSImage-Tint.h"
#include <mach/mach_time.h>

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

void
tint_pixel_rgb (unsigned char *bitmapData, int red_index, CGFloat *matrix)
{
    int green_index = red_index + 1;
    int blue_index = red_index + 2;
    
    CGFloat red = bitmapData[red_index];
    CGFloat green = bitmapData[green_index] ;
    CGFloat blue = bitmapData[blue_index];
    
    bitmapData[red_index]     = MIN (red * matrix[0] + green * matrix[1] + blue * matrix[2], 255.0f); // red
    bitmapData[green_index] = MIN (red * matrix[3] + green * matrix[4] + blue * matrix[5], 255.0f); // green
    bitmapData[blue_index] = MIN (red * matrix[6] + green * matrix[7] + blue * matrix[8], 255.0f); // blue    
}

@implementation NSImage (Tint)

- (NSImage *)tintWithMatrix:(CGFloat *)matrix;
{
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithData:[self TIFFRepresentation]];
    
    NSSize imageSize = [bitmap size];
    
    int pixels = imageSize.height * [bitmap bytesPerRow];
    unsigned char *bitmapData = [bitmap bitmapData];
    int samplesPerPixel = [bitmap samplesPerPixel];

    uint64_t start = mach_absolute_time();

#if 1
    for (int i = 0; i < pixels; i = i + samplesPerPixel) {
        tint_pixel_rgb(bitmapData, i, matrix);
    }
#else

    int stride = [bitmap bytesPerRow] / samplesPerPixel;
    dispatch_apply(pixels / samplesPerPixel / stride,
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(size_t i){
                       size_t j = i * samplesPerPixel * stride;
                       size_t jStop = j + samplesPerPixel * stride;

                       do {
                           tint_pixel_rgb(bitmapData, j, matrix);
                           
                           j += samplesPerPixel;
                       } while (j < jStop);
                   });
#endif

    
    // Evil ugly timing pointer/int juggling, from the documentation:
    uint64_t elapsed = mach_absolute_time() - start;
    Nanoseconds elapsedNano = AbsoluteToNanoseconds(*(AbsoluteTime *)&elapsed);
    uint64_t elapsedNanoInt = *(uint64_t *)&elapsedNano;
    NSLog(@"Elapsed time: %.2f ms", elapsedNanoInt / 1000000.0);

    
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
