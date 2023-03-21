//
//  RadarSettings.m
//  RadarSDK
//
//  Copyright © 2019 Radar Labs, Inc. All rights reserved.
//

#import "RadarSettings.h"

#import "Radar+Internal.h"
#import "RadarLogger.h"
#import "RadarTripOptions.h"

@implementation RadarSettings

static NSString *const kPublishableKey = @"radar-publishableKey";
static NSString *const kInstallId = @"radar-installId";
static NSString *const kSessionId = @"radar-sessionId";
static NSString *const kId = @"radar-_id";
static NSString *const kUserId = @"radar-userId";
static NSString *const kDescription = @"radar-description";
static NSString *const kMetadata = @"radar-metadata";
static NSString *const kAnonymous = @"radar-anonymous";
static NSString *const kAdIdEnabled = @"radar-adIdEnabled";
static NSString *const kTracking = @"radar-tracking";
static NSString *const kTrackingOptions = @"radar-trackingOptions";
static NSString *const kPreviousTrackingOptions = @"radar-previousTrackingOptions";
static NSString *const kRemoteTrackingOptions = @"radar-remoteTrackingOptions";
static NSString *const kTripOptions = @"radar-tripOptions";
static NSString *const kLogLevel = @"radar-logLevel";
static NSString *const kBeaconUUIDs = @"radar-beaconUUIDs";
static NSString *const kHost = @"radar-host";
static NSString *const kDefaultHost = @"https://api.radar.io";
static NSString *const kLastTrackedTime = @"radar-lastTrackedTime";
static NSString *const kVerifiedHost = @"radar-verifiedHost";
static NSString *const kDefaultVerifiedHost = @"https://api-verified.radar.io";
static NSString *const kLastAppOpenTime = @"radar-lastAppOpenTime";

+ (NSString *)publishableKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kPublishableKey];
}

+ (void)setPublishableKey:(NSString *)publishableKey {
    [[NSUserDefaults standardUserDefaults] setObject:publishableKey forKey:kPublishableKey];
}

+ (NSString *)installId {
    NSString *installId = [[NSUserDefaults standardUserDefaults] stringForKey:kInstallId];
    if (!installId) {
        installId = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:installId forKey:kInstallId];
    }
    return installId;
}

+ (NSString *)sessionId {
    return [NSString stringWithFormat:@"%.f", [[NSUserDefaults standardUserDefaults] doubleForKey:kSessionId]];
}

+ (BOOL)updateSessionId {
    [[RadarLogger sharedInstance] logWithLevel:RadarLogLevelDebug message:[NSString stringWithFormat:@"New call to updateSessionId"]];
    double timestampSeconds = [[NSDate date] timeIntervalSince1970];
    double sessionIdSeconds = [[NSUserDefaults standardUserDefaults] doubleForKey:kSessionId];
    if (timestampSeconds - sessionIdSeconds > 300) {
        [[NSUserDefaults standardUserDefaults] setDouble:timestampSeconds forKey:kSessionId];

        [Radar logOpenedAppConversion];
        
        [[RadarLogger sharedInstance] logWithLevel:RadarLogLevelDebug message:[NSString stringWithFormat:@"New session (TEST) | sessionId = %@", [RadarSettings sessionId]]];

        return YES;
    }
    return NO;
}

+ (NSString *)_id {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kId];
}

+ (void)setId:(NSString *)_id {
    [[NSUserDefaults standardUserDefaults] setObject:_id forKey:kId];
}

+ (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserId];
}

+ (void)setUserId:(NSString *)userId {
    NSString *oldUserId = [[NSUserDefaults standardUserDefaults] stringForKey:kUserId];
    if (oldUserId && ![oldUserId isEqualToString:userId]) {
        [RadarSettings setId:nil];
    }
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kUserId];
}

+ (NSString *)__description {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kDescription];
}

+ (void)setDescription:(NSString *)description {
    [[NSUserDefaults standardUserDefaults] setObject:description forKey:kDescription];
}

+ (NSDictionary *)metadata {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:kMetadata];
}

+ (void)setMetadata:(NSString *)metadata {
    [[NSUserDefaults standardUserDefaults] setObject:metadata forKey:kMetadata];
}

+ (BOOL)anonymousTrackingEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAnonymous];
}

+ (void)setAnonymousTrackingEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kAnonymous];
}

+ (BOOL)adIdEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAdIdEnabled];
}

+ (void)setAdIdEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:kAdIdEnabled];
}

+ (BOOL)tracking {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTracking];
}

+ (void)setTracking:(BOOL)tracking {
    [[NSUserDefaults standardUserDefaults] setBool:tracking forKey:kTracking];
}

+ (RadarTrackingOptions *)trackingOptions {
    NSDictionary *optionsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kTrackingOptions];

    if (optionsDict != nil) {
        return [RadarTrackingOptions trackingOptionsFromDictionary:optionsDict];
    } else {
        return nil;
    }
}

+ (void)setTrackingOptions:(RadarTrackingOptions *)options {
    NSDictionary *optionsDict = [options dictionaryValue];
    [[NSUserDefaults standardUserDefaults] setObject:optionsDict forKey:kTrackingOptions];
}

+ (void)removeTrackingOptions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTrackingOptions];
}

+ (RadarTrackingOptions *)previousTrackingOptions {
    NSDictionary *optionsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kPreviousTrackingOptions];

    if (optionsDict != nil) {
        return [RadarTrackingOptions trackingOptionsFromDictionary:optionsDict];
    } else {
        return nil;
    }
}

+ (void)setPreviousTrackingOptions:(RadarTrackingOptions *)options {
    NSDictionary *optionsDict = [options dictionaryValue];
    [[NSUserDefaults standardUserDefaults] setObject:optionsDict forKey:kPreviousTrackingOptions];
}

+ (void)removePreviousTrackingOptions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPreviousTrackingOptions];
}

+ (RadarTrackingOptions *_Nullable)remoteTrackingOptions {
    NSDictionary *optionsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kRemoteTrackingOptions];

    return optionsDict ? [RadarTrackingOptions trackingOptionsFromDictionary:optionsDict] : nil;
}

+ (void)setRemoteTrackingOptions:(RadarTrackingOptions *_Nonnull)options {
    NSDictionary *optionsDict = [options dictionaryValue];
    [[NSUserDefaults standardUserDefaults] setObject:optionsDict forKey:kRemoteTrackingOptions];
}

+ (void)removeRemoteTrackingOptions {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRemoteTrackingOptions];
}

+ (RadarTripOptions *)tripOptions {
    NSDictionary *optionsDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kTripOptions];

    if (optionsDict != nil) {
        return [RadarTripOptions tripOptionsFromDictionary:optionsDict];
    } else {
        return nil;
    }
}

+ (void)setTripOptions:(RadarTripOptions *)options {
    if (options) {
        NSDictionary *optionsDict = [options dictionaryValue];
        [[NSUserDefaults standardUserDefaults] setObject:optionsDict forKey:kTripOptions];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTripOptions];
    }
}

+ (RadarLogLevel)logLevel {
    RadarLogLevel logLevel;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kLogLevel] == nil) {
        logLevel = RadarLogLevelInfo;
    } else {
        logLevel = (RadarLogLevel)[[NSUserDefaults standardUserDefaults] integerForKey:kLogLevel];
    }
    return logLevel;
}

+ (void)setLogLevel:(RadarLogLevel)level {
    NSInteger logLevelInteger = (int)level;
    [[NSUserDefaults standardUserDefaults] setInteger:logLevelInteger forKey:kLogLevel];
}

+ (NSArray<NSString *> *_Nullable)beaconUUIDs {
    NSArray<NSString *> *beaconUUIDs = [[NSUserDefaults standardUserDefaults] valueForKey:kBeaconUUIDs];
    return beaconUUIDs;
}

+ (void)setBeaconUUIDs:(NSArray<NSString *> *_Nullable)beaconUUIDs {
    [[NSUserDefaults standardUserDefaults] setValue:beaconUUIDs forKey:kBeaconUUIDs];
}

+ (NSString *)host {
    NSString *host = [[NSUserDefaults standardUserDefaults] stringForKey:kHost];
    return host ? host : kDefaultHost;
}

+ (void)updateLastTrackedTime {
    NSDate *timeStamp = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:kLastTrackedTime];
}

+ (NSDate *)lastTrackedTime {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kLastTrackedTime];
}

+ (NSString *)verifiedHost {
    NSString *verifiedHost = [[NSUserDefaults standardUserDefaults] stringForKey:kVerifiedHost];
    return verifiedHost ? verifiedHost : kDefaultVerifiedHost;
}

+ (void)updateLastAppOpenTime {
    NSDate *timeStamp = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:timeStamp forKey:kLastAppOpenTime];
}

+ (NSDate *)lastAppOpenTime {
    return [[NSUserDefaults standardUserDefaults] valueForKey:kLastAppOpenTime];
}

@end
