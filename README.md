//
//  README.md
//  PolyMap Inspector
//
//  Created by Ron Tabachnik on 2024-06-02.
//

# KML File Viewer and Polygon Interaction App

## Overview
This application allows users to open and parse KML (Keyhole Markup Language) files to visualize geographic data on a map. It supports displaying polygons and polylines and provides interactive features to analyze the spatial relationships of user-defined points with respect to these shapes.

## Features
- **Open and Parse KML Files**: Load and parse KML files to extract geographic coordinates.
- **Visualize Polygons and Polylines**: Display the parsed data as polygons and polylines on an interactive map.
- **Interactive Map**: Tap on the map to check if the tapped location is inside a polygon.
- **Distance Calculation**: Calculate and display the shortest distance from a tapped location to the nearest edge of a polygon if the location is outside the polygon.

## How It Works
1. **Parsing the KML File**: Uses an XML parser to read and extract coordinates from the KML file.
2. **Rendering on the Map**: Creates `MKPolygon` and `MKPolyline` overlays from the extracted coordinates and adjusts the map view to display them.
3. **Handling User Interaction**: Detects tap gestures on the map, determines the geographic coordinates of the tap, and checks if the tap location is within any displayed polygon.
4. **Distance Calculation**: Calculates the perpendicular distance from the tap point to the nearest edge of the polygon using vector projection.

## Technical Details
- **KML Parsing**: Utilizes `XMLParser` to read and parse coordinate data from KML files.
- **Map Rendering**: Uses `MKMapView` from MapKit to display geographic data with `MKPolygon` and `MKPolyline` overlays.
- **User Interaction Handling**: Manages map interactions and delegate methods through a `Coordinator` class.
- **Distance Calculation Algorithm**: Iterates through each edge of the polygon and uses vector mathematics to determine the shortest distance.

## Usage
1. Load a KML file into the application.
2. Visualize the geographic data on the map.
3. Tap on the map to interact with the polygons and see if a point is inside a polygon or find the distance to the nearest edge if outside.

## Use Cases
- **Geofencing**: Determine if a point is within a designated area.
- **Navigation**: Visualize routes and areas of interest.
- **Spatial Analysis**: Analyze proximity and spatial relationships of points to polygonal areas.

## Setup Instructions
1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the project on a simulator or physical device.

## Contributing
If you would like to contribute to this project, please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License.


