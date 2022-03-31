//
//  MapViewController.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import UIKit
import CoreLocation
import MapKit

class RestaurantDetailViewController: UIViewController {

    var restaurant: Restaurant!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupRestaurantData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditVC" {
            (segue.destination as? EditViewController)?.restaurant = restaurant
        }
    }
    
    @IBAction func changeRatingAction(_ sender: UIButton) {
        restaurant?.rate = sender.tag
        RestaurantService.shared.save()
        setRating()
    }
    
    @IBAction func routeAction(_ sender: UIButton) {
        let path = "comgooglemaps://?saddr=&daddr=\(restaurant.location.latitude),\(restaurant.location.longitude)&directionsmode=driving"
        UIApplication.shared.openURL(URL.init(string: path)!)
    }
    
    private func setupRestaurantData() {
        addresLabel.text = restaurant.fullAddress
        nameLabel.text = restaurant.name
        phoneLabel.text = restaurant.phone?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
    }
    
    private func setRating() {
        ratingStackView.arrangedSubviews.forEach { subview in
            let ratingButton = subview as? UIButton
            if (ratingButton?.tag ?? 0) <= (restaurant?.rate ?? 0) {
                ratingButton?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                ratingButton?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
}
