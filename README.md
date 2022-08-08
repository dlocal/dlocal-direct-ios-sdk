# DLDirectSDK for iOS

Allows you to easily interact with dLocal API from an iOS project.

## Requirements
- Xcode 13+
- iOS 13+

## Installation

Add the following to your `Podfile`:

```
pod 'DLDirectSDK'
```

## How to use

### Create the SDK

##### Swift Sample
```swift 
import DLDirectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    {...}

    var sdk: DLDirect!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        sdk = DLDirectSDK(apiKey: "API KEY", countryCode: "COUNTRY CODE", testMode: true)
        return true
    }
}
```
##### Objective-C Sample
```objectivec
#import "AppDelegate.h"
@import DLDirectSDK;

@interface AppDelegate ()
@property (nonatomic, strong) DLDirect *sdk;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.sdk = [[DLDirect alloc] initWithApiKey:@"API-KEY"
									countryCode:@"COUNTRY CODE"
									   testMode:YES];
    return YES;
}
```

Replace `apiKey` with your key and `countryCode` with the two letter country code, for example "UY" for "Uruguay", or "US" for "United States".

You can find full list of country codes [here](https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes).

Use `testMode` parameter to specify whether you are going to be doing testing with fake data or if you are going to be performing real transactions.

If your app is using SwiftUI and doesn't have a custom AppDelegate, put the equivalent code inside the init of the App struct like so:

##### Swift
```swift 
import DLDirectSDK

@main
struct ExampleApp: App {

    let sdk: DLDirect

    init() {
        sdk = DLDirect(apiKey: "API KEY", countryCode: "COUNTRY CODE", testMode: true)
    }
}
```

### Tokenize card

##### Swift Sample
```swift
let request = DLTokenizeRequest(holderName: "HOLDER-NAME",
                                cardNumber: "CARD-NUMBER",
                                cvv: "CVV",
                                expirationMonth: "12",
                                expirationYear: "2025")

sdk.tokenizeCard(request: request, onSuccess: { [weak self] response in
    print("Successfully tokenized card: \(response)")
}, onError: { [weak self] error in
    print("Failed to tokenize card: \(error)")
})
```

##### Objective-C Sample
```objectivec
DLCardData *cardData = [[DLCardData alloc] initWithHolderName:@"HOLDER-NAME"
												   cardNumber:@"CARD-NUMBER"
														  cvv:@"CVV"
											  expirationMonth:12
											   expirationYear:2025];
[sdk tokenizeCardWithCardData:cardData onSuccess:^(DLToken * _Nonnull response) {
	NSLog(@"Successfully tokenized card: %@", response);
} onError:^(DLError * _Nonnull error) {
	NSLog(@"Failed to tokenize card: %@", error);
}];
```

### Create Installments Plan

##### Swift Sample
```swift
sdk.createInstallmentsPlan(cardNumber: "CARD-NUMBER",
                           currencyCode: "CURRENCY-CODE",
                           amount: 500,
                           onSuccess: { [weak self] response in
    print("Successfully created installments plan: \(response)")
}, onError: { [weak self] error in
    print("Failed to create installments plan: \(error)")
})
```

##### Objective-C Sample
```objectivec
[sdk createInstallmentsPlanWithCardNumber:@"CARD-NUMBER"
							 currencyCode:@"CURRENCY-CODE"
								   amount:500
								onSuccess:^(DLInstallments * _Nonnull response) {
	NSLog(@"Successfully created installments plan: %@", response);
} onError:^(DLError * _Nonnull error) {
	NSLog(@"Failed to create installments plan: %@", error);
}];
```

### Get Bin Information

##### Swift Sample
```swift
sdk.getBinInformation(cardNumber: "CARD-NUMBER", 
                       onSuccess: { [weak self] response in
    print("Successfully obtained bin information: \(response)")
}, onError: { [weak self] error in
    print("Failed to obtain bin information: \(error)")
})
```

##### Objective-C Sample
```objectivec
[sdk getBinInformationWithCardNumber:@"CARD-NUMBER"
						   onSuccess:^(DLBinInfo * _Nonnull response) {
	NSLog(@"Successfully obtained bin information: %@", response);
} onError:^(DLError * _Nonnull error) {
	NSLog(@"Failed to obtain bin information: %@", error);
}];
```

## Report Issues
If you have a problem or find an issue with the SDK please contact us at [mobile-dev@dlocal.com](mailto:mobile-dev@dlocal.com)

## License

```text
MIT License

Copyright (c) 2022 DLOCAL

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
