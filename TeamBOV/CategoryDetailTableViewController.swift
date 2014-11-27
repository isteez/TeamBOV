//
//  CategoryDetailTableViewController.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UITableViewController, UpdatingTableViewDelegate {
    var categoryData: NSMutableArray!
    var hud: Hud!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
        
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addInventoryItem")
        navigationItem.rightBarButtonItem = addButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addInventoryItem() {
        performSegueWithIdentifier("addInventoryItem", sender: self)
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
        performSegueWithIdentifier("ShowInventoryItem", sender: indexPath)
    }

    // MARK: - Updating account table view delegate
    
    func didUpdateData(action: String, className: String) {
        if (action == "update") {
            navigationController?.popViewControllerAnimated(true)
        } else {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "inventoryDataReturned:", name: "InventoryDataReturned", object: nil)
        
        fetchData()
    }
    
    func fetchData() {
        hud = Hud(viewFrame: self.view.frame, hudMessage: "Loading")
        hud.StartIndicator()
        self.view.addSubview(hud.HudView())
        
        DataSource.sharedTasks().fetchAllInventoryItemsAsync()
    }
    
    func inventoryDataReturned(notification: NSNotification) {
        categoryData = DataSource.sharedTasks().filterInventoryData(self.title!)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "InventoryDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "addInventoryItem") {
            let navController = segue.destinationViewController as UINavigationController
            let addInventoryItemTableView = navController.viewControllers[0] as AddInventoryItemTableView
            addInventoryItemTableView.delegate = self
            addInventoryItemTableView.category = self.title
        } else if (segue.identifier == "ShowInventoryItem") {
            var indexPath = sender as NSIndexPath
            let inventoryItemTableView = segue.destinationViewController as InventoryItemTableView
            inventoryItemTableView.delegate = self
            inventoryItemTableView.category = self.title
            inventoryItemTableView.itemData = categoryData.objectAtIndex(indexPath.row) as PFObject
        }
    }
}
