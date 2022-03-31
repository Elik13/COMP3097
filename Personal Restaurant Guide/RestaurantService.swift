//
//  RestaurantService.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import Foundation
import CoreLocation

class RestaurantService {
    static let shared = RestaurantService()
    
    private var restaurants = [Restaurant]()
    
    func list() -> [Restaurant] {
        if let data = UserDefaults.standard.data(forKey: "restaurants") {
            do {
                let decoder = JSONDecoder()
                self.restaurants = try decoder.decode([Restaurant].self, from: data)
                
                return self.restaurants
            } catch {
                print("Unable to Decode Restaurants (\(error))")
            }
        }
        
        return populate()
    }
    
    func search(with searchText: String) -> [Restaurant] {
        let filtered = self.restaurants.filter { restaurant in
            return restaurant.name.lowercased().contains(searchText.lowercased()) || restaurant.isTagContains(text: searchText.lowercased())
        }
        
        return filtered
    }
    
    func updateRating(for restaurantId: Int, rate: Int) {
        restaurants.first(where: { $0.id == restaurantId })?.rate = rate
        save()
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.restaurants)
            UserDefaults.standard.set(data, forKey: "restaurants")
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Array of Restaurants (\(error))")
        }
    }
    
//    MARK: - Private
    
    private func populate() -> [Restaurant] {
        self.restaurants = [Restaurant(id: 0,
                                      location: CLLocationCoordinate2D(latitude: 55.68321441070155,
                                                                       longitude: 12.610545173018505),
                                      name: "Noma",
                                      address: Address(address: "Refshalevej 96",
                                                       city: "Copenhagen",
                                                       country: "Denmark"),
                                      phone: "+4532963297"),
                           Restaurant(id: 1,
                                      location: CLLocationCoordinate2D(latitude: 55.704183266281376,
                                                                       longitude: 12.572041096290155),
                                      name: "Geranium",
                                      address: Address(address: "Per Henrik Lings Allé 4",
                                                       city: "Copenhagen",
                                                       country: "Denmark"),
                                      phone: "+4569960020"),
                           Restaurant(id: 2,
                                      location: CLLocationCoordinate2D(latitude: 43.116780577433424,
                                                                       longitude: -2.5978039121421292),
                                      name: "Asador Etxebarri",
                                      address: Address(address: "San Juan Plaza 1",
                                                       city: "Bizkaia",
                                                       country: "Spain")),
                           Restaurant(id: 3,
                                      location: CLLocationCoordinate2D(latitude: 41.387897317798455,
                                                                       longitude: 2.1532121913095645),
                                      name: "Disfrutar",
                                      address: Address(address: "C. de Villarroel 163",
                                                       city: "Barcelona",
                                                       country: "Spain"),
                                      phone: "+34933486896"),
                           Restaurant(id: 4,
                                      location: CLLocationCoordinate2D(latitude: 59.33403549490746,
                                                                       longitude: 18.058916528212336),
                                      name: "Frantzén",
                                      address: Address(address: "Klara Norra kyrkogata 26",
                                                       city: "Stockholm",
                                                       country: "Sweden"),
                                      phone: "+468208580")]
        save()
        return self.restaurants
    }
}
