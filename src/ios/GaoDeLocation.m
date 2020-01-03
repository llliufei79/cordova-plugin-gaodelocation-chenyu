/********* GaoDeLocation.m Cordova Plugin Implementation *******/

#import "GaoDeLocation.h"
#import "SerialLocation.h"

@implementation GaoDeLocation
- (void)pluginInitialize {
    self.IOS_API_KEY = [self.commandDelegate settings][@"ios_api_key"];

    [AMapServices sharedServices].apiKey = self.IOS_API_KEY;

    self.singleLocaiton = [SingleLocaiton alloc].init;

    self.singleLocaiton.delegate = self;

    self.serialLocation = [SerialLocation alloc].init;

    self.serialLocation.delegate = self;
}


/*
 * 单次定位
 *
 */
- (void)getCurrentPosition:(CDVInvokedUrlCommand *)command {

    [self.singleLocaiton reGeocodeAction];

    self.singleCallbackId = command.callbackId;

}

/*
 * 持续定位
 */
- (void)startSerialLocation:(CDVInvokedUrlCommand *)command {

    [self.serialLocation startSerialLocation];

    self.serialCallbackId = command.callbackId;
}

- (void)stopSerialLocation:(CDVInvokedUrlCommand *)command {
    [self.serialLocation stopSerialLocation];

    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];

    mDict[@"code"] = @"200";

    CDVPluginResult *pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mDict];

    [pluginResult setKeepCallback:@(true)];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - SingleLocaiton Delegate

- (void)PositionInfo:(CLLocation *)location Regeocode:(AMapLocationReGeocode *)regeocode {
    [self sendPositionInfo:location Regeocode:regeocode callbackId:self.singleCallbackId];
}

#pragma mark - SerialLocation Delegate

- (void)SerialLocationInfo:(CLLocation *)location Regeocode:(AMapLocationReGeocode *)regeocode {
    [self sendPositionInfo:location Regeocode:regeocode callbackId:self.serialCallbackId];
}

#pragma mark - sendPluginResult

- (void)sendPositionInfo:(CLLocation *)location Regeocode:(AMapLocationReGeocode *)regeocode callbackId:(NSString *)callbackId {

    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];

    mDict[@"code"] = @"200";

    mDict[@"latitude"] = @(location.coordinate.latitude);

    mDict[@"longitude"] = @(location.coordinate.longitude);

    mDict[@"accuracy"] = @(location.horizontalAccuracy);

    if (regeocode) {

        mDict[@"formattedAddress"] = regeocode.formattedAddress;

        mDict[@"country"] = regeocode.country;

        mDict[@"province"] = regeocode.province;

        mDict[@"city"] = regeocode.city;

        mDict[@"district"] = regeocode.district;

        mDict[@"citycode"] = regeocode.citycode;

        mDict[@"adcode"] = regeocode.adcode;

        mDict[@"street"] = regeocode.street;

        mDict[@"number"] = regeocode.number;

        mDict[@"POIName"] = regeocode.POIName;

        mDict[@"AOIName"] = regeocode.AOIName;
    }

    CDVPluginResult *pluginResult = nil;

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:mDict];

    [pluginResult setKeepCallback:@(true)];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
}

- (void)sendError:(CLLocation *)location Regeocode:(AMapLocationReGeocode *)regeocode callbackId:(NSString *)callbackId{

}


@end
