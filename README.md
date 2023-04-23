# DLDirectSDK for iOS

- Allows easy integration with dLocal API to perform operations like card tokenization
- Includes card utility methods, like card detection, validation and formatting

## Requirements
- Xcode 14.1+
- iOS 13+

## Installation

Add the following to your `Podfile`:

```ruby
pod 'DLDirectSDK', '~> 0.2.14'
```

# Getting started

## Initialize the SDK

```swift 
import DLDirectSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    {...}

    var tokenizer: DLCardTokenizer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        tokenizer = DLCardTokenizer(apiKey: "API KEY", countryCode: "COUNTRY CODE")
        return true
    }
}
```

Replace `apiKey` with your key and `countryCode` with the two letter country code, for example "UY" for "Uruguay", or "US" for "United States".

You can find full list of country codes [here](https://documentation.dlocal.com/reference/country-reference).

If your app is using SwiftUI and doesn't have a custom AppDelegate, put the equivalent code inside the init of the App struct like so:

```swift 
import DLDirectSDK

@main
struct ExampleApp: App {

    let tokenizer: DLCardTokenizer

    init() {
        tokenizer = DLCardTokenizer(apiKey: "API-KEY", countryCode: "COUNTRY CODE", testMode: true)
    }
}
```

## Testing the integration

Use `testMode` parameter to specify whether you are going to be doing testing with fake data or if you are going to be performing real transactions.

```swift
tokenizer = DLCardTokenizer(apiKey: "API KEY", countryCode: "COUNTRY CODE", testMode: true)
```

## Objective-C compatibility

All available functions of the SDK can be called from Objective-C code without additional effort on your side.

# API 

## Tokenize card

```swift
let request = DLTokenizeRequest(holderName: "HOLDER-NAME",
                                cardNumber: "CARD-NUMBER",
                                       cvv: "CVV",
                           expirationMonth: "12",
                            expirationYear: "2025")

tokenizer.tokenizeCard(request: request, onSuccess: { response in
    print("Successfully tokenized card: \(response)")
}, onError: { error in
    print("Failed to tokenize card: \(error)")
})
```

## Get Bin Information

```swift
tokenizer.getBinInformation(binNumber: "BIN-NUMBER", 
                            onSuccess: { response in
    print("Successfully obtained bin information: \(response)")
}, onError: { error in
    print("Failed to obtain bin information: \(error)")
})
```

## Get Bin Information + Create Installments Plan

```swift
tokenizer.getBinInformation(binNumber: "BIN-NUMBER",
                         currencyCode: "CURRENCY-CODE",
                               amount: 500,
                            onSuccess: { response in
    print("Successfully obtained bin information: \(response.bin) \(response.brand) \(response.type) \(response.country)")
    if let installments = response.installments {
        print("Successfully created installments: \(installments)")
    } else {
        print("Failed to create installments: \(response.installmentsError")
    }
}, onError: { error in
    print("Failed to get bin info: \(error)")
})
```


# Card Expert

The card expert offers utility functions to work with cards, for example:

- Detect the card brand from an incomplete card number
- Validate the card number
- Format card number to match what is displayed in the physical card

## Getting started

All interactions are done through the `DLCardExpert` class which you create as follows:

```swift
if let cardExpertForUruguay = DLCardExpert(countryCode: "UY") {
    let supportedBrands = cardExpertForUruguay.allBrands.map({ $0.niceName })
    print("Uruguay card data is available, the following brands are supported: \(supportedBrands)")
} else {
    print("Uruguay card data is unavailable")
}
```

For those countries that we don't have data for, you can still use a global expert as follows:

```swift
let cardExpert = DLCardExpert.global
let supportedBrands = cardExpert.allBrands.map({ $0.niceName })
print("Globally accepted brands: \(supportedBrands")
```

This global expert contains globally accepted cards like Visa and Mastercard among others.

## Browse cards

```swift
// Iterate on all brands

for brand in cardExpert.allBrands {
    print("Brand name: \(brand.niceName)")
}

// Obtain a specific brand by identifier

if let visa = cardExpert.brand(withIdentifier: DLCardBrandIdentifier.visa) {
    print(visa.identifier) // "visa"
    print(visa.niceName) // "Visa"
    print(visa.length) // [16]
    print(visa.image) // https://static.dlocal.com/fields/input-icons/visa.svg
} else {
    print("Visa is not supported")
}
```

## Get card image for a specific brand

```swift
let visa = cardExpert.brand(withIdentifier: DLCardBrandIdentifier.visa)!
let imageUrl = visa.cardImage(density: .x3, size: .small, background: true)

if let imageUrl {
    print("Visa image url for requested configuration: \(imageUrl)")                 
} else {
    print("Image url with requested configuration not available")
}
```

## Brand detection

```swift
// Detect card brand from a complete card number
cardExpert.detectBrand(cardNumber: "4242 4242 4242 4242") // returns [Visa]

// Supports both formatted and raw card numbers
cardExpert.detectBrand(cardNumber: "4242424242424242") // returns [Visa]

// Detect card brand from an incomplete card number
// In this case multiple card brands start with number "4", in order to find out which card is being entered user will need to enter additional numbers
cardExpert.detectBrand(cardNumber: "4") // returns [Visa, Visa Débito, Maestro]

// Cards that are not supported in Uruguay will return an empty collection
// For example, American Express cards are not supported in Uruguay and "377400111111115" is a valid Amex card number
cardExpert.detectBrand(cardNumber: "377400111111115") // returns []

// Invalid values will return an empty collection
cardExpert.detectBrand(cardNumber: "HELLO") // returns []

// An empty card number will return all brands supported in this Uruguay
cardExpert.detectBrand(cardNumber: "") // returns [Visa, Oca, Mastercard, Diners, Lider, Visa Débito, Mastercard Débito, Maestro]
```

## Validation

### Validate holder name

```swift
cardExpert.validate(holderName: "John Doe") // true
cardExpert.validate(holderName: "") // false
cardExpert.validate(holderName: " ") // false
cardExpert.validate(holderName: "John Doe 2") // false
cardExpert.validate(holderName: "John Doe!") // false
```

### Validate card number

```swift
cardExpert.validate(cardNumber: "") // false
cardExpert.validate(cardNumber: "4") // false
cardExpert.validate(cardNumber: "4242 4242 4242 4242") // true
cardExpert.validate(cardNumber: "4242424242424242") // true

cardExpert.validate(cardNumber: "4242424242424241") // false (fails luhn check)
cardExpert.validate(cardNumber: "4A") // false
```

If you want to use your own card number validation rules:

```swift
let validator = DLCardNumberValidator(length: 16, // must have length of 16 digits 
                                      patterns: [4, 5], // must start with 4 or 5
                                      excludePatterns: "^(4242)", // should not match this regex
                                      algorithm: .luhn) // should pass luhn check 
cardExpert.validate(cardNumber: "4242 4242 4242 4242", validator: validator) // false (as it starts with "4242" which is a excluded pattern)
```

### Validate expiration date

```swift
// Assume below calls are done on August 2022 (08/22)

cardExpert.validate(expirationDate: "") // false
cardExpert.validate(expirationDate: "0") // false
cardExpert.validate(expirationDate: "02") // false
cardExpert.validate(expirationDate: "02/") // false
cardExpert.validate(expirationDate: "02/2") // false
cardExpert.validate(expirationDate: "02/26") // true
cardExpert.validate(expirationDate: "2/26") // true


cardExpert.validate(expirationDate: "13") // false
cardExpert.validate(expirationDate: "7/22") // false (expired)
cardExpert.validate(expirationDate: "8/2022") // false
```

### Validate security code

The following will validate the security code using standard security code rules:

```swift
cardExpert.validate(securityCode: "") // false
cardExpert.validate(securityCode: "1") // false
cardExpert.validate(securityCode: "12") // false
cardExpert.validate(securityCode: "123") // true
```

If you know the brand of the card, you can validate the security code specifically for that brand:

```
if let visa = cardExpert.detectBrand(cardNumber: "4242 4242 4242 4242").first {
    cardExpert.validate(securityCode: "1234", brand: visa) // false, VISA security code length is 3
    cardExpert.validate(securityCode: "12A", brand: visa) // false
}
```

## Formatting

### Format card number

Use this when users are typing in to the card field to facilitate the input of the card.

```swift
cardExpert.format(cardNumber: "") // returns ""
cardExpert.format(cardNumber: "4") // returns "4"
cardExpert.format(cardNumber: "42") // returns "42"
cardExpert.format(cardNumber: "4242") // returns "4242" (Visa detected at this point)
cardExpert.format(cardNumber: "42424") // returns "4242 4"
cardExpert.format(cardNumber: "424242") // returns "4242 42"
cardExpert.format(cardNumber: "4242424242424242") // returns "4242 4242 4242 4242"
cardExpert.format(cardNumber: "42424242424242425") // returns "4242 4242 4242 4242" (we detect this is a VISA which length is 16 digits, so we ignore everything past the 16th position)
cardExpert.format(cardNumber: "42 42424242424242") // returns "4242 4242 4242 4242"
cardExpert.format(cardNumber: "42 4242  42 42 4 2424    2") // returns "4242 4242 4242 4242"
```

If you want to use a specific brand to format the number, you can pass that brand to the function as follows:

```swift
if let diners = cardExpert.brand(withIdentifier: DLCardBrandIdentifier.dinersClub) {
    cardExpert.format(cardNumber: "12345678901234", brand: diners) // returns "1234 567890 1234"
}
```

Alternatively, you can define your own formatter as follows:

```swift
let formatter = DLCardNumberFormatter(length: 16, gaps: [1, 4]) 
cardExpert.format(cardNumber: "1234567890", formatter: formatter) // returns "1 234 567890"
```

### Format card number with last numbers

If you want to display a card identified by last numbers, you can use this option as follows:

```swift
if let diners = cardExpert.brand(withIdentifier: DLCardBrandIdentifier.dinersClub) {
    cardExpert.format(cardNumberEndingWith: "1234", brand: diners) // returns "**** ****** 1234"
    cardExpert.format(cardNumberEndingWith: "234", brand: diners) // returns "**** ****** *234"
    cardExpert.format(cardNumberEndingWith: "34", brand: diners) // returns "**** ****** **34"
    cardExpert.format(cardNumberEndingWith: "4", brand: diners) // returns "**** ****** ***4"
    cardExpert.format(cardNumberEndingWith: "", brand: diners) // returns "**** ****** ****"
}
```

If you don't know the brand, you can use a `DLCardNumberMaskFormatter` instance as follows:

```swift
let formatter = DLCardNumberMaskFormatter(length: 14, gaps: [10])
cardExpert.format(cardNumberEndingWith: "1234", formatter: formatter) // returns "********** 1234"
```

### Format expiration month and year (separated fields)

If your form has separated fields for month and year, you will want to use these methods for formatting the input.
Formatting includes normalization of values to match card formatting rules (e.g. turning "2" into "02") and some validation (e.g. disallow input of non numeric characters, disallow input of more than two characters for months, etc).

```swift
cardExpert.format(expirationMonth: "") // returns ""
cardExpert.format(expirationMonth: "0") // returns "0"
cardExpert.format(expirationMonth: "1") // returns "1" (as this could be "01", "11" or "12")
cardExpert.format(expirationMonth: "2") // returns "02"
cardExpert.format(expirationMonth: "3") // returns "03"
cardExpert.format(expirationMonth: "4") // returns "04"
cardExpert.format(expirationMonth: "5") // returns "05"
cardExpert.format(expirationMonth: "6") // returns "06"
cardExpert.format(expirationMonth: "7") // returns "07"
cardExpert.format(expirationMonth: "8") // returns "08"
cardExpert.format(expirationMonth: "9") // returns "09"
cardExpert.format(expirationMonth: "10") // returns "10"
cardExpert.format(expirationMonth: "11") // returns "11"
cardExpert.format(expirationMonth: "12") // returns "12"

cardExpert.format(expirationMonth: "121") // returns "12" (disallows entering a third character)
cardExpert.format(expirationMonth: "13") // returns "13" (this is an invalid month so we cannot format it)
cardExpert.format(expirationMonth: "1A") // returns "1" (does not allow entering non numeric characters)
cardExpert.format(expirationMonth: "1 ") // returns "1" (does not allow spaces)
```

```swift
cardExpert.format(expirationYear: "") // returns ""
cardExpert.format(expirationYear: "0") // returns "" (does not allow first character to be a zero)
cardExpert.format(expirationYear: "1") // returns "" (does not allow first character to be a one)
cardExpert.format(expirationYear: "2") // returns "2"
cardExpert.format(expirationYear: "20") // returns "20"
cardExpert.format(expirationYear: "202") // returns "202" (allowed as user seems to be constructing four character year)
cardExpert.format(expirationYear: "2022") // returns "22" (shortens length to match standard card expiration year formatting)
cardExpert.format(expirationYear: "20225") // returns "22" (ignores everyhing coming after the fifth character)
cardExpert.format(expirationYear: "202A") // returns "202" (does not allow entering non numeric characters)
```

### Format expiration month and year (same field)

If your form contains a single field for expiration date then this is the function you want to use to format the input.
Formatting includes normalization to help users with input of the expiration date, like automatically inserting a "/" to separate month and year.

```swift
cardExpert.format(expirationMonthAndYear: "") // returns ""
cardExpert.format(expirationMonthAndYear: "1") // returns "1" (expecting a second number to understand whether this is month "01" or "11" or "12")
cardExpert.format(expirationMonthAndYear: "11") // returns "11/" (automatically inserts "/" character so user only has to enter numbers)
cardExpert.format(expirationMonthAndYear: "2") // returns "02/" (automatically formats into month "02" and inserts "/")
cardExpert.format(expirationMonthAndYear: "2/") // returns "02/" (formats "2" into "02")
cardExpert.format(expirationMonthAndYear: "2/A") // returns "02/" (disallows entering any non numeric character)
cardExpert.format(expirationMonthAndYear: "2/2") // returns "02/2"
cardExpert.format(expirationMonthAndYear: "2/20") // returns "02/20"
cardExpert.format(expirationMonthAndYear: "2/202") // returns "02/202"
cardExpert.format(expirationMonthAndYear: "2/2022") // returns "02/22" (shortens year)
```

### Format security code

Different brands have different properties for the security code, if you know the brand you can use it for an improved formatting experience:

```swift
if let diners = cardExpert.brand(withIdentifier: DLCardBrandIdentifier.dinersClub) {
    cardExpert.format(securityCode: "123", brand: diners) // returns "123"
    cardExpert.format(securityCode: "1234", brand: diners) // returns "123" (security code limited to 3 characters for this brand)
}
```

When you don't know the brand of the card, you cand use the following version:

```swift
cardExpert.format(securityCode: "") // returns ""
cardExpert.format(securityCode: "1") // returns "1"
cardExpert.format(securityCode: "12") // returns "12"
cardExpert.format(securityCode: "123") // returns "123"
cardExpert.format(securityCode: "1234") // returns "1234"
cardExpert.format(securityCode: "12345") // returns "1234" // limits to 4 digits
cardExpert.format(securityCode: " 1!2 3# 4a") // returns "1234" // removes letters and other unwanted characters
```

Alternatively if you want to use your custom formatting rules, you can use the following approach:

```swift
let formatter = DLSecurityCodeFormatter(maxLength: 5)
cardExpert.format(securityCode: "1234", formatter: formatter) // returns "1234"
cardExpert.format(securityCode: "12345", formatter: formatter) // returns "12345"
cardExpert.format(securityCode: "123456", formatter: formatter) // returns "123456" // limits to 5 digits as defined
```

# API Reference

[View documentation](https://dlocal.github.io/dlocal-direct-ios-sdk/documentation/dldirectsdk)

# Report Issues
If you have a problem or find an issue with the SDK please contact us at [mobile-dev@dlocal.com](mailto:mobile-dev@dlocal.com)

# License

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
