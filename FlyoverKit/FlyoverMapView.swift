//
//  FlyoverMapView.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit

// MARK: - FlyoverMapView

/// The FlyoverMapView
public class FlyoverMapView: MKMapView {
    
    // MARK: Properties
    
    /// The FlyoverCamera
    public lazy var flyoverCamera: FlyoverCamera = {
        return FlyoverCamera(mapView: self, configurationTheme: .default)
    }()
    
    /// The default MKMapType with overriden filter handler to only allow FlyoverMapView.MapType's
    public override var mapType: MKMapType {
        didSet {
            // Set the MKMapType via constructing an MapType and retrieve rawValue otherwise set standard
            self.mapType = MapType(rawValue: self.mapType)?.rawValue ?? .standard
        }
    }
    
    /// The FlyoverMapView MapType
    public var flyoverMapType: MapType {
        set {
            // Set mapType rawValue
            self.mapType = newValue.rawValue
        }
        get {
            // Return MapType constructed with MKMapType otherwise return standard
            return MapType(rawValue: self.mapType) ?? .standard
        }
    }
    
    /// The FlyoverCamera Configuration computed property for easy access
    public var configuration: FlyoverCamera.Configuration {
        set {
            // Set new value
            self.flyoverCamera.configuration = newValue
        }
        get {
            // Return FlyoverCamera configuration
            return self.flyoverCamera.configuration
        }
    }
    
    /// Retrieve boolean if the FlyoverCamera is started
    public var isStarted: Bool {
        // Return FlyoverCamera isStarted property
        return self.flyoverCamera.isStarted
    }
    
    // MARK: Initializer
    
    /// Default initializer with flyover configuration and map type
    ///
    /// - Parameters:
    ///   - configuration: The flyover configuration
    ///   - mapType: The map type
    public init(configuration: FlyoverCamera.Configuration, mapType: MapType = .standard) {
        super.init(frame: .zero)
        // Set the configuration
        self.flyoverCamera.configuration = configuration
        // Set flyover map type
        self.flyoverMapType = mapType
        // Hide compass
        self.showsCompass = false
        // Show buildings
        self.showsBuildings = true
    }
    
    /// Convenience initializer with flyover configuration theme and map type
    ///
    /// - Parameters:
    ///   - configurationTheme: The flyover configuration theme
    ///   - mapType: The map type
    public convenience init(configurationTheme: FlyoverCamera.Configuration.Theme, mapType: MapType = .standard) {
        self.init(configuration: configurationTheme.rawValue, mapType: mapType)
    }
    
    /// Initializer with NSCoder (not supported) returns nil
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    /// Deinit
    deinit {
        // Stop FlyoverCamera
        self.stop()
    }
    
    // MARK: Convenience start/stop functions
    
    /// Start flyover with MKAnnotation and the optional region change animation mode.
    ///
    /// - Parameters:
    ///   - annotation: The MKAnnotation
    ///   - regionChangeAnimationMode: The region change animation mode (Default: none)
    public func start(_ annotation: MKAnnotation,
                      regionChangeAnimationMode: FlyoverCamera.RegionChangeAnimationMode = .none) {
        self.start(annotation.coordinate, regionChangeAnimationMode: regionChangeAnimationMode)
    }
    
    /// Start flyover with FlyoverAble and the optional region change animation mode.
    ///
    /// - Parameters:
    ///   - flyoverAble: The FlyoverAble Type (e.g. CLLocationCoordinate2D, CLLocation, MKMapPoint)
    ///   - regionChangeAnimationMode: The region change animation mode (Default: none)
    public func start(_ flyoverAble: FlyoverAble,
                      regionChangeAnimationMode: FlyoverCamera.RegionChangeAnimationMode = .none) {
        self.flyoverCamera.start(flyoverAble, regionChangeAnimationMode: regionChangeAnimationMode)
    }
    
    /// Stop Flyover
    public func stop() {
        self.flyoverCamera.stop()
    }
    
}

// MARK: - SupportedMapType

public extension FlyoverMapView {
    
    /// The FlyoverMapView supported MapType
    enum MapType {
        /// Standard
        case standard
        /// Satellite Flyover
        case satelliteFlyover
        /// Hybrid Flyover
        case hybridFlyover
    }
    
}

// MARK: - SupportedMapType RawRepresentable

extension FlyoverMapView.MapType: RawRepresentable {
    
    /// Associated type RawValue as MKMapType
    public typealias RawValue = MKMapType
    
    /// RawRepresentable initializer
    ///
    /// - Parameters:
    ///   - rawValue: The MapType
    public init?(rawValue: RawValue) {
        // Switch on rawValue
        switch rawValue {
        case .standard:
            self = .standard
        case .satelliteFlyover:
            self = .satelliteFlyover
        case .hybridFlyover:
            self = .hybridFlyover
        default:
            return nil
        }
    }
    
    /// The MKMapType
    public var rawValue: RawValue {
        // Switch on self
        switch self {
        case .standard:
            return .standard
        case .satelliteFlyover:
            return .satelliteFlyover
        case .hybridFlyover:
            return .hybridFlyover
        }
    }
    
}
