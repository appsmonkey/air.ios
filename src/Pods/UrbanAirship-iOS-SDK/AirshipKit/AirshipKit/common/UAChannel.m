/* Copyright Airship and Contributors */

#import "UAChannel+Internal.h"
#import "UAChannelRegistrar+Internal.h"
#import "UATagGroupsRegistrar+Internal.h"
#import "UATagUtils+Internal.h"
#import "UAUtils+Internal.h"
#import "UAChannelRegistrationPayload+Internal.h"
#import "UAUser+Internal.h"
#import "UAAppStateTrackerFactory+Internal.h"
#import "UAAttributePendingMutations+Internal.h"
#import "UADate+Internal.h"

NSString *const UAChannelTagsSettingsKey = @"com.urbanairship.channel.tags";

NSString *const UAChannelDefaultDeviceTagGroup = @"device";

NSString *const UAChannelCreatedEvent = @"com.urbanairship.channel.channel_created";
NSString *const UAChannelUpdatedEvent = @"com.urbanairship.channel.channel_updated";
NSString *const UAChannelRegistrationFailedEvent = @"com.urbanairship.channel.registration_failed";

NSString *const UAChannelCreatedEventChannelKey = @"com.urbanairship.channel.identifier";
NSString *const UAChannelCreatedEventExistingKey = @"com.urbanairship.channel.existing";

NSString *const UAChannelUpdatedEventChannelKey = @"com.urbanairship.channel.identifier";

NSString *const UAChannelCreationOnForeground = @"com.urbanairship.channel.creation_on_foreground";

@interface UAChannel ()
@property (nonatomic, strong) UAPreferenceDataStore *dataStore;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) UAChannelRegistrar *channelRegistrar;
@property (nonatomic, strong) UATagGroupsRegistrar *tagGroupsRegistrar;
@property (nonatomic, strong) UAAttributeRegistrar *attributeRegistrar;

@property (nonatomic, strong) id<UAAppStateTracker> appStateTracker;
@property (nonatomic, assign) BOOL shouldPerformChannelRegistrationOnForeground;
@property (nonatomic, strong) UADate *date;

@end

@implementation UAChannel

- (instancetype)initWithDataStore:(UAPreferenceDataStore *)dataStore
                           config:(UARuntimeConfig *)config
               notificationCenter:(NSNotificationCenter *)notificationCenter
                 channelRegistrar:(UAChannelRegistrar *)channelRegistrar
               tagGroupsRegistrar:(UATagGroupsRegistrar *)tagGroupsRegistrar
               attributeRegistrar:(UAAttributeRegistrar *)attributeRegistrar
                  appStateTracker:(id<UAAppStateTracker>)appStateTracker
                             date:(UADate *)date {
    self = [super initWithDataStore:dataStore];

    if (self) {
        self.dataStore = dataStore;
        self.notificationCenter = notificationCenter;
        self.channelRegistrar = channelRegistrar;
        self.channelRegistrar.delegate = self;
        self.tagGroupsRegistrar = tagGroupsRegistrar;
        self.attributeRegistrar = attributeRegistrar;
        self.appStateTracker = appStateTracker;
        self.appStateTracker.stateTrackerDelegate = self;
        self.channelTagRegistrationEnabled = YES;
        self.date = date;

        // Check config to see if user wants to delay channel creation
        // If channel ID exists or channel creation delay is disabled then channelCreationEnabled
        if (self.identifier || !config.isChannelCreationDelayEnabled) {
            self.channelCreationEnabled = YES;
        } else {
            UA_LDEBUG(@"Channel creation disabled.");
            self.channelCreationEnabled = NO;
        }

        // Log the channel ID at error level, but without logging
        // it as an error.
        if (self.identifier && uaLogLevel >= UALogLevelError) {
            NSLog(@"Channel ID: %@", self.identifier);
        }

        [self observeNotificationCenterEvents];
    }

    return self;
}

+ (instancetype)channelWithDataStore:(UAPreferenceDataStore *)dataStore
                              config:(UARuntimeConfig *)config
                  notificationCenter:(NSNotificationCenter *)notificationCenter
                    channelRegistrar:(UAChannelRegistrar *)channelRegistrar
                  tagGroupsRegistrar:(UATagGroupsRegistrar *)tagGroupsRegistrar {
    return [[self alloc] initWithDataStore:dataStore
                                    config:config
                        notificationCenter:notificationCenter
                          channelRegistrar:channelRegistrar
                        tagGroupsRegistrar:tagGroupsRegistrar
                        attributeRegistrar:[UAAttributeRegistrar registrarWithConfig:config
                                                                           dataStore:dataStore]
                           appStateTracker:[UAAppStateTrackerFactory tracker]
                                      date:[[UADate alloc] init]];
}

+ (instancetype)channelWithDataStore:(UAPreferenceDataStore *)dataStore
                              config:(UARuntimeConfig *)config
                  notificationCenter:(NSNotificationCenter *)notificationCenter
                    channelRegistrar:(UAChannelRegistrar *)channelRegistrar
                  tagGroupsRegistrar:(UATagGroupsRegistrar *)tagGroupsRegistrar
                  attributeRegistrar:(UAAttributeRegistrar *)attributeRegistrar
                     appStateTracker:(id<UAAppStateTracker>)appStateTracker
                                date:(UADate *)date {
    return [[self alloc] initWithDataStore:dataStore
                                    config:config
                        notificationCenter:notificationCenter
                          channelRegistrar:channelRegistrar
                        tagGroupsRegistrar:tagGroupsRegistrar
                        attributeRegistrar:attributeRegistrar
                           appStateTracker:appStateTracker
                                      date:date];
}

- (void)observeNotificationCenterEvents {
    [self.notificationCenter addObserver:self
                                selector:@selector(applicationBackgroundRefreshStatusChanged)
                                    name:UIApplicationBackgroundRefreshStatusDidChangeNotification
                                  object:nil];
}

- (void)reset {
    [self.channelRegistrar resetChannel];
}

- (NSString *)identifier {
    return self.channelRegistrar.channelID;
}

- (BOOL)shouldPerformChannelRegistrationOnForeground {
    return [self.dataStore boolForKey:UAChannelCreationOnForeground];
}

- (void)setShouldPerformChannelRegistrationOnForeground:(BOOL)value {
    [self.dataStore setBool:value forKey:UAChannelCreationOnForeground];
}

#pragma mark -
#pragma mark Application State Observation

- (void)applicationDidTransitionToForeground {
    if (self.shouldPerformChannelRegistrationOnForeground) {
        UA_LTRACE(@"Application did become active. Updating registration.");
        [self updateRegistration];
    }
}

- (void)applicationDidEnterBackground {
    // Enable forground channel registration after first run
    self.shouldPerformChannelRegistrationOnForeground = YES;

    // Create a channel if we do not have a channel ID
    if (!self.identifier) {
        UA_LTRACE(@"Application entered the background without a channel ID. Updating registration.");
        [self updateRegistration];
    }
}

- (void)applicationBackgroundRefreshStatusChanged {
    UA_LTRACE(@"Background refresh status changed.");
    [self updateRegistration];
}

#pragma mark -
#pragma mark Channel Tags

- (NSArray *)tags {
    NSArray *currentTags = [self.dataStore objectForKey:UAChannelTagsSettingsKey];
    if (!currentTags) {
        currentTags = [NSArray array];
    }
    return currentTags;
}

- (void)setTags:(NSArray *)tags {
    [self.dataStore setObject:[UATagUtils normalizeTags:tags] forKey:UAChannelTagsSettingsKey];
}

- (void)addTag:(NSString *)tag {
    [self addTags:[NSArray arrayWithObject:tag]];
}

- (void)addTags:(NSArray *)tags {
    NSMutableSet *updatedTags = [NSMutableSet setWithArray:self.tags];
    [updatedTags addObjectsFromArray:tags];
    [self setTags:[updatedTags allObjects]];
}

- (void)removeTag:(NSString *)tag {
    [self removeTags:[NSArray arrayWithObject:tag]];
}

- (void)removeTags:(NSArray *)tags {
    NSMutableArray *mutableTags = [NSMutableArray arrayWithArray:self.tags];
    [mutableTags removeObjectsInArray:tags];
    [self.dataStore setObject:mutableTags forKey:UAChannelTagsSettingsKey];
}

#pragma mark -
#pragma mark Tag Groups

- (void)addTags:(NSArray *)tags group:(NSString *)tagGroupID {
    if (self.channelTagRegistrationEnabled && [UAChannelDefaultDeviceTagGroup isEqualToString:tagGroupID]) {
        UA_LERR(@"Unable to add tags %@ to device tag group when channelTagRegistrationEnabled is true.", [tags description]);
        return;
    }

    [self.tagGroupsRegistrar addTags:tags group:tagGroupID type:UATagGroupsTypeChannel];
}

- (void)removeTags:(NSArray *)tags group:(NSString *)tagGroupID {
    if (self.channelTagRegistrationEnabled && [UAChannelDefaultDeviceTagGroup isEqualToString:tagGroupID]) {
        UA_LERR(@"Unable to remove tags %@ from device tag group when channelTagRegistrationEnabled is true.", [tags description]);
        return;
    }

    [self.tagGroupsRegistrar removeTags:tags group:tagGroupID type:UATagGroupsTypeChannel];
}

- (void)setTags:(NSArray *)tags group:(NSString *)tagGroupID {
    if (self.channelTagRegistrationEnabled && [UAChannelDefaultDeviceTagGroup isEqualToString:tagGroupID]) {
        UA_LERR(@"Unable to set tags %@ for device tag group when channelTagRegistrationEnabled is true.", [tags description]);
        return;
    }

    [self.tagGroupsRegistrar setTags:tags group:tagGroupID type:UATagGroupsTypeChannel];
}

#pragma mark -
#pragma mark Channel Attributes

- (void)applyAttributeMutations:(UAAttributeMutations *)mutations {
    UAAttributePendingMutations *pendingMutations = [UAAttributePendingMutations pendingMutationsWithMutations:mutations date:self.date];

    // Save pending mutations for upload
    [self.attributeRegistrar savePendingMutations:pendingMutations];

    if (!self.identifier) {
          UA_LTRACE(@"Attribute mutations require a valid channel, mutations have been saved for future update.");
          return;
    }

    [self.attributeRegistrar updateAttributesForChannel:self.identifier];
}

#pragma mark -
#pragma mark Registration

- (void)enableChannelCreation {
    if (!self.channelCreationEnabled) {
        self.channelCreationEnabled = YES;
        [self updateRegistration];
    }
}

- (void)updateRegistrationForcefully:(BOOL)forcefully {
    if (!self.componentEnabled) {
        return;
    }

    // Only cancel in flight requests if the channel is already created
    if (!self.channelCreationEnabled) {
        UA_LDEBUG(@"Channel creation is currently disabled.");
        return;
    }

    [self.channelRegistrar registerForcefully:forcefully];
}

- (void)updateRegistration {
    [self updateChannelTagGroups];
    [self updateChannelAttributes];
    [self updateRegistrationForcefully:NO];
}

- (void)updateChannelTagGroups {
    if (!self.componentEnabled) {
        return;
    }

    if (!self.identifier) {
        return;
    }

    [self.tagGroupsRegistrar updateTagGroupsForID:self.identifier type:UATagGroupsTypeChannel];
}

- (void)updateChannelAttributes {
    if (!self.componentEnabled) {
        return;
    }

    if (!self.identifier) {
        return;
    }

    [self.attributeRegistrar updateAttributesForChannel:self.identifier];
}

#pragma mark -
#pragma mark Channel Registrar Delegate

- (void)createChannelPayload:(void (^)(UAChannelRegistrationPayload *))completionHandler
                  dispatcher:(nullable UADispatcher *)dispatcher{

    UA_WEAKIFY(self)
    [UAUtils getDeviceID:^(NSString *deviceID) {
        UA_STRONGIFY(self)
        UAChannelRegistrationPayload *payload = [[UAChannelRegistrationPayload alloc] init];

        payload.deviceID = deviceID;

        payload.setTags = self.channelTagRegistrationEnabled;
        payload.tags = self.channelTagRegistrationEnabled ? [self.tags copy]: nil;

        payload.language = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode];
        payload.country = [[NSLocale autoupdatingCurrentLocale] objectForKey: NSLocaleCountryCode];
        payload.timeZone = [NSTimeZone defaultTimeZone].name;
        payload.locationSettings = [UAirship shared].locationProviderDelegate.locationUpdatesEnabled ? @(YES) : @(NO);
        payload.appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        payload.SDKVersion = [UAirshipVersion get];
        payload.deviceOS = [UIDevice currentDevice].systemVersion;
        payload.deviceModel = [UAUtils deviceModelName];
        payload.carrier = [UAUtils carrierName];

        if (self.pushProviderDelegate.pushTokenRegistrationEnabled) {
            payload.pushAddress = self.pushProviderDelegate.deviceToken;
        }

        payload.optedIn = self.pushProviderDelegate.userPushNotificationsAllowed;
        payload.backgroundEnabled = self.pushProviderDelegate.backgroundPushNotificationsAllowed;

        if (self.pushProviderDelegate.autobadgeEnabled) {
            payload.badge = @(self.pushProviderDelegate.badgeNumber);
        }

        if (self.pushProviderDelegate.timeZone.name && self.pushProviderDelegate.quietTimeEnabled) {
            payload.quietTime = [self.pushProviderDelegate.quietTime copy];
            payload.quietTimeTimeZone = self.pushProviderDelegate.timeZone.name;
        }

        payload.timeZone = self.pushProviderDelegate.timeZone.name;

#if !TARGET_OS_TV   // Inbox not supported on tvOS
        if (self.userProviderDelegate) {
            [self.userProviderDelegate getUserData:^(UAUserData *userData) {
                payload.userID = userData.username;
                completionHandler(payload);
            } dispatcher:dispatcher];
        } else {
            completionHandler(payload);
        }
#else
        completionHandler(payload);
#endif
        
    } dispatcher:dispatcher];
}

- (void)registrationSucceeded {
    UA_LINFO(@"Channel registration updated successfully.");

    NSString *channelID = self.identifier;

    if (!channelID) {
        UA_LWARN(@"Channel ID is nil after successful registration.");
        return;
    }

    [self.notificationCenter postNotificationName:UAChannelUpdatedEvent
                                           object:self
                                         userInfo:@{UAChannelUpdatedEventChannelKey: channelID}];
}

- (void)registrationFailed {
    UA_LINFO(@"Channel registration failed.");

    [self.notificationCenter postNotificationName:UAChannelRegistrationFailedEvent
                                           object:self
                                         userInfo:nil];
}

- (void)channelCreated:(NSString *)channelID
              existing:(BOOL)existing {

    if (channelID) {
        if (uaLogLevel >= UALogLevelError) {
            NSLog(@"Created channel with ID: %@", channelID);
        }

        [self.notificationCenter postNotificationName:UAChannelCreatedEvent
                                               object:self
                                             userInfo:@{UAChannelCreatedEventChannelKey: channelID,
                                                        UAChannelCreatedEventExistingKey: @(existing)}];
    } else {
        UA_LERR(@"Channel creation failed. Missing channelID: %@", channelID);
    }
}

- (void)onComponentEnableChange {
    if (self.componentEnabled) {
        // If component was disabled and is now enabled, register the channel
        [self updateRegistration];
    }
}


@end

