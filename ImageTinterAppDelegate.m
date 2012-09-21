//
//  ImageTinterAppDelegate.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-10.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import "ImageTinterAppDelegate.h"
#import "NSImage-Tint.h"

@interface ImageTinterAppDelegate () {
    NSImage *image;
}
@end

@implementation ImageTinterAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"photo" ofType:@"jpg"];
    
    image = [[NSImage alloc] initWithContentsOfFile:fileName];
    
    [[self imageView] setImage:image];
}

- (IBAction)normalImage:(id)sender
{
    [[self imageView] setImage:image];
}

- (IBAction)grayscaleImage:(id)sender
{
    [[self imageView] setImage:[image grayscaleImage]];
}

- (IBAction)sepiaImage:(id)sender
{
    [[self imageView] setImage:[image sepiaImage]];
}

- (IBAction)blueToneImage:(id)sender
{
    [[self imageView] setImage:[image bluetoneImage]];
}

@end
