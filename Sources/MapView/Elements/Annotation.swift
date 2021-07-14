//
//  Annotation.swift
//  
//
//  Created by Piotrek on 20/05/2021.
//

import MapKit

public struct Annotation: MapAnnotationRenderer {
    
    public static func == (lhs: Annotation, rhs: Annotation) -> Bool {
        lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.coordinate == rhs.coordinate
    }
    
    public enum Style: String {
        case pin = "Pin"
        case marker = "Marker"
        case custom = "Custom"
    }
    
    public let style: Style
    public let title: String?
    public let subtitle: String?
    public let coordinate: Coordinate
    public var model: AnnotationModel

    public init(style: Style = .marker, title: String? = nil, subtitle: String? = nil, coordinate: Coordinate) {
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        self.model = AnnotationModel("\(style.rawValue)AnnotationView", title: title, subtitle: subtitle, coordinate: coordinate)
    }
    
    private var view: AnyClass?
    
    public init(identifier: String, title: String? = nil, subtitle: String? = nil, coordinate: Coordinate, view: AnyClass) {
        self.view = view
        self.style = .custom
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        self.model = AnnotationModel("\(identifier)AnnotationView", title: title, subtitle: subtitle, coordinate: coordinate)
    }
    
    public var renderer: AnyClass? {
        switch style {
        case .pin:
            return MKPinAnnotationView.self
        case .marker:
            return MKMarkerAnnotationView.self
        case .custom:
            guard let view = view else { return nil }

            return view
        }
    }
}




