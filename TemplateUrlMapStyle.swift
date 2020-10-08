//
//  TemplateUrlMapStyle.swift
//  MapView
//
//  Created by Piotrek on 08/10/2020.
//

import MapKit

public class TemplateUrlMapStyle: MapStyle {
    public var urlTemplate: String? { return path }

    private var path: String
    
    public init(_ path: String) {
        self.path = path
    }
}
