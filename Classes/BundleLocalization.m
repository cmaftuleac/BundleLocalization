//    The MIT License (MIT)
//
//    Copyright (c) 2015 Corneliu Maftuleac
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

#import "BundleLocalization.h"
#import "NSBundle+Localization.h"

NSString *const kBundleLocalizationChangedNotification = @"kBundleLocalizationChangedNotification";


@implementation BundleLocalization
{
    NSString* selectedLanguage;
}

+ (BundleLocalization*) sharedInstance {
    @synchronized(self) {
        static BundleLocalization* instance = nil;
        if (instance == nil) {
            instance = [[BundleLocalization alloc] init];
        }
        return instance;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
        _localizationBundle = [NSBundle mainBundle];
    }
    return self;
}

- (void) setLanguage:(NSString*) lang {
    // path to this languages bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj" ];
    if (path == nil) {
        // there is no bundle for that language
        // use main bundle instead
        _localizationBundle = [NSBundle mainBundle];
    } else {
        // use this bundle as my bundle from now on:
        _localizationBundle = [NSBundle bundleWithPath:path];
        // to be absolutely sure (this is probably unnecessary):
        if (_localizationBundle == nil) {
            _localizationBundle = [NSBundle mainBundle];
        }
        selectedLanguage = lang;
    }

    // Set the language so system frameworks will be localized also.
    // This requires an app restart to take effect.
    [[NSUserDefaults standardUserDefaults] setObject:@[lang] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] postNotificationName:kBundleLocalizationChangedNotification object:nil];
}

- (NSString*) language{
    if(_localizationBundle == [NSBundle mainBundle]) {
        return [[NSBundle mainBundle] preferredLocalizations].firstObject;
    }else {
        return selectedLanguage;
    }
}

@end