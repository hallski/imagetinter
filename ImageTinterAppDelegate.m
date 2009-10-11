//
//  ImageTinterAppDelegate.m
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-10.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import "ImageTinterAppDelegate.h"
#import "NSImage-Tint.h"

@implementation ImageTinterAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"photo" ofType:@"jpg"]];
    [imageView setImage:image];
}

- (IBAction)normalImage:(id)sender
{
    [imageView setImage:image];
}

- (IBAction)grayscaleImage:(id)sender
{
    [imageView setImage:[image grayscaleImage]];
}

- (IBAction)sepiaImage:(id)sender
{
    [imageView setImage:[image sepiaImage]];
}

- (IBAction)blueToneImage:(id)sender
{
    [imageView setImage:[image bluetoneImage]];
}

@end
