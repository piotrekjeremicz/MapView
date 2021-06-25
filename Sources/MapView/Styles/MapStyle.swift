//
//  MapStyle.swift
//  MapView
//
//  Created by Piotrek on 07/10/2020.
//

import UIKit
import MapKit

public protocol MapStyle {
    var type: MKMapType { get set }
    var urlTemplate: String? { get }
    var repleaceMapContent: Bool { get }
    var tileOverlay: TileOverlay { get }
}

extension MapStyle {
    public var type: MKMapType {
        get { type }
        set { type = newValue }
    }
    
    public var repleaceMapContent: Bool { return true }
    
    public var tileOverlay: TileOverlay {
        let tileOverlay = TileOverlay(urlTemplate: urlTemplate)
        tileOverlay.canReplaceMapContent = repleaceMapContent
        
        return tileOverlay
    }
}

public final class SystemMapStyle: MapStyle {
    public var type: MKMapType
    public var urlTemplate: String? { return nil }
    public var repleaceMapContent: Bool { return false }
    
    public init(with type: MKMapType = .standard) {
        self.type = type
    }
}

public final class TemplateUrlMapStyle: MapStyle {
    public var urlTemplate: String?
        
    public init(_ path: String) { self.urlTemplate = path }
}
