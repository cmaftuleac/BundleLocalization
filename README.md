# BundleLocalization
Workaround for XCode base internationalization to support on-the-fly language change

## Reasoning

Base internationalization is awesome, but sometime not enough.
Sometimes users want to change the language inside an application, rathen than changing on the whole device.
Currently there is no way to change the bundle language while the application is running.

These set of classes are here to do just that!

## Usage

1) Drop the files to your project:

    BundleLocalization.h
    BundleLocalization.m
    NSBundle+Localization.h
    NSBundle+Localization.m

2) Just import and use it

    #import "BundleLocalization.h"
    ...
    [[BundleLocalization sharedInstance] setLanguage:@"fr"];

or

    [BundleLocalization sharedInstance].language = @"de";
    NSLog(@"Application language: %@", [BundleLocalization sharedInstance].language);

Nothing more is required, you can use NSLocalizedString() as usual.


## Notes

Remember that for the nib/storyboards to be translated you need to reload them.


## Implementation details

This implementation works by tweaking inside NSBundle.
The idea is that you override the method localizedStringForKey on the instance of NSBundle object, and then call this method on a different bundle with a different language. 
Simple and elegant fully compatible with all types of resources.

## Lcence

MIT Licence.