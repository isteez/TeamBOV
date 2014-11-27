//
//  RecipeDetailTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class RecipeDetailTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var accountData: PFObject!
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var directions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var backbutton = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backbutton
        
        if ((accountData.valueForKey("Name")) != nil) {
            name.text = accountData.valueForKey("Name") as String
        }
        
        if ((accountData.valueForKey("Ingredients")) != nil) {
            ingredients.text = accountData.valueForKey("Ingredients") as String
        }
        
        if ((accountData.valueForKey("Directions")) != nil) {
            directions.text = accountData.valueForKey("Directions") as String
        }
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveRecipeInfo")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        tableView.allowsSelection = false
        
        name.delegate = self;
        ingredients.delegate = self
        directions.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "recipeSaved:", name: "RecipeUpdated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "RecipeUpdated", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func saveRecipeInfo() {
        if name.text != nil && ingredients.text != nil && directions.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            accountData.setValue(name.text, forKey: "Name")
            accountData.setValue(ingredients.text, forKey: "Ingredients")
            accountData.setValue(directions.text, forKey: "Directions")
            
            DataSource.sharedTasks().updateRecipeData(accountData)
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An account name, username, and password are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func recipeSaved(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("update", className: "Recipes")
    }

    // MARK: - Text view delegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    // MARK: - Text field delegate
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44;
        }
        return 150;
    }
}