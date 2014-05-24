
//  StatusItemPopup.m  StatusItemPopup
//  Created by Alexander Schuch on 06/03/13. Copyright (c) 2013 Alexander Schuch. All rights reserved.

#import "AXStatusItemPopup.h"

#define kMinViewWidth 22
#define FRAME (NSRect){NSZeroPoint,{kMinViewWidth,NSStatusBar.systemStatusBar.thickness}}

// Implementation
@implementation AXStatusItemPopup {

@private
  NSViewController * _viewController;
       NSImageView * _imageView;
      NSStatusItem * _statusItem;
         NSPopover * _popover;
                id   _popoverTransiencyMonitor;
              BOOL   _active;
}

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image
{
  return [self initWithViewController:controller image:image alternateImage:nil];
}

- (id) initWithViewController:(NSViewController*)vc {

  self            = [super initWithFrame:FRAME]; return self ?
  _viewController = vc,
  (_statusItem    = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength]).view = self,
  _active         = NO,
  _animated       = YES, self : nil;
}

- (id)initWithViewController:(NSViewController*)vc image:(NSImage *)img alternateImage:(NSImage *)alt
{
  self                        = [self initWithViewController:vc];
  _image                      = img;
  _alternateImage             = alt;
  [self addSubview:_imageView = [NSImageView.alloc initWithFrame:self.bounds]];
  _imageView.alignment        = NSImageAlignCenter;
  _imageView.imageScaling     =  NSImageScaleProportionallyUpOrDown;
  return self;
}

- (id)initWithViewController:(NSViewController*)vc drawnWithBlock:(StatusBlock)b {

  self = [self initWithViewController:vc]; return self ? _drawBlock = [b copy], self : nil;
}

#pragma mark - Drawing

- (void)drawRect:(NSRect)dirtyRect
{
  if (_drawBlock) return _drawBlock(self); // if we draw in a block, do it.. and bail.

  // set view background color
  [_active ? NSColor.selectedMenuItemColor : NSColor.clearColor setFill];

  NSRectFill(dirtyRect);

  _imageView.image = _active ? _alternateImage : _image;  // set image
}

#pragma mark - Position / Size

- (void)setContentSize:(CGSize)size
{
  _popover.contentSize = size;
}

#pragma mark - Mouse Actions

- (void)mouseDown:(NSEvent *)theEvent
{
  _popover.isShown ? [self hidePopover] : [self showPopover];
}

#pragma mark - Setter

- (void)setActive:(BOOL)active
{
  _active = active;
  [self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)image
{
  _image = image;
  [self updateViewFrame];
}

- (void)setAlternateImage:(NSImage *)image
{
  _alternateImage = image ?: image;
  [self updateViewFrame];
}

#pragma mark - Helper

- (void)updateViewFrame
{
  self.frame = _imageView.frame = (NSRect){{0,0},
    {MAX(MAX(kMinViewWidth, self.alternateImage.size.width), self.image.size.width),
                                            NSStatusBar.systemStatusBar.thickness}};
  [self setNeedsDisplay:YES];
}

#pragma mark - Show / Hide Popover

- (void)showPopover
{
  [self showPopoverAnimated:_animated];
}

- (void)showPopoverAnimated:(BOOL)animated
{
  self.active = YES;

  _popover = _popover ?: ({ _popover = NSPopover.new;
      _popover.contentViewController = _viewController; _popover; });

  if (_popover.isShown) return;
  _popover.animates = animated;
  [_popover showRelativeToRect:self.frame ofView:self preferredEdge:NSMinYEdge];
  _popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask handler:^(NSEvent* event) {
    [self hidePopover];
  }];
}

- (void)hidePopover
{
  self.active = NO;

  if (_popover && _popover.isShown) [_popover close];
  if (_popoverTransiencyMonitor)
    [NSEvent removeMonitor:_popoverTransiencyMonitor], _popoverTransiencyMonitor = nil;
}

@end

