//
//  AddRecipeTableView.swift
//  TeamBOV
//
//  Created by Stephen Kyles on 11/22/14.
//  Copyright (c) 2014 Blue Owl Labs. All rights reserved.
//

import UIKit

class AddRecipeTableView: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    var hud: Hud!
    var delegate: UpdatingTableViewDelegate?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var directions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Recipe"
        
        var saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveNewRecipe")
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.rightBarButtonItem?.enabled = false
        
        var cancelButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "cancelNewRecipe")
        navigationItem.leftBarButtonItem = cancelButton
        
        tableView.allowsSelection = false
        
        name.delegate = self;
        ingredients.delegate = self;
        directions.delegate = self;
    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: "recipeCreated:", name: "RecipeCreated", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(
            self, name: "RecipeCreated", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancelNewRecipe() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveNewRecipe() {
        if name.text != nil && ingredients.text != nil && directions.text != nil {
            hud = Hud(viewFrame: self.view.frame, hudMessage: "Saving")
            hud.StartIndicator()
            self.view.addSubview(hud.HudView())
            
            DataSource.sharedTasks().createNewRecipe(name.text, ingredients: ingredients.text, directions: directions.text)
        } else {
            var alert = UIAlertView(title: "Cannot Save", message: "An account name, username, and password are needed.", delegate: nil, cancelButtonTitle: "Okay")
            alert.show()
        }
    }
    
    func recipeCreated(notification: NSNotification) {
        hud.StopIndicator()
        hud.HudView().removeFromSuperview()
        
        delegate?.didUpdateData("add", className: "Recipes")
    }
    
    // MARK: - Text view delegate
    
    func textViewDidBeginEditing(textField: UITextView!) {
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