//
//  Restaurant.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import Foundation
import CoreLocation

class Restaurant: Codable {
    let id: Int
    let lat: Double
    let long: Double
    
    var rate: Int?
    var name: String
    var address: Address
    var phone: String?
    var tags: [Tag]
    
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    var fullAddress: String {
        return [address.address, address.city, address.country].joined(separator: ", ")
    }
    
    func isTagContains(text: String) -> Bool {
        let filtered = tags.map({ $0.name.lowercased() })
        var containsCount = 0
        filtered.forEach { tag in
            if tag.contains(text) {
                containsCount += 1
            }
        }
        return containsCount > 0
    }
    
    init(id: Int,
         location: CLLocationCoordinate2D,
         name: String,
         address: Address,
         phone: String? = nil,
         rate: Int? = 0,
         tags:[Tag] = []) {
        self.id = id
        self.lat = location.latitude
        self.long = location.longitude
        self.name = name
        self.address = address
        self.phone = phone
        self.tags = tags
    }
}
