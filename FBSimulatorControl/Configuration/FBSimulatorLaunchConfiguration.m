/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBSimulatorLaunchConfiguration.h"
#import "FBSimulatorLaunchConfiguration+Private.h"

#pragma mark Scales

@implementation FBSimulatorLaunchConfiguration_Scale_25

- (NSString *)scaleString
{
  return @"0.25";
}

@end

@implementation FBSimulatorLaunchConfiguration_Scale_50

- (NSString *)scaleString
{
  return @"0.50";
}

@end

@implementation FBSimulatorLaunchConfiguration_Scale_75

- (NSString *)scaleString
{
  return @"0.75";
}

@end

@implementation FBSimulatorLaunchConfiguration_Scale_100

- (NSString *)scaleString
{
  return @"1.00";
}

@end

@implementation FBSimulatorLaunchConfiguration

@synthesize scale = _scale;
@synthesize locale = _locale;

#pragma mark Initializers

+ (instancetype)defaultConfiguration
{
  static dispatch_once_t onceToken;
  static FBSimulatorLaunchConfiguration *configuration;
  dispatch_once(&onceToken, ^{
    id<FBSimulatorLaunchConfiguration_Scale> scale = FBSimulatorLaunchConfiguration_Scale_100.new;
    configuration = [[self alloc] initWithScale:scale locale:nil options:0];
  });
  return configuration;
}

- (instancetype)initWithScale:(id<FBSimulatorLaunchConfiguration_Scale>)scale locale:(NSLocale *)locale options:(FBSimulatorLaunchOptions)options
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _scale = scale;
  _locale = locale;
  _options = options;

  return self;
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
  return [[self.class alloc] initWithScale:self.scale locale:self.locale options:self.options];
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (!self) {
    return nil;
  }

  _scale = [coder decodeObjectForKey:NSStringFromSelector(@selector(scale))];
  _locale = [coder decodeObjectForKey:NSStringFromSelector(@selector(locale))];
  _options = [[coder decodeObjectForKey:NSStringFromSelector(@selector(options))] unsignedIntegerValue];

  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.scale forKey:NSStringFromSelector(@selector(scale))];
  [coder encodeObject:self.locale forKey:NSStringFromSelector(@selector(locale))];
  [coder encodeObject:@(self.options) forKey:NSStringFromSelector(@selector(options))];
}

#pragma mark NSObject

- (BOOL)isEqual:(FBSimulatorLaunchConfiguration *)configuration
{
  if (![configuration isKindOfClass:self.class]) {
    return NO;
  }

  return [self.scaleString isEqualToString:configuration.scaleString] &&
         (self.locale == configuration.locale || [self.locale isEqual:configuration.locale]) &&
         self.options == configuration.options;
}

- (NSUInteger)hash
{
  return self.scaleString.hash ^ self.locale.hash ^ self.options;
}

#pragma mark FBDebugDescribeable

- (NSString *)description
{
  return [NSString stringWithFormat:
    @"Scale %@ | Locale %@ | Options %lu",
    self.scaleString,
    self.locale,
    self.options
  ];
}

- (NSString *)shortDescription
{
  return [self description];
}

- (NSString *)debugDescription
{
  return [self description];
}

#pragma mark FBJSONSerializationDescribeable

- (NSDictionary *)jsonSerializableRepresentation
{
  return @{
    NSStringFromSelector(@selector(scale)) : self.scaleString,
    NSStringFromSelector(@selector(locale)) : self.locale.localeIdentifier ?: NSNull.null
  };
}

#pragma mark Accessors

- (NSString *)scaleString
{
  return self.scale.scaleString;
}

#pragma mark Scale

+ (instancetype)scale25Percent
{
  return [self.defaultConfiguration scale25Percent];
}

- (instancetype)scale25Percent
{
  return [self withScale:FBSimulatorLaunchConfiguration_Scale_25.new];
}

+ (instancetype)scale50Percent
{
  return [self.defaultConfiguration scale50Percent];
}

- (instancetype)scale50Percent
{
  return [self withScale:FBSimulatorLaunchConfiguration_Scale_50.new];
}

+ (instancetype)scale75Percent
{
  return [self.defaultConfiguration scale75Percent];
}

- (instancetype)scale75Percent
{
  return [self withScale:FBSimulatorLaunchConfiguration_Scale_75.new];
}

+ (instancetype)scale100Percent
{
  return [self.defaultConfiguration scale25Percent];
}

- (instancetype)scale100Percent
{
  return [self withScale:FBSimulatorLaunchConfiguration_Scale_100.new];
}

- (instancetype)withScale:(id<FBSimulatorLaunchConfiguration_Scale>)scale
{
  if (!scale) {
    return nil;
  }
  return [[self.class alloc] initWithScale:scale locale:self.locale options:self.options];
}

#pragma mark Locale

+ (instancetype)withLocale:(NSLocale *)locale
{
  return [self.defaultConfiguration withLocale:locale];
}

- (instancetype)withLocale:(NSLocale *)locale
{
  return [[self.class alloc] initWithScale:self.scale locale:locale options:self.options];
}

+ (instancetype)withLocaleNamed:(NSString *)localeName
{
  return [self.defaultConfiguration withLocaleNamed:localeName];
}

- (instancetype)withLocaleNamed:(NSString *)localeIdentifier
{
  return [self withLocale:[NSLocale localeWithLocaleIdentifier:localeIdentifier]];
}

#pragma mark Framebuffer

+ (instancetype)withOptions:(FBSimulatorLaunchOptions)options
{
  return [self.defaultConfiguration withOptions:options];
}

- (instancetype)withOptions:(FBSimulatorLaunchOptions)options
{
  return [[self.class alloc] initWithScale:self.scale locale:self.locale options:options];
}

@end