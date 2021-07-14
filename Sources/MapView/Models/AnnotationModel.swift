//
//  File.swift
//  
//
//  Created by Piotrek on 25/06/2021.
//

import MapKit

public final class AnnotationModel: NSObject, MKAnnotation {
    public let identifier: String
    
    public var title: String?
    public var subtitle: String?
    public var coordinate: Coordinate
    
    public override var description: String { "Annotation Model: { identifier: \(identifier), title: \(title), subtitle: \(subtitle), coordinate: \(coordinate) }"}
    
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
