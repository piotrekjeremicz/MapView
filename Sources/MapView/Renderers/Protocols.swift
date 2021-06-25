//
//  File.swift
//  
//
//  Created by Piotrek on 26/06/2021.
//

import MapKit

public protocol MapAnnotationRenderer: Equatable {
    var renderer: MKAnnotationView { get }
}

public protocol MapOverlayRenderer {
    var renderer: MKOverlayRenderer { get }
}
