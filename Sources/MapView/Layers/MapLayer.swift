//
//  MapLayer.swift
//  MapView
//
//  Created by Piotrek on 04/03/2021.
//

import MapKit

public typealias Coordinate = CLLocationCoordinate2D
public typealias CoordinateRegion = MKCoordinateRegion

public protocol MapLayer {
    var identifier: UUID { get }
}

extension MapLayer where Self: Equatable {
    var identifier: UUID { return UUID() }
    
    public static func ==(lhs: Self, rhs:Self) -> Bool  {
        lhs.identifier == rhs.identifier
    }
}

public protocol MapAnnotationRenderer: Equatable {
    var renderer: UIView { get }
}

public protocol MapOverlayRenderer {
    var renderer: MKOverlayRenderer { get }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

@resultBuilder
public struct MapLayerBuilder {
    public static func buildBlock(_ layers: MapLayer...) -> [MapLayer] {
        return layers
    }
}
