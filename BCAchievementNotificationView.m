//
//  BCAchievementNotificationView.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "BCAchievementNotificationView.h"

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

@synthesize achievement;
@synthesize backgroundView;
@synthesize handlerDelegate;
@synthesize detailLabel;
@synthesize iconView;
@synthesize message;
@synthesize title;
@synthesize textLabel;

#pragma mark -

- (id)initWithAchievementDescription:(GKAchievementDescription *)anAchievement
{
    CGRect frame = kBCAchievementDefaultSize;
    self.achievement = anAchievement;
    if (self = [self initWithFrame:frame])
    {
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle andMessage:(NSString *)aMessage
{
    CGRect frame = kBCAchievementDefaultSize;
    self.title = aTitle;
    self.message = aMessage;
    if (self = [self initWithFrame:frame])
    {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // create the GK background
        UIImage *backgroundStretch = [[UIImage imageNamed:@"gk-notification.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f];
        UIImageView *tBackground = [[UIImageView alloc] initWithFrame:frame];
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

        if (self.achievement)
        {
            self.textLabel.text = self.achievement.title;
            self.detailLabel.text = self.achievement.achievedDescription;
        }
        else
        {
            if (self.title)
            {
                self.textLabel.text = self.title;
            }
            if (self.message)
            {
                self.detailLabel.text = self.message;
            }
        }

        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)dealloc
{
    self.handlerDelegate = nil;
    self.iconView = nil;
    
    [achievement release];
    [backgroundView release];
    [detailLabel release];
    [iconView release];
    [message release];
    [textLabel release];
    [title release];
    
    [super dealloc];
}


#pragma mark -

- (void)animateIn
{
    [self delegateCallback:@selector(willShowAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kBCAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationInDidStop:finished:context:)];
    self.frame = kBCAchievementFrameEnd;
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
    self.frame = kBCAchievementFrameStart;
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
