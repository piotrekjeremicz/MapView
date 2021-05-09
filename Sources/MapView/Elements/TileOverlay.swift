//
//  TileOverlay.swift
//  MapView
//
//  Created by Piotrek on 04/12/2020.
//

import UIKit
import MapKit

public class TileOverlay: MKTileOverlay {

    public var tag: Int = 0
    public var canReloadTile: Bool = true

    public var willReloadTile: (() -> ())? = nil
    public var didReloadTile: (() -> ())? = nil
    
    private let templatePath: String?
    private let cache = NSCache<NSURL, NSData>()

    public override init(urlTemplate URLTemplate: String?) {
        templatePath = URLTemplate
        
        super.init(urlTemplate: URLTemplate)
    }
    
    public override func url(forTilePath path: MKTileOverlayPath) -> URL {
        guard canReloadTile else { return URL(string: templatePath!)! }
        guard let templatePath = templatePath,
              templatePath.contains("{x}"),
              templatePath.contains("{y}"),
              templatePath.contains("{z}") else {
            fatalError("Please specify correct url for Tile Overlay style. The tile path should has specific format - http://www.example.com?x={x}&y={y}&z={z}")
        }
        
        let tileOverlayPath = templatePath.replacingOccurrences(of: "{x}", with: "\(path.x)")
            .replacingOccurrences(of: "{y}", with: "\(path.y)")
            .replacingOccurrences(of: "{z}", with: "\(path.z)")
        
        return URL(string: tileOverlayPath)!
    }
    
    public override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {
        willReloadTile?()
        guard canReloadTile else {
            result(nil, nil)
            return
        }
        
        let tileUrl = url(forTilePath: path)

        if let cachedData = cache.object(forKey: tileUrl as NSURL) as Data? {
            result(cachedData, nil)
        } else {
            URLSession.shared.dataTask(with: URLRequest(url: tileUrl)) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let data = data {
                        self?.cache.setObject(data as NSData, forKey: tileUrl as NSURL)
                    }
                    result(data, error)
                    self?.didReloadTile?()
                }
            }.resume()
        }
    }
}
