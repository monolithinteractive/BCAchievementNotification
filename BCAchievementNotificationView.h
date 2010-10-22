//
//  BCAchievementNotificationView.h
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <UIKit/UIKit.h>

@class BCAchievementNotificationView;

#define kBCAchievementAnimeTime     0.4f
#define kBCAchievementDisplayTime   1.75f

#define kBCAchievementDefaultSize   CGRectMake(0.0f, 0.0f, 284.0f, 52.0f);
//#define kBCAchievementFrameStart    CGRectMake(18.0f, -53.0f, 284.0f, 52.0f);
//#define kBCAchievementFrameEnd      CGRectMake(18.0f, 10.0f, 284.0f, 52.0f);

#define kBCAchievementText1         CGRectMake(10.0, 6.0f, 264.0f, 22.0f);
#define kBCAchievementText2         CGRectMake(10.0, 20.0f, 264.0f, 22.0f);
#define kBCAchievementText1WLogo    CGRectMake(45.0, 6.0f, 229.0f, 22.0f);
#define kBCAchievementText2WLogo    CGRectMake(45.0, 20.0f, 229.0f, 22.0f);

#pragma mark -

/**
 * The handler delegate responds to hiding and showing
 * of the game center notifications.
 */
@protocol BCAchievementHandlerDelegate <NSObject>

@optional

/**
 * Called on delegate when notification is hidden.
 * @param nofification  The notification view that was hidden.
 */
- (void)didHideAchievementNotification:(BCAchievementNotificationView *)notification;

/**
 * Called on delegate when notification is shown.
 * @param nofification  The notification view that was shown.
 */
- (void)didShowAchievementNotification:(BCAchievementNotificationView *)notification;

/**
 * Called on delegate when notification is about to be hidden.
 * @param nofification  The notification view that will be hidden.
 */
- (void)willHideAchievementNotification:(BCAchievementNotificationView *)notification;

/**
 * Called on delegate when notification is about to be shown.
 * @param nofification  The notification view that will be shown.
 */
- (void)willShowAchievementNotification:(BCAchievementNotificationView *)notification;

@end

#pragma mark -

/**
 * The BCAchievementNotificationView is a view for showing the achievement earned.
 */
@interface BCAchievementNotificationView : UIView
{
    GKAchievementDescription  *achievementDescription;  /**< Description of achievement earned. */

//    NSString *message;  /**< Optional custom achievement message. */
//    NSString *title;    /**< Optional custom achievement title. */

    UIView  *backgroundView;  /**< Stretchable background view. */
    UIImageView  *iconView;        /**< Logo that is displayed on the left. */

    UILabel      *textLabel;    /**< Text label used to display achievement title. */
    UILabel      *detailLabel;  /**< Text label used to display achievement description. */

    id<BCAchievementHandlerDelegate> handlerDelegate;  /**< Reference to nofification handler. */
	
	UIViewContentMode displayMode; // where to display the view: corners, top, or bottom. default: top
}

/** Description of achievement earned. */
@property (nonatomic, retain) GKAchievementDescription *achievementDescription;
///** Optional custom achievement message. */
//@property (nonatomic, retain) NSString *message;
///** Optional custom achievement title. */
//@property (nonatomic, retain) NSString *title;
/** Stretchable background view. */
@property (nonatomic, retain) UIView *backgroundView;
/** Logo that is displayed on the left. */
@property (nonatomic, retain) UIImageView *iconView;
/** Text label used to display achievement title. */
@property (nonatomic, retain) UILabel *textLabel;
/** Text label used to display achievement description. */
@property (nonatomic, retain) UILabel *detailLabel;
/** Reference to nofification handler. */
@property (nonatomic, retain) id<BCAchievementHandlerDelegate> handlerDelegate;

@property (nonatomic, assign) UIViewContentMode displayMode;

#pragma mark -

/**
 * Create a notification with an achievement description.
 * @param achievement  Achievement description to notify user of earning.
 * @return a BCAchievementNoficiation view.
 */
- (id)initWithAchievementDescription:(GKAchievementDescription *)achievement;

/**
 * Create a notification with a custom title and description.
 * @param title    Title to display in notification.
 * @param message  Descriotion to display in notification.
 * @return a BCAchievementNoficiation view.
 */
- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;

- (CGRect)startFrame;
- (CGRect)endFrame;

/**
 * Show the notification.
 */
- (void)animateIn;

/**
 * Hide the notificaiton.
 */
- (void)animateOut;

/**
 * Change the logo that appears on the left.
 * @param image  The image to display.
 */
- (void)setImage:(UIImage *)image;

@end
