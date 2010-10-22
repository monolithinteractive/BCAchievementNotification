//
//  BCAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "BCAchievementHandler.h"
#import "BCAchievementNotificationView.h"

static BCAchievementHandler *defaultHandler = nil;

#pragma mark -

@interface BCAchievementHandler(private)

- (void)displayNotification:(BCAchievementNotificationView *)notification;
- (void)orientationChanged:(NSNotification *)notification;

@end

#pragma mark -

@implementation BCAchievementHandler(private)

- (void)displayNotification:(BCAchievementNotificationView *)notification
{
    if (self.image != nil)
    {
        [notification setImage:self.image];
    }
    else
    {
        [notification setImage:nil];
    }
	
	if(![_containerView superview])
	{
		[_topView addSubview:_containerView];
	}
    //[_topView addSubview:notification];
	[_containerView addSubview:notification];
    [notification animateIn];
}

- (void)orientationChanged:(NSNotification *)notification
{
	//[self showTitle];
	
	UIDeviceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
	CGFloat angle = 0;
	switch (o) {
		case UIDeviceOrientationLandscapeLeft: angle = 90; break;
		case UIDeviceOrientationLandscapeRight: angle = -90; break;
		case UIDeviceOrientationPortraitUpsideDown: angle = 180; break;
		default: break;
	}
	
	CGRect f = [[UIScreen mainScreen] applicationFrame];
	
	// Swap the frame height and width if necessary
 	if (UIDeviceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	
	CGAffineTransform previousTransform = _containerView.layer.affineTransform;
	CGAffineTransform newTransform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
	//newTransform = CGAffineTransformConcat(newTransform, CGAffineTransformMakeTranslation(f.size.height, 0));
	
	// Reset the transform so we can set the size
	_containerView.layer.affineTransform = CGAffineTransformIdentity;
	_containerView.frame = (CGRect){0,0,f.size};
	
	// Revert to the previous transform for correct animation
	_containerView.layer.affineTransform = previousTransform;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	// Set the new transform
	_containerView.layer.affineTransform = newTransform;
	
	// Fix the view origin
	_containerView.frame = (CGRect){f.origin.x,f.origin.y,_containerView.frame.size};
    [UIView commitAnimations];
}

- (void)setupDefaultFrame
{
	UIDeviceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
	CGFloat angle = 0;
	switch (o) {
		case UIDeviceOrientationLandscapeLeft: angle = 90; break;
		case UIDeviceOrientationLandscapeRight: angle = -90; break;
		case UIDeviceOrientationPortraitUpsideDown: angle = 180; break;
		default: break;
	}
	
	CGRect f = [[UIScreen mainScreen] applicationFrame];
	
	// Swap the frame height and width if necessary
 	if (UIDeviceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	
	CGAffineTransform previousTransform = _containerView.layer.affineTransform;
	CGAffineTransform newTransform = CGAffineTransformMakeRotation(angle * M_PI / 180.0);
	
	_containerView.layer.affineTransform = CGAffineTransformIdentity;
	_containerView.frame = (CGRect){0,0,f.size};
	
	// Revert to the previous transform for correct animation
	_containerView.layer.affineTransform = previousTransform;
	
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
	
	// Set the new transform
	_containerView.layer.affineTransform = newTransform;
	
	// Fix the view origin
	_containerView.frame = (CGRect){f.origin.x,f.origin.y,_containerView.frame.size};
//    [UIView commitAnimations];
}

@end

#pragma mark -

@implementation BCAchievementHandler

@synthesize image=_image;

#pragma mark -

+ (BCAchievementHandler *)defaultHandler
{
    if (!defaultHandler) defaultHandler = [[self alloc] init];
    return defaultHandler;
}

- (id)init
{
	if ((self = [super init]))
	{
		_topView = [[UIApplication sharedApplication] keyWindow];
		
		_containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		_containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_containerView.opaque = NO;
		_containerView.backgroundColor = [UIColor clearColor];
		[self setupDefaultFrame];
		
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
		
		if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
			[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
			//[self setDidEnableRotationNotifications:YES];
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
		//[self orientationChanged:nil]; // set it up initially?
    }
    return self;
}

- (void)dealloc
{
	[_containerView release];
    [_queue release];
    [_image release];
    [super dealloc];
}

#pragma mark -

+ (CGRect)containerRect
{
	UIDeviceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
	
	CGRect f = [[UIScreen mainScreen] applicationFrame];
	
	// Swap the frame height and width if necessary
 	if (UIDeviceOrientationIsLandscape(o)) {
		CGFloat t;
		t = f.size.width;
		f.size.width = f.size.height;
		f.size.height = t;
	}
	return f;
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    BCAchievementNotificationView *notification = [[[BCAchievementNotificationView alloc] initWithAchievementDescription:achievement] autorelease];
    notification.frame = [notification startFrame];
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message
{
    BCAchievementNotificationView *notification = [[[BCAchievementNotificationView alloc] initWithTitle:title andMessage:message] autorelease];
    notification.frame = [notification startFrame];
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

#pragma mark -
#pragma mark BCAchievementHandlerDelegate implementation

- (void)didHideAchievementNotification:(BCAchievementNotificationView *)notification
{
    [_queue removeObjectAtIndex:0];
    if ([_queue count])
    {
        [self displayNotification:(BCAchievementNotificationView *)[_queue objectAtIndex:0]];
    }
	else
		[_containerView removeFromSuperview];
}

@end
