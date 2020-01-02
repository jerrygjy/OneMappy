//
//  FirstViewController.swift
//  OneMappy
//
//  Created by Jerry Goh on 2/1/20.
//  Copyright © 2020 Jerry Goh. All rights reserved.
//

import UIKit
import OneMappy

class FirstViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var searchPageCounter = 1
    var totalNumOfPage = 99
    var searchResultsPlacesArray = [OneMapPlace]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let page = String(self.searchPageCounter)
        self.activityIndicator.startAnimating()
        //  self.isFetchingData = true
        OneMapRequestManager.sharedInstance.getOneMapSearch(keyword: searchBar.text!, pageNumber: page, onSuccess: { (jsonData) in
            
            self.searchResultsPlacesArray.removeAll()
            
            DispatchQueue.main.async {
                //Clear array
                if jsonData["results"] != nil {
                    let content = jsonData["results"]
                    let totalNumPages = jsonData["totalNumPages"]  as! Int
                    _ = jsonData["pageNum"]
                    //Set total page of results
                    self.totalNumOfPage = totalNumPages
                    //Parse results in data array
                    for config in content as! [Dictionary<String, Any>] {
                        
                        let block = config["BLK_NO"] ?? ""
                        let buildingname = config["BUILDING"]  ?? ""
                        let road = config["ROAD_NAME"]  ?? ""
                        let postalcode = config["POSTAL"]  ?? ""
                        let model = OneMapPlace.init()
                        model.BLOCK = block as! String
                        model.BUILDINGNAME = buildingname as! String
                        model.ROAD = road as! String
                        model.POSTALCODE = postalcode as! String
                        model.LATITUDE = config["LATITUDE"] as! String
                        model.LONGITUDE = config["LONGITUDE"] as! String
                        model.ADDRESS = config["ADDRESS"]  as! String
                        model.SEARCHVAL = config["SEARCHVAL"]  as! String
                        self.searchResultsPlacesArray.append(model)
                        
                    }
                    
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    
                }
            }
        }, onFailure: { (_) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        })
        self.activityIndicator.stopAnimating()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let model = self.searchResultsPlacesArray[indexPath.row]
        
        cell.textLabel?.text = model.getAddress()
        cell.detailTextLabel?.text = model.getLocationString()
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResultsPlacesArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

