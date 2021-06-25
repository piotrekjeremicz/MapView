//
//  Annotation.swift
//  
//
//  Created by Piotrek on 20/05/2021.
//

import MapKit

public struct Annotation: MapAnnotationRenderer {
    
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
    
    private var view: UIView?
    
    public init(identifier: String, coordinate: Coordinate, view: UIView) {
        self.view = view
        self.style = .custom
        self.title = nil
        self.subtitle = nil
        self.coordinate = coordinate
        
        self.model = AnnotationModel("\(style.rawValue)AnnotationView", coordinate: coordinate)
    }
    
    public var renderer: MKAnnotationView {
        switch style {
        case .pin:
            let pin = MKPinAnnotationView(annotation: model, reuseIdentifier: model.identifier)
            pin.animatesDrop = false
            
            return pin
        case .marker:
            let marker = MKMarkerAnnotationView(annotation: model, reuseIdentifier: model.identifier)
            marker.animatesWhenAdded = false
            
            return marker
        case .custom:
            guard let view = view else { return MKAnnotationView() }
            
            return MKAnnotationView()
        }
    }
}




