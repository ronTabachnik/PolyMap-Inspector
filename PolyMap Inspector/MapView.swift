//
//  MapView.swift
//  PolyMap Inspector
//
//  Created by Ron Tabachnik on 2024-05-30.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinates: [CLLocationCoordinate2D]
    @Binding var tapLocation: CLLocationCoordinate2D?
    @Binding var distanceToPolygon: CLLocationDistance?
    @Binding var isInsidePolygon: Bool
    
    // configures the MKMapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // tap gesture recognizer to the map view
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays) // Remove existing overlays
        
        // >2 coordinates, create and add a polygon
        if coordinates.count > 2 {
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            uiView.addOverlay(polygon)
            uiView.setVisibleMapRect(polygon.boundingMapRect, animated: true)
        // ==2 coordinates, create and add a polyline overlay
        } else if coordinates.count == 2 {
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            uiView.addOverlay(polyline)
            uiView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
        }
    }

    // manage map interactions and delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // handle map interactions and delegate methods
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // Handles tap gestures
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let tapPoint = gestureRecognizer.location(in: mapView)
            let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            parent.tapLocation = tapCoordinate

            if let polygon = mapView.overlays.first(where: { $0 is MKPolygon }) as? MKPolygon {
                parent.isInsidePolygon = isLocation(tapCoordinate, inside: polygon)
                if parent.isInsidePolygon {
                    parent.distanceToPolygon = nil
                } else {
                    parent.distanceToPolygon = calculateDistanceToPolygon(tapCoordinate, polygon: polygon)
                }
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.black.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.black
                renderer.lineWidth = 1
                return renderer
            } else if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.black
                renderer.lineWidth = 1
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        // is inside a polygon
        private func isLocation(_ location: CLLocationCoordinate2D, inside polygon: MKPolygon) -> Bool {
            let polygonRenderer = MKPolygonRenderer(polygon: polygon)
            let mapPoint = MKMapPoint(location)
            let point = polygonRenderer.point(for: mapPoint)
            return polygonRenderer.path.contains(point)
        }

        // distance to the nearest edge of a polygon
        private func calculateDistanceToPolygon(_ location: CLLocationCoordinate2D, polygon: MKPolygon) -> CLLocationDistance {
            let polygonPoints = polygon.points()
            let polygonPointCount = polygon.pointCount
            var minDistance: CLLocationDistance = .greatestFiniteMagnitude

            // Iterate through each segment of the polygon
            for i in 0..<polygonPointCount {
                let point1 = polygonPoints[i]
                let point2 = polygonPoints[(i + 1) % polygonPointCount]

                let segmentDistance = distanceFrom(location: location, toSegment: (point1, point2))
                if segmentDistance < minDistance {
                    minDistance = segmentDistance
                }
            }

            return minDistance
        }

        // distance to a line segment
        private func distanceFrom(location: CLLocationCoordinate2D, toSegment segment: (MKMapPoint, MKMapPoint)) -> CLLocationDistance {
            let point = MKMapPoint(location)
            let a = segment.0
            let b = segment.1

            let ab = CGPoint(x: b.x - a.x, y: b.y - a.y)
            let ap = CGPoint(x: point.x - a.x, y: point.y - a.y)
            let ab2 = ab.x * ab.x + ab.y * ab.y
            let ap_ab = ap.x * ab.x + ap.y * ab.y
            let t = max(0, min(1, ap_ab / ab2))

            let closest = MKMapPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)
            return point.distance(to: closest)
        }
    }
}

