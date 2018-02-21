# FlyoverKit

[![Build Status](https://travis-ci.org/SvenTiigi/FlyoverKit.svg?branch=master)](https://travis-ci.org/SvenTiigi/FlyoverKit)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/cocoapods/v/FlyoverKit.svg?style=flat)](http://cocoapods.org/pods/FlyoverKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codebeat badge](https://codebeat.co/badges/c170aedf-d49e-4538-be5c-6c2819c8d7f4)](https://codebeat.co/projects/github-com-sventiigi-flyoverkit-master)
[![Documentation](https://github.com/SvenTiigi/FlyoverKit/blob/gh-pages/badge.svg)](https://sventiigi.github.io/FlyoverKit)
[![Twitter](https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat)](https://twitter.com/SvenTiigi/)

`FlyoverKit` enables you to present stunning 360° flyover views in your iOS App with zero effot and 100% configuration options

## Example App
Try out the `FlyoverKitExample` application to see `FlyoverKit` in action and get a brief look of configuration options.

<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/FlyoverKit/gh-pages/readMeAssets/FlyoverKitExampleApplication.png" alt="Example Application Screenshot" width="300">
</p>

In order to run the example Application you have to first generate the Frameworks via `Carthage`

```bash
$ carthage update --platform iOS
$ open FlyoverKit.xcodeproj
```
> Please keep in mind that the SatelliteFlyover and HybridFlyover will only work on a real iOS device

## Installation

### CocoaPods

STLocationRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'FlyoverKit'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate STLocationRequest into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SvenTiigi/FlyoverKit"
```

Run `carthage update --platform iOS` to build the framework and drag the built `FlyoverKit.framework` into your Xcode project. 

## Usage
`FlyoverKit` comes with three ways to implement a flyover. Simply choose the most suitable type for your implementation. Please see the `Advanced` section in order to configure the `FlyoverKit` to your needs.

### FlyoverCamera
If you already have a `MKMapView` in your `Controller` and you want to add a flyover to this MapView, simply use the `FlyoverCamera`.

```swift
// Initialize the FlyoverCamera with a MKMapView
let flyoverCamera = FlyoverCamera(
    mapView: mapView,
    configuration: configuration
)

// Initialize a location
let eiffelTower = CLLocationCoordinate2DMake(48.858370, 2.294481)

// Start flyover
flyoverCamera.start(flyover: eiffelTower)
```

### FlyoverMapView
If you wish to show MapView which is already preconfigured to perform a flyover on a given location.

```swift
// Initialize the FlyoverMapView
let flyoverMapView = FlyoverMapView()

// Initialize a location
let eiffelTower = CLLocationCoordinate2DMake(48.858370, 2.294481)

// Start flyover
flyoverMapView.start(flyover: eiffelTower)
```

### FlyoverMapViewController
If you wish to present a `UIViewController` with an embedded `FlyoverMapView` to perform a flyover on a given location.

```swift
// Initialize a location
let eiffelTower = CLLocationCoordinate2DMake(48.858370, 2.294481)

// Initialize the FlyoverMapViewController with a Flyover object
let controller = FlyoverMapViewController(flyover: eiffelTower)

// Present controller
self.present(controller, animated: true)
```

## Advanced
The `FlyoverKit` is based on a 4-layer architecture:

* Flyover
* FlyoverCamera
* FlyoverMapView
* FlyoverMapViewController

## Flyover
The `flyover` protocol represents the base layer of the `FlyoverKit`. The protocol is used to perform a flyover on the given coordinate.

```swift
public protocol Flyover {
    var coordinate: CLLocationCoordinate2D { get }
}
```
The `FlyoverKit` already implemented this protocol to various MapKit and CoreLocation types like `CLLocationCoordinate2D`, `CLLocation`, `MKMapPoint`, `MKMapItem`, `MKCoordinateRegion` and many more.

You can apply the `Flyover` protocol to your own models to use them for a flyover.

```swift
struct Address {
    var name: String
    var coordinate: CLLocationCoordinate2D
}
extension Address: Flyover {}
```

## FlyoverCamera
The second layer the `FlyoverCamera` is responsible for manipulating the orginal `MKMapView` camera and performs a 360° flyover animation via the `UIViewPropertyAnimator` class. 

In order to initialize a `FlyoverCamera` object you need to pass a `MKMapView` (which reference will be weakly stored) and a `FlyoverCamera.Configuration` object.

```swift
// Initialize FlyoverCamera configuration
let configuration = FlyoverCamera.Configuration(
    duration: 4.0,
    altitude: 600.0,
    pitch: 45.0,
    headingStep: 20.0
)

// Initialize FlyoverCamera
let camera = FlyoverCamera(
    mapView: mapView,
    configuration: configuration
)

// Start Flyover
camera.start(flyover: location)
```

### Configuration
The `FlyoverCamera.Configuration` struct holds all specific flyover configuration values. Set the properties to get the right look and feel of the flyover as you need it to be.

| Configuration      | Description   |
| ------------- | ------------- |
| duration      | The flyover animation duration |
| altitude      | The altitude above the ground, measured in meters      |
| pitch | The viewing angle of the camera, measured in degrees      |
| headingStep | The direction step in degrees that is added to the MapViewCamera heading in each flyover iteration |
| regionChangeAnimation | The region change animation that should be applied if a flyover has been started and the MapCamera has to change the region. Default is always `.none` which immediately present the place. If you wish that the region change should be performed via an animation you can set `.animated(duration: 1.5, curve: .easeIn)`      |

An excellent visualization of an `MKMapCamera` from [TechTopia](http://www.techotopia.com/index.php/An_iOS_9_MapKit_Flyover_Tutorial)

<p align="center">
    <a href="http://www.techotopia.com/index.php/An_iOS_9_MapKit_Flyover_Tutorial">
        <img src="http://www.techotopia.com/images/5/5b/Ios_9_flyover_camera_diagram.png" alt="Flyover Camera Diagram">
    </a>
</p>

### Configuration Theme
If you don't want to set the properties yourself your can use a preconfigured configuration theme. Currently there are four themes available 

| Theme      | Description   |
| ------------- | ------------- |
| default      | Default flyover configuration with configuration for a default flyover usage |
| lowFlying      | Flyover configuration with a low altitude and a high pitch. Simulates a low flying helicopter viewing angle |
| farAway      | Configuration with a high altitude and a normal pitch which results in a far away viewing angle |
| giddy      | A giddy configuration 🤢 which you shouldn't use in production. But it's fun 🤷‍♂️ 🤙|

More themes coming soon... 👨‍💻

Furthermore, you can initialize a `FlyoverCamera` with a given `Theme`.

```swift
// Initialize FlyoverCamera
let camera = FlyoverCamera(
    mapView: mapView,
    configurationTheme: .default
)
```

## FlyoverMapView
`Coming soon`

## FlyoverMapViewController
`Coming soon`

## Contributing
Contributions are very welcome 🙌 🤓

## License

```
STLocationRequest
Copyright (c) 2018 Sven Tiigi <sven.tiigi@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
