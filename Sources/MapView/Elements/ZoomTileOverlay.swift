//
//  ZoomTileOverlay.swift
//  MapView
//
//  Created by Piotrek on 04/12/2020.
//

import UIKit
import MapKit

final internal class ZoomTileOverlay: MKTileOverlay {
    
    public var zoomLevel: Int = 0
    
    override init(urlTemplate URLTemplate: String?) {
        super.init(urlTemplate: nil)
        canReplaceMapContent = false
    }
    
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        zoomLevel = path.z
        return URL(string: "http://www.example.com?x={x}&y={y}&z={z}")!
    }
    
    override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        zoomLevel = path.z
        result(nil, nil)
    }
}
