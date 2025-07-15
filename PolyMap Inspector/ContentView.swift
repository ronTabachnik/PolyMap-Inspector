//
//  ContentView.swift
//  PolyMap Inspector
//
//  Created by Ron Tabachnik on 2024-05-30.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var showDocumentPicker = false
    @State private var selectedFileURL: URL?
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var distanceToPolygon: CLLocationDistance?
    @State private var tapLocation: CLLocationCoordinate2D?
    @State private var isInsidePolygon: Bool = false
    
    var body: some View {
        VStack {
            if let url = selectedFileURL {
                Text("Selected file: \(url.lastPathComponent)")
                MapView(coordinates: coordinates, tapLocation: $tapLocation, distanceToPolygon: $distanceToPolygon, isInsidePolygon: $isInsidePolygon)
                    .frame(height: 300)
            } else {
                Text("No file selected")
            }
            
            if isInsidePolygon {
                Text("The point is inside the polygon")
            } else if let distance = distanceToPolygon {
                Text("Distance to polygon: \(distance, specifier: "%.2f") meters")
            }
            
            Button(action: {
                showDocumentPicker = true
            }) {
                Text("Select KML File")
            }
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker { url in
                    self.selectedFileURL = url
                    loadKML(from: url)
                    showDocumentPicker = false
                }
            }
        }
        .padding()
    }
    
    private func loadKML(from url: URL) {
        var didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        do {
            let data = try Data(contentsOf: url)
            let parser = KMLParser()
            self.coordinates = parser.parse(data: data)
        } catch {
            print("Failed to load KML file: \(error.localizedDescription)")
        }
    }
}



#Preview {
    ContentView()
}
