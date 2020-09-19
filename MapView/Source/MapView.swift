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
    
    private let mapView = MKMapView(frame: .zero)
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        addSubview(mapView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}
