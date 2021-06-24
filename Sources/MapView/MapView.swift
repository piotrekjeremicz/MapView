//
//  MapView.swift
//  MapView
//
//  Created by Piotrek on 19/09/2020.
//  Copyright © 2020 Piotr Jeremicz. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation

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

    public var region: CoordinateRegion {
        get { mapView.region }
        set { mapView.region = newValue }
    }
    
    public var style: MapStyle = SystemMapStyle() {
        didSet { setupTileOverlays() }
    }
    
    public var centerCoordinate: Coordinate {
        get { mapView.centerCoordinate }
        set { mapView.centerCoordinate = newValue }
    }
    
    public var edges: Map.Edges {
        let coordinates = [
            CGPoint(x: self.bounds.minX, y: self.bounds.minY),
            CGPoint(x: self.bounds.maxX, y: self.bounds.minY),
            CGPoint(x: self.bounds.minX, y: self.bounds.maxY),
            CGPoint(x: self.bounds.maxX, y: self.bounds.maxY),
        ].map({ mapView.convert($0, toCoordinateFrom: self) })
        
        return Map.Edges(
            topLeft: coordinates[0],
            topRight: coordinates[1],
            bottomLeft: coordinates[2],
            bottomRight: coordinates[3]
        )
    }
    
    public var showsUserLocation: Bool {
        get { mapView.showsUserLocation }
        set {
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = newValue
        }
    }
    
    private let mapView = MKMapView(frame: .zero)
    private let zoomTileOverlay = ZoomTileOverlay()

    private var privateLayers: [MapLayer] = []
    private var registeredClasses: [String: AnyClass] = [:]
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
        
        return manager
    }()
    
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

public extension MapView {
    func configure(_ configuration: Map.Configuration) {
        region = region
        style = configuration.style
        showsUserLocation = configuration.showsUserLocation
        
        isZoomEnabled = configuration.isZoomEnabled
        isPitchEnabled = configuration.isPitchEnabled
        isScrollEnabled = configuration.isScrollEnabled
        isRotateEnabled = configuration.isRotateEnabled
    }
    
    func add(layer: MapLayer) {
        privateLayers.append(layer)
        
        switch layer {
        case is AnnotationLayer:
            guard let annotationLayer = layer as? AnnotationLayer else { return }
            add(annotation: annotationLayer.annotation)
        case is AnnotationsLayer:
            guard let annotationsLayer = layer as? AnnotationsLayer else { return }
            add(annotations: annotationsLayer.annotations)
            
        default:
            break
        }
    }
    
    func add(layers: [MapLayer]) {
        layers.forEach { add(layer: $0) }
    }
    
    func remove(layer: MapLayer) {
        switch layer {
        case is AnnotationLayer:
            guard let annotationLayer = layer as? AnnotationLayer else { return }
            remove(annotation: annotationLayer.annotation)
            
        case is AnnotationsLayer:
            guard let annotationsLayer = layer as? AnnotationsLayer else { return }
            remove(annotations: annotationsLayer.annotations)
            
        default:
            break
        }
        
        privateLayers.removeAll(where: { $0.identifier == layer.identifier })
    }
    
    func remove(layers: [MapLayer]) {
        layers.forEach({ remove(layer: $0) })
    }
}

private extension MapView {
    func setupView() {
        backgroundColor = .clear
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
    }
    
    func setupTileOverlays() {
        if !mapView.overlays.contains(where: { $0 is ZoomTileOverlay }) { mapView.addOverlay(zoomTileOverlay) }
        
        if let style = style as? SystemMapStyle {
            mapView.mapType = style.type
        } else {
            mapView.removeOverlays(mapView.overlays.filter({ $0 is TileOverlay }))
            mapView.addOverlay(style.tileOverlay)
        }
    }
    
    func getAnnotations() -> [Annotation] {
        var annotations: [Annotation] = []
        
        privateLayers.forEach { layer in
            if let layer = layer as? AnnotationLayer {
                annotations.append(layer.annotation)
            } else if let layer = layer as? AnnotationsLayer {
                annotations += layer.annotations
            }
        }
        
        return annotations
    }
    
    func add(annotation: Annotation) {
        guard !mapView.annotations.contains(where: { annotation.model == $0 as! AnnotationModel }) else { return }
        //DEMO
        register(Swift.type(of: annotation.renderer), identifier: annotation.model.identifier)
        mapView.addAnnotation(annotation.model)
    }
    
    func add(annotations: [Annotation]) {
        annotations.forEach({ add(annotation: $0) })
    }
    
    func remove(annotation: Annotation) {
        mapView.removeAnnotation(annotation.model)
    }
    
    func remove(annotations: [Annotation]) {
        annotations.forEach({ remove(annotation: $0) })
    }
    
    //DEMO
    func register(_ anyClass: AnyClass, identifier: String) {
        guard !registeredClasses.keys.contains(identifier) else { return }
        registeredClasses[identifier] = anyClass
        
        mapView.register(anyClass, forAnnotationViewWithReuseIdentifier: identifier)
    }
}

extension MapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        guard let annotation = annotation as? AnnotationModel else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.identifier, for: annotation)
        annotationView.annotation = annotation
        
        return annotationView
    }
    
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
