//
//  SalesCategoryTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class SalesCategoryTableView: UITableViewController, UpdatingTableViewDelegate {
    var categoryData: NSMutableArray!
    var hud: Hud!

    override func viewDidLoad() {
        super.viewDidLoad()

        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
        
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addSalesItem")
        navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addSalesItem() {
        performSegueWithIdentifier("addSalesItem", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        var item = (categoryData.objectAtIndex(indexPath.row) as PFObject)
        
        cell.textLabel.text = (item.valueForKey("itemName") as String)
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        
        cell.detailTextLabel?.text = NSString(format: "%@", (item.valueForKey("quantity") as NSNumber))
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowSalesItem", sender: indexPath)
    }
    
    // MARK: - Updating account table view delegate
    
    func didUpdateData(action: String, className: String) {
        if (action == "update") {
            navigationController?.popViewControllerAnimated(true)
        } else {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "salesDataReturned:", name: "SalesDataReturned", object: nil)
        
        fetchData()
    }
    
    func fetchData() {
        hud = Hud(viewFrame: self.view.frame, hudMessage: "Loading")
        hud.StartIndicator()
        self.view.addSubview(hud.HudView())
        
        DataSource.sharedTasks().fetchAllSalesAsync()
    }
    
    func salesDataReturned(notification: NSNotification) {
        categoryData = DataSource.sharedTasks().filterSalesData(self.title!)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "SalesDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addSalesItem") {
            let navController = segue.destinationViewController as UINavigationController
            let addSalesItemTableView = navController.viewControllers[0] as AddSalesItemTableView
            
            addSalesItemTableView.delegate = self
            addSalesItemTableView.category = self.title
        } else if (segue.identifier == "ShowSalesItem") {
            var indexPath = sender as NSIndexPath
            let salesTableView = segue.destinationViewController as SalesItemTableView
            
            salesTableView.delegate = self
            salesTableView.category = self.title
            salesTableView.itemData = categoryData.objectAtIndex(indexPath.row) as PFObject
        }
    }
}
