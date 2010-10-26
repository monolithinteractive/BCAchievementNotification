//
//  BCAchievementHandler.h
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <Foundation/Foundation.h>
#import "BCAchievementNotificationView.h"

/**
 * Game Center has a notification window that slides down and informs the GKLocalPlayer 
 * that they've been authenticated. The BCAchievementNotificationView classes are a way to 
 * display achievements awarded to the player in the same manner; more similar to Xbox Live 
 * style achievement popups. The achievement dialogs are added to the UIWindow view of your application.
 *
 * The BCAchievementHandler is a singleton pattern that you can use to 
 * notify the user anywhere in your application that they earned an achievement.
 */
@interface BCAchievementHandler : NSObject
{
    UIView         *_topView;  /**< Reference to top view of UIApplication. */
	UIView		   *_containerView;
    NSMutableArray *_queue;    /**< Queue of achievement notifiers to display. */
    UIImage        *image;    /**< Logo to display in notifications. */
	UIViewContentMode viewDisplayMode; /**< Where on screen views will show up, top, top left, top right, etc. Default UIViewContentModeTop */
	CGSize		   defaultViewSize;
	UIImage		   *defaultBackgroundImage;
}

/** Logo to display in notifications. */
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *defaultBackgroundImage;
/**
 * View content mode value to control where the views will show on the screen, defaults to top 
 */
@property (nonatomic, assign) UIViewContentMode viewDisplayMode;
/**
 * Default size for handler created views
 */
@property (nonatomic, assign) CGSize defaultViewSize;

/**
 * Returns a reference to the singleton BCAchievementHandler.
 * @return a single BCAchievementHandler.
 */
+ (BCAchievementHandler *)defaultHandler;

/**
 * Returns a rect that's been properly adjusted for device orientation
 */
+ (CGRect)containerRect;

/**
 * Queues a manually created notificatoin view for display. Immediately displays if queue is empty
 * @param notification A BCAchievementNotificationView configured and ready for display
 */
- (void)queueNotification:(BCAchievementNotificationView *)notification;

/**
 * Show an achievement notification with an actual achievement.
 * @param achievement  Achievement description object to notify user of.
 */
- (void)notifyAchievement:(GKAchievementDescription *)achievement;

/**
 * Show an achievement notification with a message manually added.
 * @param title    The title of the achievement.
 * @param message  Description of the achievement.
 */
- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message;

@end
