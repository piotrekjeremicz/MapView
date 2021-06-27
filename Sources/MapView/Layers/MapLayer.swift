//
//  MapLayer.swift
//  MapView
//
//  Created by Piotrek on 04/03/2021.
//

import MapKit

public protocol MapLayer {
    var identifier: String { get }
    
    mutating func update(with layer: MapLayer)
}

extension MapLayer where Self: Equatable {
    public static func ==(lhs: Self, rhs:Self) -> Bool  {
        lhs.identifier == rhs.identifier
    }
}






