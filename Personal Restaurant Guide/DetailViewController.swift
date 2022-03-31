//
//  MapViewController.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import UIKit
import CoreLocation
import MapKit
import MessageUI

class RestaurantDetailViewController: UIViewController {

    var restaurant: Restaurant!
    
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addresLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRating()
        setupPin()
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
        setupRating()
    }
    
    @IBAction func routeAction(_ sender: UIButton) {
        guard let location = currentLocation else { return }
        let url = URL(string: "https://www.google.com/maps/dir/?api=1&origin=\(location.latitude)%2C\(location.longitude)&destination=\(restaurant.lat)%2C\(restaurant.long)")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        let text = "Personal Restaurant Guide, restaurant: \(restaurant.name) address:\(restaurant.fullAddress)"
        let textToShare = [text]
        
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.airDrop, .addToReadingList, .assignToContact, .copyToPasteboard,]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func mailAction(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody("\(restaurant.name) \(restaurant.fullAddress)", isHTML: false)
            mail.setSubject("Personal Restaurant Guide")
            
            present(mail, animated: true)
        }
    }
    
    @IBAction func tweetAction(_ sender: UIButton) {
        let text = "\(restaurant.name) \(restaurant.fullAddress)"
        let shareString = "https://twitter.com/intent/tweet?text=\(text)"
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: escapedShareString)
        UIApplication.shared.open(url!)
    }
    
    private func setupRestaurantData() {
        addresLabel.text = restaurant.fullAddress
        nameLabel.text = restaurant.name
        phoneLabel.text = restaurant.phone?.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
    }
    
    private func setupRating() {
        ratingStackView.arrangedSubviews.forEach { subview in
            let ratingButton = subview as? UIButton
            if (ratingButton?.tag ?? 0) <= (restaurant?.rate ?? 0) {
                ratingButton?.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                ratingButton?.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = false
        mapView.showsCompass = true
        
        let coordinateRegion = MKCoordinateRegion(center: restaurant.location,
                                                  latitudinalMeters: 1000,
                                                  longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func setupPin() {
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = restaurant.location;
        myAnnotation.title = restaurant.name
        myAnnotation.subtitle = restaurant.address.address
        mapView.addAnnotation(myAnnotation)
    }
}

extension RestaurantDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension RestaurantDetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last?.coordinate
        locationManager.stopUpdatingLocation()
    }

}
