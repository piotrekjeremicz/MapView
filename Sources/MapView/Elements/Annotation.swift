//
//  File.swift
//  
//
//  Created by Piotrek on 20/05/2021.
//

import MapKit

public final class AnnotationModel: NSObject, MKAnnotation, MapModel {
    public let identifier: String
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: Coordinate
    
    public init(_ identifier: String, from annotation: Annotation) {
        self.identifier = identifier
        self.title = annotation.title
        self.subtitle = annotation.subtitle
        self.coordinate = annotation.coordinate
    }
}

public struct Annotation: MapAnnotationRenderer {
    public let title: String?
    public let subtitle: String?
    public let coordinate: Coordinate

    public init(title: String? = nil, subtitle: String? = nil, coordinate: Coordinate) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        
    }
    
    public var model: AnnotationModel { AnnotationModel("AnnotationView", from: self) }
    public var renderer: UIView { MKPinAnnotationView(annotation: model, reuseIdentifier: model.identifier) }
}

public struct AnnotationLayer: MapLayer {
    let annotation: Annotation
    
    public init(annotation: Annotation) {
        self.annotation = annotation
    }
}

public struct AnnotationsLayer: MapLayer {
    let annotations: [Annotation]
    
    public init(annotations: [Annotation]) {
        self.annotations = annotations
    }
}

