//
//  CustomAnnotationRenderer.swift
//  
//
//  Created by Piotrek on 25/06/2021.
//

import MapKit


public typealias AnnotationView = MKAnnotationView

public protocol CustomAnnotationView {
        
    var annotationView: UIView { get }
}


extension AnnotationView: CustomAnnotationView {
    @objc open var annotationView: UIView {
        UIView()
    }
}
