//
//  ImageTinterAppDelegate.h
//  ImageTinter
//
//  Created by Mikael Hallendal on 2009-10-10.
//  Copyright 2009 Mikael Hallendal. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageTinterAppDelegate : NSObject <NSApplicationDelegate>

@property(weak) IBOutlet NSWindow *window;
@property(strong) IBOutlet NSImageView *imageView;

- (IBAction)normalImage:(id)sender;
- (IBAction)grayscaleImage:(id)sender;
- (IBAction)sepiaImage:(id)sender;
- (IBAction)blueToneImage:(id)sender;

@end
