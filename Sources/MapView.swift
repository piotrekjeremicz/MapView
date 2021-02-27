//
//  MapView.swift
//  MapView
//
//  Created by Piotrek on 19/09/2020.
//  Copyright © 2020 Piotr Jeremicz. All rights reserved.
//

import UIKit
import MapKit

public class MapView: UIView {
    
    public var zoomLevel: Int {
        get {
            zoomTileOverlay.zoomLevel
        }
    }
    
    public var style: MapStyle = SystemMapStyle() {
        didSet { setupTileOverlays() }
    }
    
    private let mapView = MKMapView(frame: .zero)
    private let zoomTileOverlay = ZoomTileOverlay()
    
    public init() {
        super.init(frame: .zero)
        
        setupView()
        setupGestureRecognizers()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
        setupGestureRecognizers()
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
    
    private func setupGestureRecognizers() {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureRecognizerAction(_:)))
        pinchGestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    private func setupTileOverlays() {
        mapView.addOverlay(zoomTileOverlay)
        if !(style is SystemMapStyle) {
            mapView.addOverlay(style.tileOverlay)
        }
    }
}

extension MapView {
    @objc func pinchGestureRecognizerAction(_ sender: UIPinchGestureRecognizer) {
        print(zoomLevel)
    }
}

extension MapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? TileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else if let tileOverlay = overlay as? ZoomTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

extension MapView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
