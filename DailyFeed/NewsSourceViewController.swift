//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 29/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var sourceTableView: UITableView!
    
    var sourceItems = [DailySourceModel]()
    
    var filteredSourceItems = [DailyFeedModel]()
    
    var selectedItem = DailySourceModel?()
    
    var resultsSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.resultsSearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Search NEWS..."
            controller.searchBar.tintColor = UIColor.whiteColor()
            controller.searchBar.sizeToFit()
            
            self.sourceTableView.tableHeaderView = controller.searchBar
            
            return controller
            }()
        
        DailySourceModel.getNewsSource { (newsItem, error) in
            if let news = newsItem {
                _ = news.map { self.sourceItems.append($0) }
                dispatch_async(dispatch_get_main_queue(), {
                    self.sourceTableView.reloadData()
                })
            }
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if self.resultsSearchController.active {
            return self.filteredSourceItems.count
        }
        else {
            return self.sourceItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SourceCell", forIndexPath: indexPath)
        
          if self.resultsSearchController.active {
            cell.textLabel?.text = filteredSourceItems[indexPath.row].name
        }
        else {
            cell.textLabel?.text = sourceItems[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.resultsSearchController.active {
            self.selectedItem = filteredSourceItems[indexPath.row]
        }
        else {
            self.selectedItem = sourceItems[indexPath.row]
        }

        self.performSegueWithIdentifier("sourceUnwindSegue", sender: self)
    }
    
     func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredSourceItems.removeAll(keepCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercaseString.containsString(searchString.lowercaseString) }
            filteredSourceItems = searchResults
            
            self.sourceTableView.reloadData()
        }
    }
}
