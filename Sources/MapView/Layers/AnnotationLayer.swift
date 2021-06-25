//
//  File.swift
//  
//
//  Created by Piotrek on 25/06/2021.
//

import Foundation

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
