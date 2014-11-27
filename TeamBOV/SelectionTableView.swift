//
//  SelectionTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/16/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

protocol UpdatingTableViewDelegate
{
    func didUpdateData(action: String, className: String)
}

class SelectionTableView: UITableViewController, UpdatingTableViewDelegate {
    var selectionData: NSMutableArray!
    var hud: Hud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var addAction: Selector!
        if (self.title == "Accounts") {
            addAction = "addAccountInfo"
        } else if (self.title == "Inventory") {
            addAction = "addInventoryCategory"
        } else if (self.title == "Sales") {
            addAction = "addSalesCategory"
        } else if (self.title == "Recipes") {
            addAction = "addRecipeCategory"
        }
        
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: addAction)
        navigationItem.rightBarButtonItem = addButton
        
        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addAccountInfo() {
        performSegueWithIdentifier("addAccountDetail", sender: self)
    }
    
    func addInventoryCategory() {
        performSegueWithIdentifier("addInventoryCategory", sender: self)
    }
    
    func addSalesCategory() {
        performSegueWithIdentifier("addSalesCategory", sender: self)
    }
    
    func addRecipeCategory() {
        performSegueWithIdentifier("addRecipeCategory", sender: self)
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Updating account table view delegate
    
    func didUpdateData(action: String, className: String) {
        if (action == "update") {
            navigationController?.popViewControllerAnimated(true)
        } else {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }

        if (className == "Accounts") {
            NSNotificationCenter.defaultCenter().addObserver(
                self, selector: "accountDataReturned:", name: "AccountDataReturned", object: nil)
        } else if (className == "Categories") {
            NSNotificationCenter.defaultCenter().addObserver(
                self, selector: "categoryDataReturned:", name: "CategoryDataReturned", object: nil)
        } else if (className == "SalesCategories") {
            NSNotificationCenter.defaultCenter().addObserver(
                self, selector: "salesCategoryDataReturned:", name: "SalesCategoryDataReturned", object: nil)
        } else if (className == "Recipes") {
            NSNotificationCenter.defaultCenter().addObserver(
                self, selector: "recipeDataReturned:", name: "RecipeDataReturned", object: nil)
        }
        
        fetchData()
    }
    
    func fetchData() {
        hud = Hud(viewFrame: self.view.frame, hudMessage: "Loading")
        hud.StartIndicator()
        self.view.addSubview(hud.HudView())
        
        if (self.title == "Accounts") {
            DataSource.sharedTasks().fetchAllAccountsAsync()
        } else if (self.title == "Inventory") {
            DataSource.sharedTasks().fetchAllCategoryAsync()
        } else if (self.title == "Sales") {
            DataSource.sharedTasks().fetchAllSalesCategoriesAsync()
        } else if (self.title == "Recipes") {
            DataSource.sharedTasks().fetchAllRecipesAsync()
        }
    }
    
    func accountDataReturned(notification: NSNotification) {
        selectionData = DataSource.sharedTasks().returnAccountData()
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "AccountDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    func categoryDataReturned(notification: NSNotification) {
        selectionData = DataSource.sharedTasks().returnInventoryNames()
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "CategoryDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    func salesCategoryDataReturned(notification: NSNotification) {
        selectionData = DataSource.sharedTasks().returnSalesCategoryNames()
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "SalesCategoryDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    func recipeDataReturned(notification: NSNotification) {
        selectionData = DataSource.sharedTasks().returnRecipeData()
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "RecipeDataReturned", object: nil)
        
        tableView.reloadData()
        
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        var object = selectionData[indexPath.row] as NSObject
        
        cell.textLabel.text = (object.valueForKey("Name") as String)
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.title == "Accounts") {
            performSegueWithIdentifier("ShowAccountDetail", sender: indexPath)
        } else if (self.title == "Inventory") {
            performSegueWithIdentifier("ShowCategoryDetail", sender: indexPath)
        } else if (self.title == "Sales") {
            performSegueWithIdentifier("ShowSalesCategoryDetail", sender: indexPath)
        } else if (self.title == "Recipes") {
            performSegueWithIdentifier("ShowRecipeDetail", sender: indexPath)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ShowAccountDetail") {
            var indexPath = sender as NSIndexPath
            let accountDetailTableView = segue.destinationViewController as AccountDetailTableView
            
            accountDetailTableView.delegate = self
            accountDetailTableView.accountData = selectionData.objectAtIndex(indexPath.row) as PFObject
        } else if (segue.identifier == "ShowCategoryDetail") {
            var indexPath = sender as NSIndexPath
            let categoryDetailTableView = segue.destinationViewController as CategoryDetailTableViewController
            var name = selectionData.objectAtIndex(indexPath.row).valueForKey("Name") as String
            
            categoryDetailTableView.title = name
            categoryDetailTableView.categoryData = DataSource.sharedTasks().filterInventoryData(name)
        } else if (segue.identifier == "ShowSalesCategoryDetail") {
            var indexPath = sender as NSIndexPath
            let salesCategoryTableView = segue.destinationViewController as SalesCategoryTableView
            var name = selectionData.objectAtIndex(indexPath.row).valueForKey("Name") as String
            
            salesCategoryTableView.title = name
            salesCategoryTableView.categoryData = DataSource.sharedTasks().filterSalesData(name)
        } else if (segue.identifier == "ShowRecipeDetail") {
            var indexPath = sender as NSIndexPath
            let recipeDetailTableView = segue.destinationViewController as RecipeDetailTableView
            
            recipeDetailTableView.delegate = self
            recipeDetailTableView.accountData = selectionData.objectAtIndex(indexPath.row) as PFObject
        } else if (segue.identifier == "addAccountDetail") {
            let navController = segue.destinationViewController as UINavigationController
            let addAccountDetailTableView = navController.viewControllers[0] as AddAccountTableView
            
            addAccountDetailTableView.delegate = self
        } else if (segue.identifier == "addInventoryCategory") {
            let navController = segue.destinationViewController as UINavigationController
            let addInventoryCategoryTableView = navController.viewControllers[0] as AddInventoryCategoryTableView
            
            addInventoryCategoryTableView.delegate = self
        } else if (segue.identifier == "addSalesCategory") {
            let navController = segue.destinationViewController as UINavigationController
            let addSalesCategoryTableView = navController.viewControllers[0] as AddSalesCategoryTableView
            
            addSalesCategoryTableView.delegate = self
        } else if (segue.identifier == "addRecipeCategory") {
            let navController = segue.destinationViewController as UINavigationController
            let addRecipeTableView = navController.viewControllers[0] as AddRecipeTableView
            
            addRecipeTableView.delegate = self
        }
    }
}
