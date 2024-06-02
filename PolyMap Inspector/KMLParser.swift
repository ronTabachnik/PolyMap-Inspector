//
//  DataManager.swift
//  PolyMap Inspector
//
//  Created by Ron Tabachnik on 2024-05-30.
//

import Foundation
import CoreLocation

class KMLParser: NSObject, XMLParserDelegate {
    var coordinates: [CLLocationCoordinate2D] = []
    var currentElement: String = ""
    var foundCharacters: String = ""

    // start the parsing process
    func parse(data: Data) -> [CLLocationCoordinate2D] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return coordinates
    }

    // parser finds the start of an element
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        foundCharacters = ""
    }

    // parser finds the end of an element
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if currentElement == "coordinates" {
            // Trim whitespace and newlines from the found characters
            let coords = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            let coordinatePairs = coords.split(separator: " ")

            for pair in coordinatePairs {
                let components = pair.split(separator: ",")
                if components.count >= 2 {
                    if let lon = Double(components[0]), let lat = Double(components[1]) {
                        coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                    }
                }
            }
        }
        foundCharacters = ""
    }

    // parser finds characters inside an element
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string  // Accumulate the characters
    }
}
