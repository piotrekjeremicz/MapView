# MapView
A better MapView that extends the MapKit and try to fix as many problems as the author could imagine.

## Installation
Please use Swift Package Manager to get this framework.

## General Usage
`MapView` class represents a UIView class instance that contains a private `MKMapView` object. All interactions with the map is provided by the `MapView` class.

## Features
### Zoom level
Map View has zoom level support that is based on `MKTileOverlay`. The private `zoomTileOverlay` object picks up the information about `{z}` value from the `MKTileOverlayPath`.

    public var zoomLevel: Int
### Map Styling
#### System Style
`SystemMapStyle` class provides a default MKMapView look. You can provide `MKMapType` as an initial parameter to change a map type look.

    mapView.style = SystemMapStyle(with: .hybrid)

#### Google Maps Style
*In progress*

#### Template URL Style
`TemplateUrlMapStyle` provides a possibility to render tile overlay with cache support. You can initialize the object with the link to the server that provides tile rendering.

    mapView.style = TemplateUrlMapStyle("http://www.example.com?x={x}&y={y}&z={z}")
