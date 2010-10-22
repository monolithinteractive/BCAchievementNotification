//
//  BCAchievementNotificationView.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "BCAchievementNotificationView.h"
#import "BCAchievementHandler.h"

#pragma mark -

@interface BCAchievementNotificationView(private)

- (void)animationInDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)animationOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)delegateCallback:(SEL)selector withObject:(id)object;

@end

#pragma mark -

@implementation BCAchievementNotificationView(private)

- (void)animationInDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self delegateCallback:@selector(didShowAchievementNotification:) withObject:self];
    [self performSelector:@selector(animateOut) withObject:nil afterDelay:kBCAchievementDisplayTime];
}

- (void)animationOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self delegateCallback:@selector(didHideAchievementNotification:) withObject:self];
    [self removeFromSuperview];
}

- (void)delegateCallback:(SEL)selector withObject:(id)object
{
    if (self.handlerDelegate)
    {
        if ([self.handlerDelegate respondsToSelector:selector])
        {
            [self.handlerDelegate performSelector:selector withObject:object];
        }
    }
}

@end

#pragma mark -

@implementation BCAchievementNotificationView

@synthesize achievementDescription;
@synthesize backgroundView;
@synthesize handlerDelegate;
@synthesize detailLabel;
@synthesize iconView;
//@synthesize message;
//@synthesize title;
@synthesize textLabel;
@synthesize displayMode;

#pragma mark -

- (id)initWithAchievementDescription:(GKAchievementDescription *)anAchievement
{
	CGRect defaultFrame = kBCAchievementDefaultSize;
	
	if (self = [self initWithFrame:defaultFrame])
	{
		self.achievementDescription = anAchievement;
		self.textLabel.text = self.achievementDescription.title;
		self.detailLabel.text = self.achievementDescription.achievedDescription;
		self.iconView.image = self.achievementDescription.image;
	}
	return self;
}

- (id)initWithTitle:(NSString *)aTitle andMessage:(NSString *)aMessage
{
    CGRect defaultFrame = kBCAchievementDefaultSize;
    if (self = [self initWithFrame:defaultFrame])
    {
		self.textLabel.text = aTitle;
		self.detailLabel.text = aMessage;
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if ((self = [super initWithFrame:aFrame]))
    {
		self.displayMode = UIViewContentModeTop;
		
        // create the GK background
        UIImage *backgroundStretch = [[UIImage imageNamed:@"gk-notification.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f];
        UIImageView *tBackground = [[UIImageView alloc] initWithFrame:aFrame];
        tBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        tBackground.image = backgroundStretch;
        self.backgroundView = tBackground;
        self.opaque = NO;
        [tBackground release];
        [self addSubview:self.backgroundView];

        CGRect r1 = kBCAchievementText1;
        CGRect r2 = kBCAchievementText2;

        // create the text label
        UILabel *tTextLabel = [[UILabel alloc] initWithFrame:r1];
        tTextLabel.textAlignment = UITextAlignmentCenter;
        tTextLabel.backgroundColor = [UIColor clearColor];
        tTextLabel.textColor = [UIColor whiteColor];
        tTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        tTextLabel.text = NSLocalizedString(@"Achievement Unlocked", @"Achievemnt Unlocked Message");
        self.textLabel = tTextLabel;
        [tTextLabel release];

        // detail label
        UILabel *tDetailLabel = [[UILabel alloc] initWithFrame:r2];
        tDetailLabel.textAlignment = UITextAlignmentCenter;
        tDetailLabel.adjustsFontSizeToFitWidth = YES;
        tDetailLabel.minimumFontSize = 10.0f;
        tDetailLabel.backgroundColor = [UIColor clearColor];
        tDetailLabel.textColor = [UIColor whiteColor];
        tDetailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
        self.detailLabel = tDetailLabel;
        [tDetailLabel release];

//        if (self.achievementDescription)
//        {
//            self.textLabel.text = self.achievement.title;
//            self.detailLabel.text = self.achievement.achievedDescription;
//        }
//        else
//        {
//            if (self.title)
//            {
//                self.textLabel.text = self.title;
//            }
//            if (self.message)
//            {
//                self.detailLabel.text = self.message;
//            }
//        }

        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)dealloc
{
    self.handlerDelegate = nil;
    self.iconView = nil;
    
    [achievementDescription release];
    [backgroundView release];
    [detailLabel release];
    [iconView release];
//    [message release];
    [textLabel release];
//    [title release];
    
    [super dealloc];
}

#pragma mark -

- (CGRect)rectForRect:(CGRect)rect withinRect:(CGRect)bigRect withMode:(UIViewContentMode)mode
{
	CGRect result = rect;
	switch (mode)
	{
		case UIViewContentModeCenter:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		case UIViewContentModeBottom:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMaxY(bigRect) - (rect.size.height);
			break;
		case UIViewContentModeBottomLeft:			
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMaxY(bigRect) - rect.size.height;
			break;
		case UIViewContentModeBottomRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMaxY(bigRect) - rect.size.height;
			break;
		case UIViewContentModeLeft:
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		case UIViewContentModeTop:
			result.origin.x = CGRectGetMidX(bigRect) - (rect.size.width / 2);
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeTopLeft:
			result.origin.x = CGRectGetMinX(bigRect);
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeTopRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMinY(bigRect);
			break;
		case UIViewContentModeRight:
			result.origin.x = CGRectGetMaxX(bigRect) - rect.size.width;
			result.origin.y = CGRectGetMidY(bigRect) - (rect.size.height / 2);
			break;
		default:
			break;
	}
	return result;
}

// off screen
- (CGRect)startFrame
{
	CGRect result = self.frame;
	CGRect containerRect = [BCAchievementHandler containerRect];
	result = [self rectForRect:result withinRect:containerRect withMode:self.displayMode];
	switch (self.displayMode) {
		case UIViewContentModeTop:
		case UIViewContentModeTopLeft:
		case UIViewContentModeTopRight:
			result.origin.y -= (self.frame.size.height + 10);
			break;
		case UIViewContentModeBottom:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeBottomRight:
			result.origin.y += (self.frame.size.height * 2 + 10);
			break;
		default:
			break;
	}
	return result;
}

// on screen
- (CGRect)endFrame
{
	CGRect result = self.frame;
	CGRect containerRect = [BCAchievementHandler containerRect];
	result = [self rectForRect:result withinRect:containerRect withMode:self.displayMode];
	switch (self.displayMode) {
		case UIViewContentModeTop:
		case UIViewContentModeTopLeft:
		case UIViewContentModeTopRight:
			result.origin.y += 10; // padding from top of screen
			break;
		case UIViewContentModeBottom:
		case UIViewContentModeBottomLeft:
		case UIViewContentModeBottomRight:
			result.origin.y -= (self.frame.size.height + 10);
			break;
		default:
			break;
	}
	return result;
}

- (void)animateIn
{
    [self delegateCallback:@selector(willShowAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kBCAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationInDidStop:finished:context:)];
    self.frame = [self endFrame];
    [UIView commitAnimations];
}

- (void)animateOut
{
    [self delegateCallback:@selector(willHideAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kBCAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationOutDidStop:finished:context:)];
    self.frame = [self startFrame];
    [UIView commitAnimations];
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        if (!self.iconView)
        {
            UIImageView *tLogo = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 6.0f, 34.0f, 34.0f)];
            tLogo.contentMode = UIViewContentModeCenter;
            self.iconView = tLogo;
            [tLogo release];
            [self addSubview:self.iconView];
        }
        self.iconView.image = image;
        self.textLabel.frame = kBCAchievementText1WLogo;
        self.detailLabel.frame = kBCAchievementText2WLogo;
    }
    else
    {
        if (self.iconView)
        {
            [self.iconView removeFromSuperview];
        }
        self.textLabel.frame = kBCAchievementText1;
        self.detailLabel.frame = kBCAchievementText2;
    }
}

@end
