//
//  File.swift
//  
//
//  Created by Piotrek on 09/05/2021.
//

import SwiftUI

public struct Map: UIViewRepresentable {
 
    @usableFromInline internal let mapView: MapView

    private var layers: [MapLayer] = []
    
    public init(configuration: Configuration = Configuration(), @MapLayerBuilder _ layers: () -> [MapLayer]) {
        self.layers = layers()
        self.mapView = MapView()
    }
    
    public func makeUIView(context: Context) -> MapView {
        mapView.updateConstraints()
        mapView.add(layers: layers)
        
        return mapView
    }

    public func updateUIView(_ uiView: MapView, context: Context) {

    }
}



private extension Map {
    func configureMap(_ configuration: Configuration) {
        mapView.style = configuration.style
        
        mapView.isZoomEnabled = configuration.isZoomEnabled
        mapView.isPitchEnabled = configuration.isPitchEnabled
        mapView.isScrollEnabled = configuration.isScrollEnabled
        mapView.isRotateEnabled = configuration.isRotateEnabled
    }
}

public extension Map {
    struct Configuration {
        let style: MapStyle
        let isZoomEnabled: Bool
        let isScrollEnabled: Bool
        let isPitchEnabled: Bool
        let isRotateEnabled: Bool
        
        public init(
            style: MapStyle = SystemMapStyle(),
            isZoomEnabled: Bool = false,
            isScrollEnabled: Bool = false,
            isPitchEnabled: Bool = false,
            isRotateEnabled: Bool = false
        ) {
            self.style = style
            self.isZoomEnabled = isZoomEnabled
            self.isPitchEnabled = isPitchEnabled
            self.isScrollEnabled = isScrollEnabled
            self.isRotateEnabled = isRotateEnabled
        }
    }
    
    @inlinable func willChangeRegion(_ action: @escaping MapViewAction) -> Map {
        self.mapView.willChangeRegion = action
        
        return self
    }
    
    @inlinable func isChangingRegion(_ action: @escaping MapViewAction) -> Map {
        self.mapView.isChangingRegion = action
        
        return self
    }
    
    @inlinable func didChangeRegion(_ action: @escaping MapViewAction) -> Map {
        self.mapView.didChangeRegion = action
        
        return self
    }
}
