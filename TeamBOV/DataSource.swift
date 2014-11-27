//
//  DataSource.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/16/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import Foundation

class DataSource: NSObject {
    var accountArray: NSMutableArray = []
    var inventoryCategories: NSMutableArray = []
    var inventoryItems: NSMutableArray = []
    var salesCategories: NSMutableArray = []
    var salesItems: NSMutableArray = []
    var recipeArray: NSMutableArray = []
    var dataArray: NSMutableArray = []
    
    class func sharedTasks() -> DataSource {
        return _sharedTasks
    }
    
    override init() {
        super.init()
        
        println("I am alive!")
    }
    
    // Getting Categories
    
    func fetchAllCategoryAsync() {
        var query = PFQuery(className: "Categories")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) category(s).")
                self.handOffCategoryData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }

    func handOffCategoryData(data: [AnyObject]!) {
        inventoryCategories = []
        
        for object in data {
            inventoryCategories.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("CategoryDataReturned", object: nil)
    }
    
    func returnInventoryNames() -> NSMutableArray {
        return inventoryCategories
    }
    
    func createNewCategory(name: String) {
        var account = PFObject(className: "Categories")
        account["Name"] = name
        account.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("CategoryCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    // Getting Inventory items
    
    func fetchAllInventoryItemsAsync() {
        var query = PFQuery(className: "Inventory")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) inventory(s).")
                self.handOffInventoryData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func handOffInventoryData(data: [AnyObject]!) {
        inventoryItems = []
        
        for object in data {
            inventoryItems.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("InventoryDataReturned", object: nil)
    }
    
    func filterInventoryData(category: String) -> NSMutableArray {
        var filteredItems: NSMutableArray = []
        
        for item in inventoryItems {
            if item.valueForKey("category") as String == category {
                filteredItems.addObject(item)
            }
        }
        
        return filteredItems
    }
    
    func updateInventoryItemData(object: PFObject!) {
        var query = PFQuery(className:"Inventory")
        query.getObjectInBackgroundWithId(object.objectId) {
            (item: PFObject!, error: NSError!) -> Void in
            if error == nil {
                item["itemName"] = object["itemName"]
                item["quantity"] = object["quantity"]
                item["details"] = object["details"]
                item["category"] = object["category"]
                item.saveInBackgroundWithBlock {
                    (bool, error) -> Void in
                    if error == nil {
                        NSNotificationCenter.defaultCenter().postNotificationName("ItemUpdated", object: nil)
                    } else {
                        NSLog("%@", error)
                    }
                }
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    func createNewInventoryItem(name: String, quantity: NSNumber, details: String, category: String) {
        var item = PFObject(className: "Inventory")
        item["itemName"] = name
        item["quantity"] = quantity
        item["details"] = details
        item["category"] = category
        item.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("ItemCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    // Getting Accounts
    
    func fetchAllAccountsAsync() {
        var query = PFQuery(className: "Accounts")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) account(s).")
                self.handOffAccountData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func handOffAccountData(data: [AnyObject]!) {
        accountArray = []
        
        for object in data {
            accountArray.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("AccountDataReturned", object: nil)
    }
    
    func returnAccountData() -> NSMutableArray {
        return accountArray
    }
    
    func updateAccountData(object: PFObject!) {
        var query = PFQuery(className:"Accounts")
        query.getObjectInBackgroundWithId(object.objectId) {
            (account: PFObject!, error: NSError!) -> Void in
            if error == nil {
                account["Name"] = object["Name"]
                account["Username"] = object["Username"]
                account["Password"] = object["Password"]
                account["Details"] = object["Details"]
                account.saveInBackgroundWithBlock {
                    (bool, error) -> Void in
                    if error == nil {
                        NSNotificationCenter.defaultCenter().postNotificationName("AccountUpdated", object: nil)
                    } else {
                        NSLog("%@", error)
                    }
                }
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    func createNewAccount(name: String, username: String, password: String, details: String) {
        var account = PFObject(className: "Accounts")
        account["Name"] = name
        account["Username"] = username
        account["Password"] = password
        account["Details"] = details
        account.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("AccountCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    // Getting Sales Categories
    
    func fetchAllSalesCategoriesAsync() {
        var query = PFQuery(className: "SalesCategories")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) sales category(s).")
                self.handOffSalesCategoryData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func handOffSalesCategoryData(data: [AnyObject]!) {
        salesCategories = []
        
        for object in data {
            salesCategories.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("SalesCategoryDataReturned", object: nil)
    }
    
    func returnSalesCategoryNames() -> NSMutableArray {
        return salesCategories
    }
    
    func createNewSalesCategory(name: String) {
        var account = PFObject(className: "SalesCategories")
        account["Name"] = name
        account.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("SalesCategoryCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    // Getting Sales
    
    func fetchAllSalesAsync() {
        var query = PFQuery(className: "Sales")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) sale(s).")
                self.handOffSalesData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func handOffSalesData(data: [AnyObject]!) {
        salesItems = []
        
        for object in data {
            salesItems.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("SalesDataReturned", object: nil)
    }
    
    func filterSalesData(category: String) -> NSMutableArray {
        var filteredItems: NSMutableArray = []
        
        for item in salesItems {
            if item.valueForKey("category") as String == category {
                filteredItems.addObject(item)
            }
        }
        
        return filteredItems
    }
    
    func updateSalesData(object: PFObject!) {
        var query = PFQuery(className:"Sales")
        query.getObjectInBackgroundWithId(object.objectId) {
            (item: PFObject!, error: NSError!) -> Void in
            if error == nil {
                item["itemName"] = object["itemName"]
                item["quantity"] = object["quantity"]
                item["details"] = object["details"]
                item["category"] = object["category"]
                item.saveInBackgroundWithBlock {
                    (bool, error) -> Void in
                    if error == nil {
                        NSNotificationCenter.defaultCenter().postNotificationName("SalesUpdated", object: nil)
                    } else {
                        NSLog("%@", error)
                    }
                }
            } else {
                NSLog("%@", error)
            }
        }
    }

    func createNewSalesItem(name: String, quantity: NSNumber, details: String, category: String) {
        var item = PFObject(className: "Sales")
        item["itemName"] = name
        item["quantity"] = quantity
        item["details"] = details
        item["category"] = category
        item.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("SalesItemCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    // Getting Recipes
    
    func fetchAllRecipesAsync() {
        var query = PFQuery(className: "Recipes")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(objects.count) recipe(s).")
                self.handOffRecipeData(objects)
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    func handOffRecipeData(data: [AnyObject]!) {
        recipeArray = []
        
        for object in data {
            recipeArray.addObject(object)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("RecipeDataReturned", object: nil)
    }
    
    func returnRecipeData() -> NSMutableArray {
        return recipeArray
    }
    
    func updateRecipeData(object: PFObject!) {
        var query = PFQuery(className:"Recipes")
        query.getObjectInBackgroundWithId(object.objectId) {
            (recipe: PFObject!, error: NSError!) -> Void in
            if error == nil {
                recipe["Name"] = object["Name"]
                recipe["Ingredients"] = object["Ingredients"]
                recipe["Directions"] = object["Directions"]
                recipe.saveInBackgroundWithBlock {
                    (bool, error) -> Void in
                    if error == nil {
                        NSNotificationCenter.defaultCenter().postNotificationName("RecipeUpdated", object: nil)
                    } else {
                        NSLog("%@", error)
                    }
                }
            } else {
                NSLog("%@", error)
            }
        }
    }
    
    func createNewRecipe(name: String, ingredients: String, directions: String) {
        var recipe = PFObject(className: "Recipes")
        recipe["Name"] = name
        recipe["Ingredients"] = ingredients
        recipe["Directions"] = directions
        recipe.saveInBackgroundWithBlock {
            (bool, error) -> Void in
            if error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName("RecipeCreated", object: nil)
            } else {
                NSLog("%@", error)
            }
        }
    }

    // Returns all data
    
    func returnData() -> NSMutableArray {
        dataArray.addObject(inventoryCategories)
        dataArray.addObject(recipeArray)
        dataArray.addObject(salesCategories)
        dataArray.addObject(accountArray)
        
        return dataArray
    }
}

let _sharedTasks: DataSource = { DataSource() } ()


