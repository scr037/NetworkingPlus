# Networking+

`Networking+` is a simple wrapper of the Foundation's `URLSession` that allows loading data from the cloud. It offers many convenience abstractions to create request suitable for the most popular HTTP operations, flexible response and error handlers and even stubbing possibilities for testing purposes.

## Caveats
This package is aimed for personal projects that repeteadly need a Networking abstraction to consume data from the cloud. As such, it might not be fully functional for all networking needs. However, expect regular updates or feel free to contribute if you find it useful.
In addition, `Networking+` relies on [Swift Concurrency](https://developer.apple.com/documentation/swift/concurrency) (`async await`) so it is only available on the following platforms and upper: _macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0_. 

## Draft
This repository is in testing phase. Usage instructions will be updated.
