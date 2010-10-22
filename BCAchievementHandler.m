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

    [_topView addSubview:notification];
    [notification animateIn];
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
    self = [super init];
    if (self != nil)
    {
        _topView = [[UIApplication sharedApplication] keyWindow];
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
    }
    return self;
}

- (void)dealloc
{
    [_queue release];
    [_image release];
    [super dealloc];
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    BCAchievementNotificationView *notification = [[[BCAchievementNotificationView alloc] initWithAchievementDescription:achievement] autorelease];
    notification.frame = kBCAchievementFrameStart;
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
    notification.frame = kBCAchievementFrameStart;
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
}

@end
