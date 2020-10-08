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
    
    public var style: MapStyle = SystemMapStyle() {
        didSet { setupMap() }
    }
    
    private let mapView = MKMapView(frame: .zero)
    
    public init() {
        super.init(frame: .zero)
        
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
    }
    
    private func setupMap() {
        if !(style is SystemMapStyle) {
            mapView.addOverlay(style.tileOverlay)
        }
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

extension MapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
