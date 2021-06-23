//
//  File.swift
//  
//
//  Created by Piotrek on 09/05/2021.
//

import SwiftUI
import MapKit

public struct Map: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
        
    private var layers: [MapLayer] = []
    private let configuration: Map.Configuration
    
    internal var willChangeRegion: MapViewAction? = nil
    internal var isChangingRegion: MapViewAction? = nil
    internal var didChangeRegion: MapViewAction? = nil
    
    public init(
        configuration: Configuration,
        region: Binding<MKCoordinateRegion>,
        @MapLayerBuilder _ layers: () -> [MapLayer],
        willChangeRegion: MapViewAction? = nil,
        isChangingRegion: MapViewAction? = nil,
        didChangeRegion: MapViewAction? = nil
    ) {
        self.layers = layers()
        self._region = region
        self.configuration = configuration
        
        self.willChangeRegion = willChangeRegion
        self.isChangingRegion = isChangingRegion
        self.didChangeRegion = didChangeRegion
    }
    
    public func makeUIView(context: Context) -> MapView {
        let mapView = MapView()
        mapView.updateConstraints()
        mapView.add(layers: layers)
        
        configure(mapView, with: configuration, context: context)
        update(mapView)
        
        return mapView
    }

    public func updateUIView(_ mapView: MapView, context: Context) {
        update(mapView)
    }
}



private extension Map {
    func configure(_ mapView: MapView, with configuration: Configuration, context: Context) {
        mapView.region = region
        mapView.style = configuration.style
        mapView.showsUserLocation = configuration.showsUserLocation
        
        mapView.isZoomEnabled = configuration.isZoomEnabled
        mapView.isPitchEnabled = configuration.isPitchEnabled
        mapView.isScrollEnabled = configuration.isScrollEnabled
        mapView.isRotateEnabled = configuration.isRotateEnabled
        
        mapView.willChangeRegion = willChangeRegion
        mapView.isChangingRegion = isChangingRegion
        mapView.didChangeRegion = didChangeRegion
    }
    
    func update(_ mapView: MapView) {
        mapView.remove(layers: mapView.layers)
        mapView.add(layers: layers)
    }
}

public extension Map {
    struct Configuration {
        let style: MapStyle
        let showsUserLocation: Bool
        let userTrackingMode: Bool
        
        let isZoomEnabled: Bool
        let isScrollEnabled: Bool
        let isPitchEnabled: Bool
        let isRotateEnabled: Bool
        
        public init(
            style: MapStyle = SystemMapStyle(),
            showsUserLocation: Bool = false,
            userTrackingMode: Bool = false,
            
            isZoomEnabled: Bool = false,
            isScrollEnabled: Bool = false,
            isPitchEnabled: Bool = false,
            isRotateEnabled: Bool = false
        ) {
            self.style = style
            self.showsUserLocation = showsUserLocation
            self.userTrackingMode = userTrackingMode
            
            self.isZoomEnabled = isZoomEnabled
            self.isPitchEnabled = isPitchEnabled
            self.isScrollEnabled = isScrollEnabled
            self.isRotateEnabled = isRotateEnabled
        }
    }
}
