//
//  File.swift
//  
//
//  Created by Piotrek on 20/05/2021.
//

import MapKit

public final class AnnotationModel: NSObject, MKAnnotation {
    public let identifier: String
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: Coordinate
    
    public init(_ identifier: String, title: String? = nil, subtitle: String? = nil, coordinate: Coordinate) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func ==(lhs: AnnotationModel, rhs: AnnotationModel) -> Bool {
        return lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.coordinate == rhs.coordinate
    }
}

public struct Annotation: MapAnnotationRenderer {
    
    public enum Style: String {
        case pin = "Pin"
        case marker = "Marker"
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
    
    
    public var renderer: UIView {
        switch style {
        case .pin:
            let pin = MKPinAnnotationView(annotation: model, reuseIdentifier: model.identifier)
            pin.animatesDrop = false
            
            return pin
        case .marker:
            let marker = MKMarkerAnnotationView(annotation: model, reuseIdentifier: model.identifier)
            marker.animatesWhenAdded = false
            
            return marker
        }
    }
}

public struct AnnotationLayer: MapLayer {
    public var identifier: UUID = UUID()
    
    let annotation: Annotation
    
    public init(annotation: Annotation) {
        self.annotation = annotation
    }
}

public struct AnnotationsLayer: MapLayer {
    public var identifier: UUID = UUID()
    
    let annotations: [Annotation]
    
    public init(annotations: [Annotation]) {
        self.annotations = annotations
    }
}
