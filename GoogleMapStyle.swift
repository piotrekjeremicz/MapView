//
//  GoogleMapStyle.swift
//  MapView
//
//  Created by Piotrek on 07/10/2020.
//

import MapKit

class GoogleMapStyle: MapStyle {
    
    private let baseUrl = URL(string: "https://mts0.google.com/vt/lyrs=m@289000001&hl=en&src=app&x={x}&y={y}&z={z}&s=DGal")
    
    private let jsonFileUrl: URL?
    private let templateUrl: URL?
    
    init(json url: URL) {
        templateUrl = nil
        jsonFileUrl = url
    }
    
    init(url template: URL) {
        jsonFileUrl = nil
        templateUrl = template
    }
    
    var urlTemplate: String? {
        if let url = templateUrl {
            return url.path
        } else if let jsonUrl = jsonFileUrl, let baseUrl = baseUrl  {
            let urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
            
            return urlComponents?.path
        } else {
            return nil
        }
    }
}
