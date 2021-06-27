//
//  File.swift
//  
//
//  Created by Piotrek on 25/06/2021.
//

import Foundation

public struct AnnotationLayer: MapLayer {
    
    public var identifier: String
    public var annotation: Annotation
    
    public init(identifier: String = UUID().uuidString, annotation: Annotation) {
        self.identifier = identifier
        self.annotation = annotation
    }
    
    public mutating func update(with layer: MapLayer) {
        guard let annotationLayer = layer as? AnnotationLayer else { fatalError("This is not an Annotation Layer") }
        annotation = annotationLayer.annotation
    }
}

public struct AnnotationsLayer: MapLayer {
    
    public var identifier: String
    public var annotations: [Annotation]
    
    public init(identifier: String = UUID().uuidString, annotations: [Annotation]) {
        self.identifier = identifier
        self.annotations = annotations
    }
    
    public mutating func update(with layer: MapLayer) {
        guard let annotationsLayer = layer as? AnnotationsLayer else { fatalError("This is not an Annotations Layer") }
        
        annotations = annotationsLayer.annotations
        
    }
}
