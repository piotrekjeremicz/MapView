//
//  MapPolylineRenderer.swift
//  MapView
//
//  Created by Piotrek on 05/03/2021.
//

import MapKit

class MapPolylineRenderer: MKOverlayPathRenderer {
    
    var polyline: MKPolyline
    
    var color: UIColor
    var borderColor: UIColor?

    init(polyline: MKPolyline, color: UIColor = .systemBlue, borderColor: UIColor? = nil) {
        self.polyline = polyline
        self.color = color
        self.borderColor = borderColor
        
        super.init(overlay: polyline)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let baseWidth: CGFloat = self.lineWidth / zoomScale
        if let border = borderColor {
            context.setLineWidth(baseWidth * 2)
            context.setLineJoin(CGLineJoin.round)
            context.setLineCap(CGLineCap.round)
            context.addPath(path)
            context.setStrokeColor(border.cgColor)
            context.strokePath()
        }

        let colorspace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorspace, colors: [color.cgColor] as CFArray, locations: [0.0, 1.0])
        
        context.setLineWidth(baseWidth)
        context.setLineJoin(CGLineJoin.round)
        context.setLineCap(CGLineCap.round)
        
        context.addPath(self.path)
        context.saveGState();
        
        context.replacePathWithStrokedPath()
        context.clip();
        
        let boundingBox = self.path.boundingBoxOfPath
        let gradientStart = boundingBox.origin
        let gradientEnd   = CGPoint(x:boundingBox.maxX, y:boundingBox.maxY)
        
        if let gradient = gradient {
            context.drawLinearGradient(gradient, start: gradientStart, end: gradientEnd, options: CGGradientDrawingOptions.drawsBeforeStartLocation);
        }
        
        context.restoreGState()
        
        super.draw(mapRect, zoomScale: zoomScale, in: context)
    }

    override func createPath() {
        let path: CGMutablePath  = CGMutablePath()
        var pathIsEmpty: Bool = true
        for i in 0...self.polyline.pointCount-1 {
            let point: CGPoint = self.point(for: self.polyline.points()[i])
            if pathIsEmpty {
                path.move(to: point)
                pathIsEmpty = false
            } else {
                path.addLine(to: point)
            }
        }
        self.path = path
    }
}
