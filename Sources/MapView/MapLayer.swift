//
//  MapLayer.swift
//  MapView
//
//  Created by Piotrek on 04/03/2021.
//

import Foundation
import MapKit

public typealias Coordinate = CLLocationCoordinate2D

public protocol MapLayer {
    var overlay: MKOverlay { get }
    var renderer: MKOverlayRenderer { get }
}

public struct MapPolylineLayer: MapLayer {
    
    let color: UIColor
    let borderColor: UIColor
    var coordinates: [Coordinate]
    
    public var overlay: MKOverlay {
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    public var renderer: MKOverlayRenderer {
        return MapPolylineRenderer(polyline: overlay as! MKPolyline, color: color, borderColor: borderColor)
    }
}
