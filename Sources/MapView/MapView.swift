//
//  MapView.swift
//  MapView
//
//  Created by Piotrek on 19/09/2020.
//  Copyright © 2020 Piotr Jeremicz. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

public typealias MapViewAction = ((_ mapView: MapView) -> ())

public class MapView: UIView {
    
    public var willChangeRegion: MapViewAction?
    public var isChangingRegion: MapViewAction?
    public var didChangeRegion: MapViewAction?
    
    public var isZoomEnabled: Bool {
        get { mapView.isZoomEnabled }
        set { mapView.isZoomEnabled = newValue }
    }
    public var isScrollEnabled: Bool {
        get { mapView.isScrollEnabled }
        set { mapView.isScrollEnabled = newValue }
    }
    public var isPitchEnabled: Bool {
        get { mapView.isPitchEnabled }
        set { mapView.isPitchEnabled = newValue }
    }
    public var isRotateEnabled: Bool {
        get { mapView.isRotateEnabled }
        set { mapView.isRotateEnabled = newValue }
    }
    
    public var zoomLevel: Int {
        get { zoomTileOverlay.zoomLevel }
    }
    
    public var type: MKMapType {
        get { style.type }
        set { style.type = newValue }
    }

    public var layers: [MapLayer] {
        get { privateLayers }
    }

    public var region: MKCoordinateRegion {
        get { mapView.region }
        set { mapView.region = newValue}
    }
    
    public var style: MapStyle = SystemMapStyle() {
        didSet { setupTileOverlays() }
    }
    
    public var centerCoordinate: Coordinate {
        get { mapView.centerCoordinate }
        set { mapView.centerCoordinate = newValue }
    }
    
    private var privateLayers: [MapLayer] = []
    private let mapView = MKMapView(frame: .zero)
    private let zoomTileOverlay = ZoomTileOverlay()
    
    public init(
        willChangeRegion: MapViewAction? = nil,
        isChangingRegion: MapViewAction? = nil,
        didChangeRegion: MapViewAction? = nil
    ) {
        self.willChangeRegion = willChangeRegion
        self.isChangingRegion = isChangingRegion
        self.didChangeRegion = didChangeRegion
        
        super.init(frame: .zero)
        
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private var didUpdateConstraints = false
    
    public override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            NSLayoutConstraint.activate([
                mapView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                mapView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
                mapView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
                mapView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            ])
        }
        
        super.updateConstraints()
    }
}

extension MapView {
    private func setupView() {
        backgroundColor = .clear
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
    }
    
    private func setupTileOverlays() {
        mapView.addOverlay(zoomTileOverlay)
        if let style = style as? SystemMapStyle {
            mapView.mapType = style.type
        } else {
            mapView.addOverlay(style.tileOverlay)
        }
    }
}


extension MapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? TileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else if let tileOverlay = overlay as? ZoomTileOverlay {
            return MKTileOverlayRenderer(overlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        didChangeRegion?(self)
    }
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        willChangeRegion?(self)
    }

    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        isChangingRegion?(self)
    }
    
}

extension MapView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
