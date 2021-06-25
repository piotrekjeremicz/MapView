//
//  File.swift
//  
//
//  Created by Piotrek on 25/06/2021.
//

import MapKit

public typealias Coordinate = CLLocationCoordinate2D
public typealias CoordinateRegion = MKCoordinateRegion

public extension Map {
    struct Configuration {
        let style: MapStyle
        let showsUserLocation: Bool
        let userTrackingMode: Bool
        
        let isZoomEnabled: Bool
        let isScrollEnabled: Bool
        let isPitchEnabled: Bool
        let isRotateEnabled: Bool
        
        public init(
            style: MapStyle = SystemMapStyle(),
            showsUserLocation: Bool = false,
            userTrackingMode: Bool = false,
            
            isZoomEnabled: Bool = false,
            isScrollEnabled: Bool = false,
            isPitchEnabled: Bool = false,
            isRotateEnabled: Bool = false
        ) {
            self.style = style
            self.showsUserLocation = showsUserLocation
            self.userTrackingMode = userTrackingMode
            
            self.isZoomEnabled = isZoomEnabled
            self.isPitchEnabled = isPitchEnabled
            self.isScrollEnabled = isScrollEnabled
            self.isRotateEnabled = isRotateEnabled
        }
    }
    
    struct Edges {
        public let topLeft: Coordinate
        public let topRight: Coordinate
        
        public let bottomLeft: Coordinate
        public let bottomRight: Coordinate
    }
    
    @resultBuilder
    struct LayerBuilder {
        public static func buildBlock(_ layers: MapLayer...) -> [MapLayer] {
            return layers
        }
    }
}
