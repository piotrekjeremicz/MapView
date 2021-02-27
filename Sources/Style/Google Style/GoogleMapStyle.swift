//
//  GoogleMapStyle.swift
//  MapView
//
//  Created by Piotrek on 07/10/2020.
//

import MapKit

class GoogleMapStyle: MapStyle {
    
    private let jsonFileUrl: URL?
    private let templateUrl: String?
    
    private let baseUrl = URL(string: "https://mts0.google.com/vt/lyrs=m@289000001&hl=en&src=app&x={x}&y={y}&z={z}&s=DGal")
    
    init(json url: URL) {
        templateUrl = nil
        jsonFileUrl = url
    }
    
    init(template path: String) {
        jsonFileUrl = nil
        templateUrl = path
    }
    
    var urlTemplate: String? {
        if let url = templateUrl {
            return url
        } else if let jsonUrl = jsonFileUrl, let baseUrl = baseUrl  {
            let jsonArray = loadJSON(from: jsonUrl)
            
            guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { return baseUrl.path }
            urlComponents.queryItems = createQueryItems(from: jsonArray)
            
            return urlComponents.path
        } else {
            return nil
        }
    }
    
    private func loadJSON(from url: URL) -> [[String: Any]] {
        return []
    }
    
    private func createQueryItems(from json: [[String: Any]]) -> [URLQueryItem] {
        return []
    }
}

struct GoogleStyle {
    let featureType: String
    let elementType: String
}

struct GoogleStyler {
    let color: String?
    let visibility: String?
}
