//
//  SearchResultsViewController.swift
//  GetGoingClass
//
//  Created by Alla Bondarenko on 2019-01-23.
//  Copyright © 2019 SMU. All rights reserved.
//

import UIKit


class SearchResultsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Properties
    
    var places: [PlaceDetails]!
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchResultTableViewCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapViewSegue" {
            if let destination = segue.destination as? MapViewController {
                destination.placeDetails = places
            }
        }
    }
    
    // reference: https://www.raywenderlich.com/462-storyboards-tutorial-for-ios-part-2
    @IBAction func exitMapView(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func segmentedObserver(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.places.sort(by: {$0.name! < $1.name!})
            self.tableView.reloadData()
        case 1:
            self.places.sort(by: {$0.rating ?? 0 > $1.rating ?? 0})
            self.tableView.reloadData()
        default:
            break
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell") as? SearchResultTableViewCell else { return UITableViewCell() }
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.vicinityLabel.text = place.address
        if let placeRating = place.rating {
            cell.rating.rating = Int(placeRating.rounded(.down))
        }
        guard let iconStr = place.icon,
            let iconURL = URL(string: iconStr),
            let imageData = try? Data(contentsOf: iconURL) else {
                cell.iconImageView.image = UIImage(named: "StarEmpty")
                return cell
        }
        cell.iconImageView.image = UIImage(data: imageData)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row was selected at \(indexPath.section) \(indexPath.row)")
        
        let placeId = places[indexPath.row].placeId
        
        showActivityIndicator()
        if placeId == nil {
            self.showAlert(message: "No results")
            return
        }
        GooglePlacesAPI.requestPlaceDetails(placeId!) { (status, json) in
            print(json ?? "")
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            guard let jsonObj = json else { return }
            
            let result = APIParser.parsePlaceDetails(jsonObj: jsonObj)
            if result == nil {
                // make it run in main thread
                DispatchQueue.main.async {
                    self.showAlert(message: "No results")
                }
            } else {
                self.showPlaceDetailsResult(details: result!)
            }
        }
    }
    
    func showAlert(title: String = "Error", message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func showPlaceDetailsResult(details: PlaceDetails) {
        guard let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        
        detailsViewController.details = details
        
        DispatchQueue.main.async {
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}
