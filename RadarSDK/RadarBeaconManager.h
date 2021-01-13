//
//  RadarBeaconManager.h
//  RadarSDK
//
//  Copyright © 2020 Radar Labs, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "Radar.h"
#import "RadarBeacon.h"
#import "RadarPermissionsHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface RadarBeaconManager : NSObject<CLLocationManagerDelegate>

@property (nullable, weak, nonatomic) id<RadarDelegate> delegate;
@property (nonnull, strong, nonatomic) CLLocationManager *locationManager;
@property (nonnull, strong, nonatomic) RadarPermissionsHelper *permissionsHelper;

+ (instancetype)sharedInstance;
- (void)rangeBeacons:(NSArray<RadarBeacon *> *_Nonnull)beacons completionHandler:(RadarBeaconCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
