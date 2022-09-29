//
//  CQTestCalendarManager.h
//  CQSwift
//
//  Created by llbt2019 on 2022/9/29.
//  Copyright © 2022 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void(^__nullable CalendarCompletion)(BOOL isSuccess, NSError * _Nullable error);
typedef void(^__nullable CalendarFetchDataCompletion)(NSArray * _Nullable itemArray);

NS_ASSUME_NONNULL_BEGIN

@interface CQTestCalendarManager : NSObject

#pragma mark - 日历提醒 -

/**
 *  添加日历提醒事项
 *
 *  @param eventIdentifierLocalKey  事件ID 本地存储Key
 *  @param title      事件标题
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param allDay     是否全天
 *  @param alarmArray 闹钟集合(传nil，则没有)
 *  @param notes      事件备注(传nil，则没有)
 *  @param url        事件url(传nil，则没有)
 *  @param completion 回调方法
 */
- (void)createCalendarEventWithEventIdentifierLocalKey:(NSString *)eventIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray <NSString *> * __nullable)alarmArray url:(NSURL * __nullable)url completion:(CalendarCompletion)completion;


/**
 *  查日历事件
 *
 *  @param eventIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
- (EKEvent *)checkCalendarEventWithIdentifier:(NSString *)eventIdentifierLocalKey;


/**
 *  查日历事件(可查询一段时间内的事件)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param modifytitle    标题，为空则都要查询
 */
- (NSArray *)checkCalendarEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate modifytitle:(NSString * __nullable)modifytitle;


/**
 *  删除日历事件(删除单个)
 *
 *  @param eventIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
- (BOOL)deleteCalendarEventWithIdentifier:(NSString *)eventIdentifierLocalKey;


/**
 *  删除日历事件(可删除一段时间内的事件)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param modifytitle    标题，为空则都要删除
 */
- (BOOL)deleteCalendarEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate modifytitle:(NSString * __nullable)modifytitle;

/**
 *  修改日历事件
 *
 *  @param eventIdentifierLocalKey 事件ID(标识符) 本地key
 *  @param title      修改事件标题
 *  @param startDate  修改开始时间
 *  @param endDate    修改结束时间
 *  @param allDay     修改是否全天
 *  @param alarmArray 修改闹钟集合
 *  @param notes      修改事件备注
 *  @param url        修改事件url
 *  @param completion 回调方法
 */
- (void)modifyCalendarEventWithEventIdentifierLocalKey:(NSString *)eventIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray <NSString *> * __nullable)alarmArray url:(NSURL * __nullable)url completion:(CalendarCompletion)completion;




#pragma mark - Reminder 提醒 -
/**
 *  添加Reminder提醒事项
 *
 *  @param reminderIdentifierLocalKey  事件ID 本地存储Key
 *  @param title      事件标题
 *  @param startDate  开始时间
 *  @param dueDate    预计结束时间
 *  @param alarmDate 闹钟Date
 *  @param notes      事件备注(传nil，则没有)
 *  @param url        事件url(传nil，则没有)
 *  @param completion 回调方法
 */
- (void)createCalendarReminderWithReminderIdentifierLocalKey:(NSString *)reminderIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate dueDate:(NSDate *)dueDate alarmDate:(NSDate *)alarmDate url:(NSURL * __nullable)url completion:(CalendarCompletion)completion;


/**
 *  查Reminder提醒项
 *
 *  @param reminderIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
- (EKReminder *)checkCalendarReminderWithIdentifier:(NSString *)reminderIdentifierLocalKey;



/**
 *  查询Reminder提醒事项 （一段时间）(以dueDate为参照)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param completion 回调方法
 */
- (void)checkCalendarIncompleteRemindersWithDueDateStarting:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate completion:(CalendarFetchDataCompletion)completion;


/**
 *  删除Reminber(删除单个)
 *
 *  @param reminderIdentifierLocalKey    reminder ID(标识符) 本地存储Key
 */
- (BOOL)deleteCalendarReminderWithIdentifier:(NSString *)reminderIdentifierLocalKey;



/**
 *  删除Reminder提醒事项 （一段时间）(以dueDate为参照)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param completion 回调方法
 */

- (void)deleteCalendarIncompleteRemindersWithDueDateStarting:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate completion:(CalendarCompletion)completion;



/**
 *  修改Reminder提醒事项
 *
 *  @param reminderIdentifierLocalKey  事件ID 本地存储Key
 *  @param title      事件标题
 *  @param startDate  开始时间
 *  @param dueDate    预计结束时间
 *  @param alarmDate 闹钟Date
 *  @param notes      事件备注(传nil，则没有)
 *  @param url        事件url(传nil，则没有)
 *  @param completion 回调方法
 */
- (void)modifyCalendarReminderWithReminderIdentifierLocalKey:(NSString *)reminderIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate dueDate:(NSDate *)dueDate alarmDate:(NSDate *)alarmDate url:(NSURL * __nullable)url completion:(CalendarCompletion)completion;
@end

NS_ASSUME_NONNULL_END
