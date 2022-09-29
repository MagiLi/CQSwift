//
//  CQTestCalendarManager.m
//  CQSwift
//
//  Created by llbt2019 on 2022/9/29.
//  Copyright © 2022 李超群. All rights reserved.
//

#import "CQTestCalendarManager.h"
//#import "NSString+isBlank.h"
//#import "XTAuthorityManager.h"

static NSString *const kEventCalendarIdentifierLocalKey = @"XT_CloudMeeting_EventCalendar_Identifier_Key";
static NSString *const kReminderCalendarIdentifierLocalKey = @"XT_CloudMeeting_ReminderCalendar_Identifier_Key";

static NSString *const kEventIdentifier = @"XT_Calendar_Event_Key";
static NSString *const kReminderIIdentifier = @"XT_Calendar_Reminder_Key";

@interface CQTestCalendarManager ()
@property (nonatomic,strong) EKEventStore *eventStore;
@property (nonatomic,strong) NSMutableArray <NSString *> *calendarItemIdentifierArray; // 存储日历唯一标识符
@end

@implementation CQTestCalendarManager

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.eventStore = [[EKEventStore alloc] init];
//        self.calendarItemIdentifierArray = [[NSMutableArray alloc] init];
//        [self crateCalendar];
//    }
//    return self;
//}

//- (void)crateCalendar {
//    EKCalendar *eventCalendar = [self findCustomCalendar:EKEntityTypeEvent];
//    if (!eventCalendar) {
//        [self createCustomCalendarWithEntityType:EKEntityTypeEvent title:@"云会议" completion:nil];
//    }
//
//    EKCalendar *reminderCalendar = [self findCustomCalendar:EKEntityTypeReminder];
//    if (!reminderCalendar) {
//        [self createCustomCalendarWithEntityType:EKEntityTypeReminder title:@"云会议" completion:nil];
//    }
//
//
//}

/**
 *  创建日历
 *
 *  @param entityType      日历类型 EKEntityTypeEvent EKEntityTypeReminder
 *  @param title      日历标题
 *  @param completion 回调方法
 */
- (void)createCustomCalendarWithEntityType:(EKEntityType)entityType title:(NSString *)title completion:(CalendarCompletion)completion {
    // 创建日历
    EKCalendar * customCalendar = [EKCalendar calendarForEntityType:entityType eventStore:self.eventStore];
    //  必须设置source，否则无法创建calendar
    customCalendar.source = [self getAvailableCalendarSource];
    customCalendar.title = title;
    
    NSError *error = nil;
    BOOL isSuccess = [self.eventStore saveCalendar:customCalendar commit:YES error:&error];
    
//    if (!error) {
//        if (![NSString isBlankString:customCalendar.calendarIdentifier]) {
//
//            //存储calendarIdentifier
//            NSString *calendarIdfLocalKey = nil;
//            if (entityType == EKEntityTypeEvent) {
//                calendarIdfLocalKey = kEventCalendarIdentifierLocalKey;
//            }else{
//                calendarIdfLocalKey = kReminderCalendarIdentifierLocalKey;
//            }
//            [XTUserDefault setValue:customCalendar.calendarIdentifier forKey:calendarIdfLocalKey];
//
//        }else{
//            isSuccess = NO;
//            error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"eventIdentifier不存在"}];
//        }
//    }else{
//        isSuccess = NO;
//    }
//
//    !completion?:completion(isSuccess,error);
    
}

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
//- (void)createCalendarEventWithEventIdentifierLocalKey:(NSString *)eventIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray <NSString *> * __nullable)alarmArray url:(NSURL * __nullable)url completion:(CalendarCompletion)completion {
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSError * authorityError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"未授权"}];
//        !completion?:completion(NO,authorityError);
//        return;
//    }
//
//
//    BOOL isSuccess = NO;
//    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
//    event.title = title;
//    event.allDay = allDay;
//    event.notes = notes;
//    event.URL = url?:[NSURL URLWithString:@"xtcloudmeeting://"];
//    event.startDate = startDate;
//    event.endDate = endDate;
//
//    //添加闹钟提醒
//    if (alarmArray && alarmArray.count > 0) {
//        for (NSString *timeString in alarmArray) {
//            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
//        }
//    }
//
//    // 存储到日历源中
//    EKCalendar *eventCalendar = [self findCustomCalendar:EKEntityTypeEvent];
//    if (eventCalendar) {
//        [event setCalendar:eventCalendar];
//    }else{
//        [event setCalendar:[self.eventStore defaultCalendarForNewEvents]];
//        NSLog(@"XTCalendarEventManager save defaultCalendarForNewEvents");
//    }
//
//    // 保存日历
//    NSError *isError;
//    isSuccess = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&isError];
    
//    if (!isError) {
//        if (![NSString isBlankString:event.eventIdentifier] && ![NSString isBlankString:eventIdentifierLocalKey]) {
//            //存储日历ID
//            [XTUserDefault setValue:event.eventIdentifier forKey:[self getCalendarItemLocalKey:eventIdentifierLocalKey type:EKEntityTypeEvent]];
//        }else{
//            isSuccess = NO;
//            isError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"eventIdentifier不存在"}];
//        }
//    }
//
//    !completion?:completion(isSuccess,isError);
//
//    NSLog(@"XTCalendarEventManager createCalendarEventWithEventIdentifierLocalKey %@",eventIdentifierLocalKey);
    
//}

/**
 *  查日历事件
 *
 *  @param eventIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
//- (EKEvent *)checkCalendarEventWithIdentifier:(NSString *)eventIdentifierLocalKey{
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSLog(@"XTCalendarEventManager checkCalendarEventWithIdentifier 未授权");
//        return nil;
//    }
//
//    NSString *eIdentifier = [XTUserDefault getValueForKey:[self getCalendarItemLocalKey:eventIdentifierLocalKey type:EKEntityTypeEvent]];
//    if (![NSString isBlankString:eIdentifier]) {
//        EKEvent *event = [self.eventStore eventWithIdentifier:eIdentifier];
//        return event;
//    }
//    return nil;
//}

/**
 *  查日历事件(可查询一段时间内的事件)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param modifytitle    标题，为空则都要查询
 */
//- (NSArray *)checkCalendarEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate modifytitle:(NSString * __nullable)modifytitle {
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSLog(@"XTCalendarEventManager checkCalendarEventWithDate 未授权");
//        return nil;
//    }
//
//    // 查询到所有的日历
//    EKCalendar *eventCalendar = [self findCustomCalendar:EKEntityTypeEvent];
//
//    if (!eventCalendar) {
//        eventCalendar = [self.eventStore defaultCalendarForNewEvents];
//    }
//
//    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:@[eventCalendar]];
//
//    // 获取到范围内的所有事件
//    NSArray *request = [self.eventStore eventsMatchingPredicate:predicate];
//    // 按开始事件进行排序
//    request = [request sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
//
//    if ([NSString isBlankString:modifytitle]) {
//        return request;
//    }else{
//        NSMutableArray *onlyRequest = [NSMutableArray array];
//        for (int i = 0; i < request.count; i++) {
//            EKEvent *event = request[i];
//            if (event.title && [event.title isEqualToString:modifytitle]) {
//                [onlyRequest addObject:event];
//            }
//        }
//        return onlyRequest;
//    }
//}


/**
 *  删除日历事件(删除单个)
 *
 *  @param eventIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
//- (BOOL)deleteCalendarEventWithIdentifier:(NSString *)eventIdentifierLocalKey{
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSLog(@"XTCalendarEventManager deleteCalendarEventWithIdentifier 未授权");
//        return NO;
//    }
//
//    BOOL isDelete = NO;
//
//    NSString *eIdentifier = [XTUserDefault getValueForKey:[self getCalendarItemLocalKey:eventIdentifierLocalKey type:EKEntityTypeEvent]];
//    EKEvent *event;
//    if (![NSString isBlankString:eIdentifier]) {
//        event = [self.eventStore eventWithIdentifier:eIdentifier];
//        isDelete = [self.eventStore removeEvent:event span:EKSpanThisEvent error:nil];
//    }
//    NSLog(@"XTCalendarEventManager deleteCalendarEventWithIdentifier %@ %d",eventIdentifierLocalKey,isDelete);
//    return isDelete;
//}

/**
 *  删除日历事件(可删除一段时间内的事件)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param modifytitle    标题，为空则都要删除
 */
//- (BOOL)deleteCalendarEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate modifytitle:(NSString * __nullable)modifytitle {
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSLog(@"XTCalendarEventManager deleteCalendarEventWithDate 未授权");
//        return NO;
//    }
//
//    // 获取到此事件
//    NSArray *request = [self checkCalendarEventWithStartDate:startDate endDate:endDate modifytitle:modifytitle];
//
//    for (int i = 0; i < request.count; i ++) {
//        // 删除这一条事件
//        EKEvent *event = request[i];
//        NSError*error =nil;
//        // commit:NO：最后再一次性提交
//        [self.eventStore removeEvent:event span:EKSpanThisEvent commit:NO error:&error];
//    }
//    //一次提交所有操作到事件库
//    NSError *errored = nil;
//    BOOL commitSuccess= [self.eventStore commit:&errored];
//    return commitSuccess;
//}

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
//- (void)modifyCalendarEventWithEventIdentifierLocalKey:(NSString *)eventIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray <NSString *> * __nullable)alarmArray url:(NSURL * __nullable)url completion:(CalendarCompletion)completion{
//
//    if (![self checkCaledarAuthority:EKEntityTypeEvent]) {
//        NSError * authorityError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"未授权"}];
//        !completion?:completion(NO,authorityError);
//        return;
//    }
//
//    // 获取到此事件
//    EKEvent *event = [self checkCalendarEventWithIdentifier:eventIdentifierLocalKey];
//    if (event) {
//        BOOL isDelete = [self deleteCalendarEventWithIdentifier:eventIdentifierLocalKey];
//        NSLog(@"XTCalendarEventManager modify delete %d",isDelete);
//        [self createCalendarEventWithEventIdentifierLocalKey:eventIdentifierLocalKey calendarTitle:title notes:notes startDate:startDate endDate:endDate allDay:allDay alarmArray:alarmArray url:url completion:completion];
//    }else{
//        // 没有此条日历
//        [self createCalendarEventWithEventIdentifierLocalKey:eventIdentifierLocalKey calendarTitle:title notes:notes startDate:startDate endDate:endDate allDay:allDay alarmArray:alarmArray url:url completion:completion];
//
//    }
//}

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
//- (void)createCalendarReminderWithReminderIdentifierLocalKey:(NSString *)reminderIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate dueDate:(NSDate *)dueDate alarmDate:(NSDate *)alarmDate url:(NSURL * __nullable)url completion:(CalendarCompletion)completion {
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        NSError * authorityError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"未授权"}];
//        !completion?:completion(NO,authorityError);
//        return;
//    }
//
//    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
//    reminder.title = title;
//    reminder.notes = notes;
//    reminder.URL = url?:[NSURL URLWithString:@"xtcloudmeeting://"];
//
//    reminder.startDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:startDate];
//    reminder.dueDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:dueDate];
//
//    //添加闹钟提醒
//    [reminder addAlarm:[EKAlarm alarmWithAbsoluteDate:alarmDate]];
//
//    // 存储到日历源中
//    EKCalendar *reminderCalendar = [self findCustomCalendar:EKEntityTypeReminder];
//    if (reminderCalendar) {
//        [reminder setCalendar:reminderCalendar];
//    }else{
//        [reminder setCalendar:self.eventStore.defaultCalendarForNewReminders];
//    }
//
//    NSError *error = nil;
//    BOOL isSuccess = [self.eventStore saveReminder:reminder commit:YES error:&error];
//
//    if (!error) {
//        if (![NSString isBlankString:reminder.calendarItemIdentifier] && ![NSString isBlankString:reminderIdentifierLocalKey]) {
//            [XTUserDefault setValue:reminder.calendarItemIdentifier forKey:[self getCalendarItemLocalKey:reminderIdentifierLocalKey type:EKEntityTypeReminder]];
//        }else{
//            isSuccess = NO;
//            error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"eventIdentifier不存在"}];
//        }
//
//    }else{
//        isSuccess = NO;
//    }
//
//    !completion?:completion(isSuccess,error);
//
//    NSLog(@"XTCalendarEventManager createCalendarReminderWithReminderIdentifierLocalKey %@",reminderIdentifierLocalKey);
//
//}


/**
 *  查Reminder提醒项
 *
 *  @param reminderIdentifierLocalKey    事件ID(标识符) 本地存储Key
 */
//- (EKReminder *)checkCalendarReminderWithIdentifier:(NSString *)reminderIdentifierLocalKey{
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        NSLog(@"XTCalendarEventManager checkCalendarReminderWithIdentifier 未授权");
//        return nil;
//    }
//    NSString *eIdentifier = [XTUserDefault getValueForKey:[self getCalendarItemLocalKey:reminderIdentifierLocalKey type:EKEntityTypeReminder]];
//    if (![NSString isBlankString:eIdentifier]) {
//        EKCalendarItem *calendarItem = [self.eventStore calendarItemWithIdentifier:eIdentifier];
//        if ([calendarItem isKindOfClass:[EKReminder class]]) {
//            return (EKReminder *)calendarItem;
//        }
//        return nil;
//    }
//    return nil;
//}

/**
 *  查询Reminder提醒事项 （一段时间）(以dueDate为参照)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param completion 回调方法
 */
//- (void)checkCalendarIncompleteRemindersWithDueDateStarting:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate completion:(CalendarFetchDataCompletion)completion{
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        !completion?:completion(nil);
//        return;
//    }
//
//    EKCalendar *reminderCalendar = [self findCustomCalendar:EKEntityTypeReminder];
//
//    if (!reminderCalendar) {
//        reminderCalendar = [self.eventStore defaultCalendarForNewReminders];
//    }
//
//    NSPredicate *predicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:startDate ending:endDate calendars:@[reminderCalendar]];
//
//    [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray<EKReminder *> * _Nullable reminders) {
//        !completion?:completion(reminders);
//    }];
//}



/**
 *  删除Reminber(删除单个)
 *
 *  @param reminderIdentifierLocalKey    reminder ID(标识符) 本地存储Key
 */
//- (BOOL)deleteCalendarReminderWithIdentifier:(NSString *)reminderIdentifierLocalKey {
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        NSLog(@"XTCalendarEventManager deleteCalendarReminderWithIdentifier 未授权");
//        return NO;
//    }
//
//    BOOL isDelete = NO;
//    EKReminder *reminder = [self checkCalendarReminderWithIdentifier:reminderIdentifierLocalKey];
//    if (reminder) {
//        isDelete = [self.eventStore removeReminder:reminder commit:YES error:nil];
//    }
//    NSLog(@"XTCalendarEventManager deleteCalendarReminderWithIdentifier %@ %d",reminderIdentifierLocalKey,isDelete);
//    return isDelete;
//}

/**
 *  删除Reminder提醒事项 （一段时间）(以dueDate为参照)
 *
 *  @param startDate  开始时间
 *  @param endDate    结束时间
 *  @param completion 回调方法
 */

//- (void)deleteCalendarIncompleteRemindersWithDueDateStarting:(nullable NSDate *)startDate endDate:(nullable NSDate *)endDate completion:(CalendarCompletion)completion{
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        NSError * authorityError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"未授权"}];
//        !completion?:completion(NO,authorityError);
//        return;
//    }
//
//    weakify_self
//    [self checkCalendarIncompleteRemindersWithDueDateStarting:startDate endDate:endDate completion:^(NSArray *itemArray) {
//        strongify_self
//        for (int i=0; i<itemArray.count; i++) {
//            EKReminder *tempReminder = (EKReminder *)[itemArray objectAtIndex:i];
//            [self.eventStore removeReminder:tempReminder commit:NO error:nil];
//        }
//        NSError *error = nil;
//        BOOL commitSucces = [self.eventStore commit:&error];
//        !completion?:completion(commitSucces,error);
//    }];
//}

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
//- (void)modifyCalendarReminderWithReminderIdentifierLocalKey:(NSString *)reminderIdentifierLocalKey calendarTitle:(NSString *)title notes:(NSString * __nullable)notes startDate:(NSDate *)startDate dueDate:(NSDate *)dueDate alarmDate:(NSDate *)alarmDate url:(NSURL * __nullable)url completion:(CalendarCompletion)completion {
//
//    if (![self checkCaledarAuthority:EKEntityTypeReminder]) {
//        NSError * authorityError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:@{NSLocalizedDescriptionKey : @"未授权"}];
//        !completion?:completion(NO,authorityError);
//        return;
//    }
//
//    EKReminder *tempReminder = [self checkCalendarReminderWithIdentifier:reminderIdentifierLocalKey];
//    if (tempReminder) {
//        [self deleteCalendarReminderWithIdentifier:reminderIdentifierLocalKey];
//        [self createCalendarReminderWithReminderIdentifierLocalKey:reminderIdentifierLocalKey calendarTitle:title notes:notes startDate:startDate dueDate:dueDate alarmDate:alarmDate url:url completion:completion];
//    }else{
//        [self createCalendarReminderWithReminderIdentifierLocalKey:reminderIdentifierLocalKey calendarTitle:title notes:notes startDate:startDate dueDate:dueDate alarmDate:alarmDate url:url completion:completion];
//    }
//
//}


#pragma mark - Pravite -
- (EKSource *)getAvailableCalendarSource {
    EKSource *localSource = nil;
    for (EKSource *source in self.eventStore.sources){
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]){
            localSource = source;
            break;
        }
    }
    if (localSource == nil){
        for (EKSource *source in self.eventStore.sources){
            if (source.sourceType == EKSourceTypeLocal){
                localSource = source;
                break;
            }
        }
    }
    
    if (localSource == nil) {
        NSLog(@"XTCalendarEventManager getAvailableCalendarSource error");
    }
    
    return localSource;
}

//- (EKCalendar *)findCustomCalendar:(EKEntityType)entityType {
//
//    EKCalendar *customCalendar = nil;
//    NSString *calendarIdentifer = nil;
//
//    if (entityType == EKEntityTypeEvent) {
//        calendarIdentifer = [XTUserDefault getValueForKey:kEventCalendarIdentifierLocalKey];
//    }else{
//        calendarIdentifer = [XTUserDefault getValueForKey:kReminderCalendarIdentifierLocalKey];
//    }
//
//    if (![NSString isBlankString:calendarIdentifer]) {
//        NSArray *tempCalendarArray = [self.eventStore calendarsForEntityType:entityType];
//        for (int i = 0 ; i < tempCalendarArray.count; i ++) {
//            EKCalendar *temCalendar = tempCalendarArray[i];
//            if ([temCalendar.calendarIdentifier isEqualToString:calendarIdentifer]) {
//                customCalendar = temCalendar;
//                break;
//            }
//        }
//    }
//    return customCalendar;
//
//}

- (NSString *)getCalendarItemLocalKey:(NSString *)identifierString type:(EKEntityType)type {
    NSString *localKey = nil;
    if (type == EKEntityTypeEvent) {
        localKey = [NSString stringWithFormat:@"%@_%@",kEventIdentifier,identifierString];
    }else{
        localKey = [NSString stringWithFormat:@"%@_%@",kReminderIIdentifier,identifierString];
    }
    return localKey;
}

//- (BOOL)checkCaledarAuthority:(EKEntityType)type {
//    BOOL isAuthority = NO;
//    XTAuthorityStatus status = XTAuthorityStatusNotDetermined;
//    if (type == EKEntityTypeEvent) {
//        status = [[XTAuthorityManager sharedInstance] checkCalendarAuthority];
//    }else {
//        status = [[XTAuthorityManager sharedInstance] checkReminderAuthority];
//    }
//
//    if (status == XTAuthorityStatusAuthorized) {
//        isAuthority = YES;
//    }
//    return isAuthority;
//
//}
@end
