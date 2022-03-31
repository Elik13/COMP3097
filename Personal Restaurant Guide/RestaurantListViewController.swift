//
//  ViewController.swift
//  Personal Restaurant Guide
//
//  Created by Elik on 31.03.2022.
//

import UIKit

class RestaurantListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var allRestaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        
        self.allRestaurants = RestaurantService.shared.list()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapVC" {
            (segue.destination as? RestaurantDetailViewController)?.restaurant = sender as? Restaurant
        }
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        cell.textLabel?.text = allRestaurants[indexPath.row].name
        cell.detailTextLabel?.text = allRestaurants[indexPath.row].fullAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRestaurants.count
    }
}

extension RestaurantListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = allRestaurants[indexPath.row]
        performSegue(withIdentifier: "showMapVC", sender: restaurant)
    }
}

extension RestaurantListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBarCancelButtonClicked(searchBar)
            searchBar.resignFirstResponder()
        } else {
            self.allRestaurants = RestaurantService.shared.search(with: searchText)
            tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.allRestaurants = RestaurantService.shared.list()
        tableView.reloadData()
    }
}
