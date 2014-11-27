//
//  MainTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/15/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class MainTableView: UITableViewController {
    var dataArray: NSMutableArray = []
    var cellData: NSMutableArray = ["Inventory", "Recipes", "Sales", "Accounts", "Sales Sheet"]
    var accountsDictionary: NSDictionary!
    var hud: Hud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "TeamBOV"
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "accountDataReturned:", name: "AccountDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "categoryDataReturned:", name: "CategoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "inventoryDataReturned:", name: "InventoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "salesCategoryDataReturned:", name: "SalesCategoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "salesDataReturned:", name: "SalesDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "recipeDataReturned:", name: "RecipeDataReturned", object: nil)
        
        fetchData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "AccountDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "CategoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "InventoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "SalesCategoryDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "SalesDataReturned", object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "RecipeDataReturned", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchData() {
        hud = Hud(viewFrame: self.view.frame, hudMessage: "Loading")
        hud.StartIndicator()
        self.view.addSubview(hud.HudView())
        
        DataSource.sharedTasks().fetchAllCategoryAsync()
    }
    
    func categoryDataReturned(notification: NSNotification) {
        DataSource.sharedTasks().fetchAllInventoryItemsAsync()
    }
    
    func inventoryDataReturned(notification: NSNotification) {
        DataSource.sharedTasks().fetchAllAccountsAsync()
    }

    func accountDataReturned(notification: NSNotification) {
        DataSource.sharedTasks().fetchAllSalesCategoriesAsync()
    }
    
    func salesCategoryDataReturned(notification: NSNotification) {
        DataSource.sharedTasks().fetchAllSalesAsync()
    }
    
    func salesDataReturned(notification: NSNotification) {
        DataSource.sharedTasks().fetchAllRecipesAsync()
    }
    
    func recipeDataReturned(notification: NSNotification) {
        dataArray = DataSource.sharedTasks().returnData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var name = (cellData.objectAtIndex(indexPath.row) as String)
        
        cell.textLabel.text = name
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        cell.imageView.image = UIImage(named: name)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != cellData.count-1) {
            performSegueWithIdentifier("ShowSelection", sender: indexPath)
            
        } else {
            performSegueWithIdentifier("ShowSalesSheet", sender: indexPath)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowSelection") {
            var indexPath = sender as NSIndexPath
            let selectionTableView = segue.destinationViewController as SelectionTableView
            
            selectionTableView.title = (cellData.objectAtIndex(indexPath.row) as String)
            selectionTableView.selectionData = dataArray.objectAtIndex(indexPath.row) as NSMutableArray
        } else if (segue.identifier == "ShowSalesSheet") {
            var indexPath = sender as NSIndexPath
            var name = (cellData.objectAtIndex(indexPath.row) as String)
            let salesSheetViewController = segue.destinationViewController as SalesSheetViewController
            
            salesSheetViewController.title = name
            salesSheetViewController.pdf = NSBundle.mainBundle().pathForResource("SalesSheet", ofType: "pdf")
        }
    }
}
