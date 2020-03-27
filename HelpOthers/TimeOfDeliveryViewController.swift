//
//  TimeOfDeliveryViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

class TimeOfDeliveryViewController: UIViewController {
    
    @IBOutlet weak var timeOfDeliveryLabel: UILabel!
    @IBOutlet weak var inputAddressLabel: UILabel!
    
    @IBOutlet weak var asapButton: UIButton!
    @IBOutlet weak var nextHourButton: UIButton!
    @IBOutlet weak var nextTwoHoursButton: UIButton!
    @IBOutlet weak var nextThreeHoursButton: UIButton!
    @IBOutlet weak var nextFourHoursButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    static var address = ""
    static var TOD = ""
    static var latitude = ""
    static var longitude = ""
    
    var databaseRef: DatabaseReference!
    var buttonColor: UIColor!
    
    // map kit for address auto complete
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var searchSource: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchBar.isUserInteractionEnabled = false
        
        databaseRef = Database.database().reference()
        
        let df = DateFormatter()
        
        df.dateStyle = .none
        df.timeStyle = .short
        
        buttonColor = asapButton.currentTitleColor
        
        var date = Date()
        print(df.string(from: date))
        let firstHour = df.string(from: date)
        date = date.addingTimeInterval(3600)
        print(df.string(from: date))
        let secondHour = df.string(from: date)
        let nextHourText = "\(firstHour) - \(secondHour)"
        
        date = date.addingTimeInterval(3600)
        let thirdHour = df.string(from: date)
        let twoHoursText = "\(secondHour) - \(thirdHour)"
        
        date = date.addingTimeInterval(3600)
        let fourthHour = df.string(from: date)
        let threeHoursText = "\(thirdHour) - \(fourthHour)"
        
        date = date.addingTimeInterval(3600)
        let fifthHour = df.string(from: date)
        let fourHoursText = "\(fourthHour) - \(fifthHour)"
        
        nextHourButton.setTitle(nextHourText, for: .normal)
        nextTwoHoursButton.setTitle(twoHoursText, for: .normal)
        nextThreeHoursButton.setTitle(threeHoursText, for: .normal)
        nextFourHoursButton.setTitle(fourHoursText, for: .normal)
        
        self.searchResultsTableView.isHidden = true
        submitButton.isHidden = true
        
        let widthForHourButtons = CGFloat(150.0)
        let heightForHourButtons = CGFloat(60.0)
        
        let closeLeftAnchorConstant = CGFloat(20.0)
        let farLeftAnchorConstant = CGFloat(200.0)
        
        /* AUTO LAYOUT */
        // time of delivery label
        timeOfDeliveryLabel.translatesAutoresizingMaskIntoConstraints = false
        timeOfDeliveryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeOfDeliveryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        timeOfDeliveryLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        timeOfDeliveryLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timeOfDeliveryLabel.textAlignment = .center
        
        // time buttons
        asapButton.translatesAutoresizingMaskIntoConstraints = false
        asapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        asapButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        asapButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        asapButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        asapButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        nextHourButton.translatesAutoresizingMaskIntoConstraints = false
        nextHourButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        nextHourButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: closeLeftAnchorConstant).isActive = true
        nextHourButton.widthAnchor.constraint(equalToConstant: widthForHourButtons).isActive = true
        nextHourButton.heightAnchor.constraint(equalToConstant: heightForHourButtons).isActive = true
        nextHourButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextHourButton.titleLabel?.lineBreakMode = .byClipping
        
        nextTwoHoursButton.translatesAutoresizingMaskIntoConstraints = false
        nextTwoHoursButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        nextTwoHoursButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: farLeftAnchorConstant).isActive = true
        nextTwoHoursButton.widthAnchor.constraint(equalToConstant: widthForHourButtons).isActive = true
        nextTwoHoursButton.heightAnchor.constraint(equalToConstant: heightForHourButtons).isActive = true
        nextTwoHoursButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextTwoHoursButton.titleLabel?.lineBreakMode = .byClipping
        
        nextThreeHoursButton.translatesAutoresizingMaskIntoConstraints = false
        nextThreeHoursButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        nextThreeHoursButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: closeLeftAnchorConstant).isActive = true
        nextThreeHoursButton.widthAnchor.constraint(equalToConstant: widthForHourButtons).isActive = true
        nextThreeHoursButton.heightAnchor.constraint(equalToConstant: heightForHourButtons).isActive = true
        nextThreeHoursButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextThreeHoursButton.titleLabel?.lineBreakMode = .byClipping
        
        nextFourHoursButton.translatesAutoresizingMaskIntoConstraints = false
        nextFourHoursButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        nextFourHoursButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: farLeftAnchorConstant).isActive = true
        nextFourHoursButton.widthAnchor.constraint(equalToConstant: widthForHourButtons).isActive = true
        nextFourHoursButton.heightAnchor.constraint(equalToConstant: heightForHourButtons).isActive = true
        nextFourHoursButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextFourHoursButton.titleLabel?.lineBreakMode = .byClipping
        
        // address components
        inputAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        inputAddressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputAddressLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        inputAddressLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        inputAddressLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        inputAddressLabel.textAlignment = .center
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 400).isActive = true
        
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchResultsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 395).isActive = true
        searchResultsTableView.widthAnchor.constraint(equalToConstant: 400).isActive = true
        searchResultsTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 200).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        submitButton.titleLabel?.lineBreakMode = .byClipping
        
    }
    
    @IBAction func asapButtonClicked(_ sender: Any) {
        print("user wants groceries asap")
        updateDatabaseWithTODOf(timeOfDelivery: "ASAP")
        
        asapButton.setTitleColor(UIColor.gray, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextHourClicked(_ sender: Any) {
        print("user wants groceries in next hour")
        updateDatabaseWithTODOf(timeOfDelivery: "next_hour")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(UIColor.gray, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextTwoHoursClicked(_ sender: Any) {
        print("user wants groceries in next two hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_two_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(UIColor.gray, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextThreeHoursClicked(_ sender: Any) {
        print("user wants groceries in next three hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_three_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(UIColor.gray, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextFourHoursClicked(_ sender: Any) {
        print("user wants groceries in next four hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_four_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        var listOfItems = ""
        if WantHelpViewController.helpWith == "groceries" {
            listOfItems = ListGroceriesViewController.listOfGroceries
        } else {
            listOfItems = ListPrescriptionViewController.listOfPrescriptions
        }
        
        let addAddressAndCoord = ["username" : WantHelpViewController.userName,
                                "want_help_with" : WantHelpViewController.helpWith,
                                "list_of_items" : listOfItems,
                                "time_of_delivery" : TimeOfDeliveryViewController.TOD,
                                "address" : TimeOfDeliveryViewController.address,
                                "latitude" : TimeOfDeliveryViewController.latitude,
                                "longitude" : TimeOfDeliveryViewController.longitude]
        
        let updateAddressAndCoord = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addAddressAndCoord]
        
        self.databaseRef.updateChildValues(updateAddressAndCoord)
        
        print("updated with address of user wanting help")
        
        print("user submitted")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "helperpairedload") as! HelperPairedLoadViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func updateDatabaseWithTODOf(timeOfDelivery: String) {
        self.searchBar.isUserInteractionEnabled = true
        TimeOfDeliveryViewController.TOD = timeOfDelivery
        
        var listOfItems = ""
        if WantHelpViewController.helpWith == "groceries" {
            listOfItems = ListGroceriesViewController.listOfGroceries
        } else {
            listOfItems = ListPrescriptionViewController.listOfPrescriptions
        }
        
        let addTimeOfDelivery = ["username" : WantHelpViewController.userName,
            "want_help_with" : WantHelpViewController.helpWith,
        "list_of_items" : listOfItems,
        "time_of_delivery" : timeOfDelivery]
        
        let updateTOD = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addTimeOfDelivery]
        
        self.databaseRef.updateChildValues(updateTOD)
        
        print("updated time of delivery")
    }
}

extension TimeOfDeliveryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("**search bar text changed**")
        searchCompleter.queryFragment = searchText
        self.searchResultsTableView.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        submitButton.isHidden = false
        self.searchResultsTableView.isHidden = true
    }
    
}

extension TimeOfDeliveryViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension TimeOfDeliveryViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle

        return cell
    }
}

extension TimeOfDeliveryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let completion = searchResults[indexPath.row]

        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            print(String(describing: coordinate))
            print(response?.mapItems)
            self.searchBar.text = response?.mapItems[0].name
            
            guard let latitude = coordinate?.latitude else {
                print("no latitude")
                return
            }
            TimeOfDeliveryViewController.latitude = String(latitude)
            guard let longitude = coordinate?.longitude else {
                print("no longitude")
                return
            }
            TimeOfDeliveryViewController.longitude = String(longitude)
            let placemark = response?.mapItems[0].placemark
            let fullAddress = "\(placemark?.subThoroughfare ?? "") \(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? "") \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
            TimeOfDeliveryViewController.address = fullAddress
        }
        searchResults = []
        self.searchResultsTableView.reloadData()
    }
}
