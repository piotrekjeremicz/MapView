//
//  MapLayer.swift
//  MapView
//
//  Created by Piotrek on 04/03/2021.
//

import MapKit

public protocol MapLayer {
    var identifier: UUID { get }
}

extension MapLayer where Self: Equatable {
    var identifier: UUID { return UUID() }
    
    public static func ==(lhs: Self, rhs:Self) -> Bool  {
        lhs.identifier == rhs.identifier
    }
}






