
//  StatusItemPopup.h  StatusItemPopup
//  Created by Alexander Schuch on 06/03/13. Copyright (c) 2013 Alexander Schuch. All rights reserved.

#import <Cocoa/Cocoa.h>

@interface AXStatusItemPopup : NSView

typedef void(^StatusBlock)(AXStatusItemPopup*pop);

// properties
@property (nonatomic)                  BOOL   animated;
@property (nonatomic,getter=isActive)  BOOL   active;
@property (nonatomic,copy)      StatusBlock   drawBlock;
@property (nonatomic)          NSStatusItem * statusItem;
@property (nonatomic)               NSImage * image,
                                            * alternateImage;
// init
- (id) initWithViewController:(NSViewController*)c;
- (id) initWithViewController:(NSViewController*)c image:(NSImage*)i;
- (id) initWithViewController:(NSViewController*)c image:(NSImage*)i alternateImage:(NSImage*)a;
- (id) initWithViewController:(NSViewController*)c drawnWithBlock:(StatusBlock)b;

// show / hide popover
- (void) showPopoverAnimated:(BOOL)animated;
- (void) showPopover;
- (void) hidePopover;

// view size
- (void) setContentSize:(CGSize)size;

@end
