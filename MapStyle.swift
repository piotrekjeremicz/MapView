//
//  MapStyle.swift
//  MapView
//
//  Created by Piotrek on 07/10/2020.
//

import UIKit
import MapKit

public protocol MapStyle {
    var urlTemplate: String? { get }
    var tileOverlay: MKTileOverlay { get }
}

extension MapStyle {
    public var tileOverlay: MKTileOverlay {
        let tileOverlay = MKTileOverlay(urlTemplate: urlTemplate)
        tileOverlay.canReplaceMapContent = true
        return tileOverlay
        
    }
}

public final class SystemMapStyle: MapStyle {
    public var urlTemplate: String? { return nil }
    
}
